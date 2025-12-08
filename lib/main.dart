import 'package:chat_app/config/routing/app_routing.dart';
import 'package:chat_app/config/theme/app_theme.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/logic/cubit/chat_cubit/cubit/chat_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/config/injection/injection.dart' as di;
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //firebse init
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //ingection
  await di.injectionApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(final BuildContext context) {
    return BlocProvider(
      create: (final context) => di.sl<ChatCubit>(),

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'chat App',
        theme: AppTheme.lightTheme,
        onGenerateRoute: AppRouting.onGenerateRoute,
      ),
    );
  }
}
