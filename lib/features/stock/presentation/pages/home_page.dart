import 'package:flutter/material.dart';
import 'package:stocker/core/theme/app_colors.dart';
import 'package:stocker/features/auth/presentation/controller/auth_controller.dart';
import 'package:stocker/features/auth/presentation/pages/login_page.dart';
import 'package:stocker/features/company/presentation/controller/company_controller.dart';
import 'package:stocker/features/company/presentation/pages/company_page.dart';
import 'package:stocker/features/stock/domain/entities/stock_entity.dart';
import 'package:stocker/features/stock/presentation/controller/stock_controller.dart';
import 'package:stocker/features/stock/presentation/pages/stock_detail_sheet.dart';
import 'package:stocker/features/stock/presentation/pages/user_management_page.dart';
import 'package:stocker/shared/services/company_session_service.dart';

class HomePage extends StatefulWidget {
  final StockController stockController;
  final CompanyController companyController;
  final AuthController authController;

  const HomePage({
    super.key,
    required this.stockController,
    required this.companyController,
    required this.authController,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchController = TextEditingController();

  List<StockEntity> items = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> _search() async {
    setState(() {
      isLoading = true;
      items = [];
      errorMessage = null;
    });

    final result = await widget.stockController.search(searchController.text);

    setState(() {
      items = result.items;
      errorMessage = result.error;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text("SaldoJá", style: TextStyle(color: colors.inversePrimary)),
        actions: [
          IconButton(
            icon: Icon(
              Icons.admin_panel_settings_outlined,
              color: colors.inversePrimary,
            ),
            tooltip: "Gerenciar usuários",
            onPressed: _openUserManager,
          ),
          IconButton(
            icon: Icon(Icons.logout, color: colors.inversePrimary),
            tooltip: "Sair",
            onPressed: () async {
              await widget.authController.repository.signOut();

              final session = CompanySessionService();
              await session.clear();

              if (!context.mounted) return;

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => LoginPage(
                        controller: widget.authController,
                        companyController: widget.companyController,
                        stockController: widget.stockController,
                      ),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Icon(Icons.search, size: 48, color: colors.primary),

                const SizedBox(height: 16),

                Text(
                  "Consultar estoque",
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                const SizedBox(height: 8),

                Text(
                  "Digite o código ou descrição do produto",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                const SizedBox(height: 24),

                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "Ex: Parafuso, 12345...",
                    suffixIcon:
                        searchController.text.isNotEmpty
                            ? IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                setState(() {
                                  searchController.clear();
                                  items = [];
                                });
                              },
                            )
                            : null,
                  ),
                  onChanged: (_) => setState(() {}),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _search,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Buscar",
                      style: TextStyle(color: colors.inversePrimary),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(child: Divider()),
                    const SizedBox(width: 8),
                    Text(
                      "Resultados",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Divider()),
                  ],
                ),

                // 👇 AQUI entra sua lógica
                Expanded(child: _buildResult()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResult() {
    final colors = Theme.of(context).colorScheme;
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 40),

                const SizedBox(height: 12),

                Text(
                  _friendlyError(errorMessage!),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 8),

                // 🔍 detalhe técnico (menor)
                Text(
                  errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (items.isEmpty) {
      return const Center(child: Text("Nenhum resultado encontrado"));
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (_, index) {
        final item = items[index];
        final total = item.locations.fold<double>(
          0,
          (sum, loc) => sum + loc.available,
        );

        Color getStockColor(double value, BuildContext context) {
          if (value == 0) return Colors.red;
          if (value < 10) return Colors.orange;
          return Colors.green;
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 PRODUTO HEADER
              Row(
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 20,
                    color: colors.primary,
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      item.productName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  IconButton(
                    icon: const Icon(Icons.info_outline),
                    onPressed: () => _openDetails(item),
                  ),
                ],
              ),

              const SizedBox(height: 4),

              Text(
                "Código: ${item.productCode}",
                style: Theme.of(context).textTheme.bodySmall,
              ),

              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Total disponível: ${total.toStringAsFixed(2)}",
                  style: TextStyle(
                    color: colors.inversePrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // 🔹 DEPÓSITOS
              ...item.locations.map((loc) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          loc.deposit,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Text(
                        loc.available.toStringAsFixed(2),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: getStockColor(loc.available, context),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _openDetails(StockEntity item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => StockDetailSheet(item: item),
    );
  }

  void _openUserManager() {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => UserManagementPage(controller: widget.authController),
      ),
    );
  }

  String _friendlyError(String error) {
    if (error.contains("Credenciais inválidas")) {
      return "Erro de autenticação na empresa selecionada.";
    }

    if (error.contains("Falha de conexão")) {
      return "Não foi possível conectar ao servidor.";
    }

    if (error.contains("Empresa não selecionada")) {
      return "Selecione uma empresa para continuar.";
    }

    return "Erro ao consultar estoque.";
  }
}
