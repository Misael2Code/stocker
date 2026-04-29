import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stocker/features/auth/presentation/controller/auth_controller.dart';
import 'package:stocker/features/company/presentation/controller/company_controller.dart';
import 'package:stocker/features/stock/presentation/controller/stock_controller.dart';
import 'package:stocker/features/stock/presentation/pages/home_page.dart';

import '../../shared/services/company_session_service.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/company/presentation/pages/company_page.dart';

class SplashPage extends StatefulWidget {
  final StockController stockController;
  final AuthController authController;
  final CompanyController companyController;

  const SplashPage({
    super.key,
    required this.authController,
    required this.companyController,
    required this.stockController,
  });

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));

      final firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser == null) {
        _goToLogin();
        return;
      }

      final user = await widget.authController.getCurrentUser();

      if (user == null) {
        _goToLogin();
        return;
      }

      final session = CompanySessionService();
      final company = await session.getCompany();

      if (company == null) {
        _goToCompany(user);
        return;
      }

      _goToHome();
    } catch (e) {
      debugPrint("Erro no Splash: $e");
      _goToLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  void _goToLogin() {
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (_) => LoginPage(
              controller: widget.authController,
              companyController: widget.companyController,
              stockController: widget.stockController,
            ),
      ),
    );
  }

  void _goToCompany(user) {
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (_) => CompanyPage(
              controller: widget.companyController,
              isAdmin: user.profile == 'admin',
              stockController: widget.stockController,
              authController: widget.authController,
            ),
      ),
    );
  }

  void _goToHome() {
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (_) => HomePage(
              stockController: widget.stockController,
              companyController: widget.companyController,
              authController: widget.authController,
            ),
      ),
    );
  }
}
