import 'package:chat_app/config/injection/injection.dart';
import 'package:chat_app/config/routing/app_routing.dart';
import 'package:chat_app/data/model/contact_model.dart';
import 'package:chat_app/logic/cubit/chats_rooms_cubit/chat_rooms_cubit.dart';
import 'package:chat_app/presentation/home/widget/bottom_sheet_contact.dart';
import 'package:chat_app/presentation/home/widget/custom_listtile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        title: Text("chats", style: Theme.of(context).textTheme.titleSmall),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: IconButton(
              onPressed: () async {
                await sl<FirebaseAuth>().signOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRouting.login,
                  (_) => false,
                );
              },
              icon: const Icon(Icons.logout),
            ),
          ),
        ],
      ),

      body: BlocBuilder<ChatRoomsCubit, ChatRoomsState>(
        builder: (final context, final state) {
          if (state is ChatRoomsLoding) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatRoomsFailure) {
            return Center(child: Text(state.message));
          }
          if (state is ChatRoomsfinish) {
            return ListView.builder(
              itemCount: state.chats.length,
              itemBuilder: (final context, final index) {
                final chat = state.chats[index];
                final String otherid = chat.participants
                    .firstWhere(
                      (final id) => id != sl<ChatRoomsCubit>().currentUser,
                    )
                    .toString();
                final contact = ContactModel(
                  id: otherid,
                  phoneNumper: "",
                  name: chat.participantsName![otherid].toString(),
                );
                return CustomListiTile(
                  chat: chat,
                  ontap: () {
                    Navigator.pushNamed(
                      context,
                      AppRouting.chat,
                      arguments: contact,
                    );
                  },
                );
              },
            );
          }

          return Container();
        },
      ),
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
