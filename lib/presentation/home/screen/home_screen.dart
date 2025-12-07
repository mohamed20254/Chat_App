import 'package:chat_app/presentation/home/widget/bottom_sheet_contact.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("chats", style: Theme.of(context).textTheme.bodyLarge),
      ),

      body: const Column(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showBottomSheetContact(context);
        },
        backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.8),
        child: const Icon(Icons.add_comment_rounded, color: Colors.white),
      ),
    );
  }
}
