import 'package:chat_app/config/injection/injection.dart';
import 'package:chat_app/data/model/contact_model.dart';
import 'package:chat_app/logic/cubit/auth_cubit/auth_cubit.dart';
import 'package:chat_app/logic/cubit/chat_cubit/cubit/chat_cubit.dart';
import 'package:chat_app/logic/cubit/chats_rooms_cubit/chat_rooms_cubit.dart';
import 'package:chat_app/presentation/auth/screen/login_screen.dart';
import 'package:chat_app/presentation/auth/screen/signup_screen.dart';
import 'package:chat_app/presentation/chat/chat_screen.dart';
import 'package:chat_app/presentation/home/screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouting {
  //==========namerout
  static const String initpage = "/";
  static const String login = "/login";
  static const String signup = "/signup";
  static const String home = "/home";
  static const String chat = "/chatscreen";

  static Route<dynamic>? onGenerateRoute(final RouteSettings setting) {
    switch (setting.name) {
      case initpage:
        return MaterialPageRoute(
          builder: (final context) => sl<FirebaseAuth>().currentUser == null
              ? BlocProvider(
                  create: (final context) => sl<AuthCubit>(),
                  child: const LoginScreen(),
                )
              : BlocProvider(
                  create: (final context) => sl<ChatRoomsCubit>(),
                  child: const HomeScreen(),
                ),
        );
      case login:
        return MaterialPageRoute(
          builder: (final context) => BlocProvider(
            create: (final context) => sl<AuthCubit>(),
            child: const LoginScreen(),
          ),
        );
      case signup:
        return MaterialPageRoute(
          builder: (final context) => BlocProvider(
            create: (final context) => sl<AuthCubit>(),
            child: const SignupScreen(),
          ),
        );
      case home:
        return MaterialPageRoute(
          builder: (final context) => BlocProvider(
            create: (final context) => sl<ChatRoomsCubit>(),
            child: const HomeScreen(),
          ),
        );
      case chat:
        {
          final arg = setting.arguments as ContactModel;
          return MaterialPageRoute(
            builder: (final context) => BlocProvider(
              create: (context) => sl<ChatCubit>(),
              child: ChatScreen(contact: arg),
            ),
          );
        }
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
