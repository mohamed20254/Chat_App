import 'dart:developer';

import 'package:chat_app/data/repo/chat_repo.dart';
import 'package:flutter/material.dart';

class AppLifeCycleObserver extends WidgetsBindingObserver {
  final ChatRepo repo;
  final String userId;

  AppLifeCycleObserver({required this.repo, required this.userId});

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        {
          repo.updateOnlineStatus(userId, false);
        }
        break;

      case AppLifecycleState.resumed:
        {
          repo.updateOnlineStatus(userId, true);
        }
      default:
        break;
    }
  }
}
