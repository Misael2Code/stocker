import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stocker/core/pages/splash_page.dart';
import 'package:stocker/core/widgets/app_system_ui.dart';
import 'package:stocker/features/company/presentation/controller/company_controller.dart';
import 'package:stocker/features/company/presentation/pages/company_page.dart';
import 'package:stocker/features/stock/presentation/controller/stock_controller.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../controller/auth_controller.dart';

class LoginPage extends StatefulWidget {
  final AuthController controller;
  final CompanyController companyController;
  final StockController stockController;

  const LoginPage({
    super.key,
    required this.controller,
    required this.companyController,
    required this.stockController,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;

  Future<void> _handleLogin() async {
    setState(() => isLoading = true);

    final user = await widget.controller.login();

    setState(() => isLoading = false);

    if (user != null && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder:
              (_) => SplashPage(
                authController: widget.controller,
                companyController: widget.companyController,
                stockController: widget.stockController,
              ),
        ),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Falha no login')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppSystemUI(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.primaryColor, theme.primaryColor.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),

          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Spacer(),

                  // LOGO
                  Column(
                    children: [
                      Image.asset(
                        'images/stocker-logotipo-white.png',
                        width: 200,
                      ),

                      const SizedBox(height: 8),
                      Text(
                        "Estoque em segundos",
                        style: AppTextStyles.subtitle.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child:
                          isLoading
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.black,
                                ),
                              )
                              : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'images/google-logo.png',
                                    width: 50,
                                  ),
                                  const Text("Entrar com Google"),
                                ],
                              ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
