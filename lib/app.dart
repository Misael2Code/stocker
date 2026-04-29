import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stocker/core/pages/splash_page.dart';
import 'package:stocker/features/company/data/datasource/company_remote_datasource.dart';
import 'package:stocker/features/company/data/repositories/company_repository_impl.dart';
import 'package:stocker/features/company/domain/usecases/add_company.dart';
import 'package:stocker/features/company/domain/usecases/get_companies.dart';
import 'package:stocker/features/company/presentation/controller/company_controller.dart';
import 'package:stocker/features/stock/data/datasource/stock_remote_datasource.dart';
import 'package:stocker/features/stock/data/repositories/stock_repository_impl.dart';
import 'package:stocker/features/stock/presentation/controller/stock_controller.dart';
import 'package:stocker/shared/services/company_session_service.dart';

import 'core/theme/app_theme.dart';

// AUTH
import 'features/auth/data/datasource/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/controller/auth_controller.dart';

class StockerApp extends StatelessWidget {
  const StockerApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔹 Instâncias base
    final googleSignIn = GoogleSignIn.instance;
    final firebaseAuth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;

    // 🔹 Auth DI (corrigido)
    final authDatasource = AuthRemoteDataSource(googleSignIn, firebaseAuth);

    final authRepository = AuthRepositoryImpl(authDatasource, firestore);

    final authController = AuthController(authRepository);

    final companyDatasource = CompanyRemoteDataSource(firestore);
    final companyRepository = CompanyRepositoryImpl(companyDatasource);
    final getCompanies = GetCompanies(companyRepository);
    final addCompany = AddCompany(companyRepository);

    final companyController = CompanyController(getCompanies, addCompany);

    final sessionService = CompanySessionService();

    final stockDatasource = StockRemoteDataSource(sessionService);
    final stockRepository = StockRepositoryImpl(stockDatasource);
    final stockController = StockController(stockRepository);

    return MaterialApp(
      title: 'Stocker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      home: SplashPage(
        authController: authController,
        companyController: companyController,
        stockController: stockController,
      ),
    );
  }
}
