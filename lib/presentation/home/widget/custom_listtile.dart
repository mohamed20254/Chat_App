import 'package:chat_app/config/injection/injection.dart';
import 'package:chat_app/data/model/chat_room_model.dart';
import 'package:chat_app/data/repo/chat_repo.dart';
import 'package:chat_app/logic/cubit/chats_rooms_cubit/chat_rooms_cubit.dart';
import 'package:flutter/material.dart';

class CustomListiTile extends StatelessWidget {
  const CustomListiTile({super.key, required this.chat, this.ontap});

  final ChatRoomModel chat;
  final Function()? ontap;
  @override
  Widget build(final BuildContext context) {
    String otherName = "";
    chat.participantsName!.forEach((final key, final value) {
      if (!key.contains(sl<ChatRoomsCubit>().currentUser)) {
        otherName = value;
      }
    });
    return ListTile(
      onTap: ontap,
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
        child: Text(
          otherName.isNotEmpty ? otherName[0].toUpperCase() : "",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      subtitle: Text(
        chat.lastMessage ?? "",
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text("12.3254 Am", style: Theme.of(context).textTheme.labelLarge),
          StreamBuilder(
            stream: sl<ChatRepo>().getUnreadMessages(
              roomId: chat.id,
              userId: sl<ChatRoomsCubit>().currentUser,
            ),
            builder: (final context, final asyncSnapshot) {
              if (asyncSnapshot.hasError) {
                return const Text("error");
              }
              if (asyncSnapshot.hasData) {
                final count = asyncSnapshot.data;
                if (count == 0) {
                  return const SizedBox();
                }
                return Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Center(
                    child: Text(
                      count.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),

      title: Text(otherName),
    );
  }
}
