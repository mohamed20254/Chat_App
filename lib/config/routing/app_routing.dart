import 'package:chat_app/presentation/screen/login_screen.dart';
import 'package:chat_app/presentation/screen/signup_screen.dart';
import 'package:flutter/material.dart';

class AppRouting {
  //==========namerout
  static const String initpage = "/";
  static const String login = "/login";
  static const String signup = "/signup";

  static Route<dynamic>? onGenerateRoute(final RouteSettings setting) {
    switch (setting.name) {
      case initpage:
        return MaterialPageRoute(
          builder: (final context) => const LoginScreen(),
        );
      case login:
        return MaterialPageRoute(
          builder: (final context) => const LoginScreen(),
        );
      case signup:
        return MaterialPageRoute(
          builder: (final context) => const SignupScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (final context) => const DefaultScren(),
        );
    }
  }
}

class DefaultScren extends StatelessWidget {
  const DefaultScren({super.key});

  @override
  Widget build(final BuildContext context) {
    return const Center(child: Text("NO rout"));
  }
}
