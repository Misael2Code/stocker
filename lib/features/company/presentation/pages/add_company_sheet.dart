import 'package:flutter/material.dart';
import 'package:stocker/features/company/domain/entities/company_entity.dart';

class AddCompanySheet extends StatefulWidget {
  final Function(CompanyEntity) onSave;

  const AddCompanySheet({required this.onSave});

  @override
  State<AddCompanySheet> createState() => AddCompanySheetState();
}

class AddCompanySheetState extends State<AddCompanySheet> {
  final nameController = TextEditingController();
  final cnpjController = TextEditingController();
  final serverController = TextEditingController();
  final portController = TextEditingController();
  final seniorUser = TextEditingController();
  final seniorPass = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool obscure = true;

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final company = CompanyEntity(
      cnpj: cnpjController.text,
      name: nameController.text,
      server: serverController.text,
      port: int.tryParse(portController.text) ?? 0,
      status: 'active',
      seniorUser: seniorUser.text,
      seniorPassword: seniorPass.text,
    );

    await widget.onSave(company);

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final viewInsets = MediaQuery.of(context).viewInsets;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: viewInsets.bottom + 16,
          top: 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 12),
              Column(
                children: [
                  Icon(Icons.apartment, size: 40, color: colors.primary),
                  const SizedBox(height: 8),
                  Text(
                    "Nova Empresa",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔹 SEÇÃO: DADOS DA EMPRESA
                    Text(
                      "Dados da empresa",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 12),

                    _input(
                      controller: nameController,
                      label: "Nome da empresa",
                      icon: Icons.business,
                    ),

                    _input(
                      controller: cnpjController,
                      label: "CNPJ",
                      icon: Icons.badge,
                      keyboard: TextInputType.number,
                    ),

                    const SizedBox(height: 20),

                    // 🔹 SEÇÃO: SERVIDOR
                    Text(
                      "Conexão",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 12),

                    _input(
                      controller: serverController,
                      label: "Servidor",
                      icon: Icons.dns,
                    ),

                    _input(
                      controller: portController,
                      label: "Porta",
                      icon: Icons.settings_ethernet,
                      keyboard: TextInputType.number,
                    ),

                    const SizedBox(height: 20),

                    // 🔹 SEÇÃO: CREDENCIAIS
                    Text(
                      "Credenciais Senior",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 12),

                    _input(
                      controller: seniorUser,
                      label: "Usuário",
                      icon: Icons.person,
                    ),

                    _input(
                      controller: seniorPass,
                      label: "Senha",
                      icon: Icons.lock,
                      isPassword: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:
                      isLoading
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Text("Salvar"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _input({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        obscureText: isPassword ? obscure : false,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          suffixIcon:
              isPassword
                  ? IconButton(
                    icon: Icon(
                      obscure ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() => obscure = !obscure);
                    },
                  )
                  : null,
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator:
            (value) =>
                value == null || value.isEmpty ? "Campo obrigatório" : null,
      ),
    );
  }
}
