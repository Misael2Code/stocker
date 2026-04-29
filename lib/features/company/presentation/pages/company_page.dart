import 'package:flutter/material.dart';
import 'package:stocker/features/auth/presentation/controller/auth_controller.dart';
import 'package:stocker/features/company/presentation/pages/add_company_sheet.dart';
import 'package:stocker/features/stock/presentation/controller/stock_controller.dart';
import 'package:stocker/features/stock/presentation/pages/home_page.dart';
import 'package:stocker/shared/services/company_session_service.dart';
import '../../domain/entities/company_entity.dart';
import '../controller/company_controller.dart';

class CompanyPage extends StatefulWidget {
  final StockController stockController;
  final CompanyController controller;
  final AuthController authController;
  final bool isAdmin;

  const CompanyPage({
    super.key,
    required this.controller,
    required this.isAdmin,
    required this.stockController,
    required this.authController,
  });

  @override
  State<CompanyPage> createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {
  final sessionService = CompanySessionService();

  List<CompanyEntity> companies = [];
  CompanyEntity? selected;

  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final result = await widget.controller.loadCompanies();

      setState(() {
        companies = result;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Erro real: $e");
      setState(() {
        error = "Erro ao carregar empresas";
        isLoading = false;
      });
    }
  }

  Future<void> _onSelect(CompanyEntity? value) async {
    setState(() => selected = value);

    if (value != null) {
      await sessionService.saveCompany(value);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Empresa selecionada: ${value.name}")),
      );

      // 🚀 Próximo: navegar para Home
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Selecionar Empresa"),
        elevation: 0,
        foregroundColor: colors.inversePrimary,
      ),
      floatingActionButton:
          widget.isAdmin
              ? FloatingActionButton(
                onPressed: _openAddCompanyModal,
                child: const Icon(Icons.add),
              )
              : null,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.apartment, size: 48, color: colors.primary),

                const SizedBox(height: 16),

                Text(
                  "Selecione sua empresa",
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                const SizedBox(height: 8),

                Text(
                  "Escolha a empresa para continuar",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                const SizedBox(height: 24),

                DropdownButtonFormField<CompanyEntity>(
                  value: selected,
                  items:
                      companies.map((company) {
                        return DropdownMenuItem(
                          value: company,
                          child: Text(company.name),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() => selected = value);
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: selected == null ? null : _onContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Avançar",
                      style: TextStyle(color: colors.inversePrimary),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onContinue() async {
    await sessionService.saveCompany(selected!);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (_) => HomePage(
              stockController: widget.stockController,
              companyController: widget.controller,
              authController: widget.authController,
            ),
      ),
    );
  }

  void _openAddCompanyModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (_) => AddCompanySheet(
            onSave: (company) async {
              await widget.controller.addCompany(company);
              await load();
            },
          ),
    );
  }
}
