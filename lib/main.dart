import 'package:chat_app/config/routing/app_routing.dart';
import 'package:chat_app/config/theme/app_theme.dart';
import 'package:chat_app/data/repo/chat_repo.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/logic/cubit/chat_cubit/cubit/chat_cubit.dart';
import 'package:chat_app/logic/observer/app_life_cycle.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppLifeCycleObserver _appLifeCycleObserver;

  @override
  void initState() {
    print(di.sl<FirebaseAuth>().currentUser!.uid.toString());
    if (di.sl<FirebaseAuth>().currentUser != null) {
      _appLifeCycleObserver = AppLifeCycleObserver(
        repo: di.sl<ChatRepo>(),
        userId: di.sl<FirebaseAuth>().currentUser!.uid,
      );
    }
    WidgetsBinding.instance.addObserver(_appLifeCycleObserver);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_appLifeCycleObserver);
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(final BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'chat App',
      theme: AppTheme.lightTheme,
      onGenerateRoute: AppRouting.onGenerateRoute,
    );
  }
}
