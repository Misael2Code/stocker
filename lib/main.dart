import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stocker/app.dart';
import 'package:stocker/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final googleSignIn = GoogleSignIn.instance;
  await googleSignIn.initialize();

  runApp(const StockerApp());
}
