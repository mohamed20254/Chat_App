import 'package:chat_app/config/routing/app_routing.dart';
import 'package:chat_app/config/theme/app_theme.dart';
import 'package:chat_app/presentation/screen/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'chat App',
      theme: AppTheme.lightTheme,
      onGenerateRoute: AppRouting.onGenerateRoute,
      home: const LoginScreen(),
    );
  }
}
