import 'dart:developer';

import 'package:chat_app/config/injection/injection.dart';
import 'package:chat_app/core/helper/time.dart';
import 'package:chat_app/data/model/chat_message_model.dart';
import 'package:chat_app/data/model/contact_model.dart';
import 'package:chat_app/logic/cubit/chat_cubit/cubit/chat_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatefulWidget {
  final ContactModel contact;
  const ChatScreen({super.key, required this.contact});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((final timeStamp) {
      context.read<ChatCubit>().enterChat(otherID: widget.contact.id ?? "");
    });
  }

  @override
  void dispose() {
    controller.dispose();
    sl<ChatCubit>().dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buidAppBar(context),
      body: Column(
        children: [
          const SizedBox(height: 10),
          BlocBuilder<ChatCubit, ChatState>(
            builder: (final context, final state) {
              if (state is ChatLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ChatFailure) {
                return Center(child: Text(state.message));
              }
              if (state is Chatfinish) {
                return Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: state.messages?.length ?? 0,

                    itemBuilder: (final context, final index) {
                      final message = state.messages![index];
                      final bool isMe =
                          message.senderId == sl<ChatCubit>().currentID;
                      return MessageBubble(
                        chatMessage: ChatMessage(
                          id: message.id,
                          chatRoomId: message.chatRoomId,
                          senderId: message.senderId,
                          receiverId: message.receiverId,
                          content: message.content,
                          timestamp: message.timestamp,
                          readBy: message.readBy,
                        ),
                        isMe: isMe,
                      );
                    },
                  ),
                );
              }
              return Container();
            },
          ),
          DecoratedBox(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    // emoji
                  },
                  icon: const Icon(Icons.emoji_emotions),
                ),
                Expanded(
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.transparent,
                      hintText: "type a message",
                      hintStyle: Theme.of(context).textTheme.labelLarge,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),

                IconButton(
                  onPressed: () {
                    //send message
                    final message = controller.text.trim();
                    controller.clear();
                    context.read<ChatCubit>().sendMessage(
                      content: message,
                      reciverId: widget.contact.id ?? "",
                    );
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  AppBar _buidAppBar(final BuildContext context) {
    return AppBar(
      leadingWidth: 30,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
      ),
      title: Row(
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(
              context,
            ).primaryColor.withValues(alpha: 0.2),
            child: Text(
              widget.contact.name[0].toUpperCase(),
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: .start,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 200),
                child: Text(
                  widget.contact.name,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 2),

              BlocBuilder<ChatCubit, ChatState>(
                builder: (final context, final state) {
                  if (state is Chatfinish) {
                    return Text(
                      state.userStatus ?? "kkkkkk",
                      style: Theme.of(
                        context,
                      ).textTheme.labelLarge!.copyWith(color: Colors.green),
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsetsGeometry.only(right: 5),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(CupertinoIcons.ellipsis_vertical),
          ),
        ),
      ],
    );
  }
}

class MessageBubble extends StatelessWidget {
  final ChatMessage chatMessage;
  final bool isMe;

  const MessageBubble({
    super.key,
    required this.chatMessage,
    required this.isMe,
  });

  @override
  Widget build(final BuildContext context) {
    return Align(
      alignment: isMe ? .centerRight : .centerLeft,

      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        margin: EdgeInsets.only(
          bottom: 10,
          right: isMe ? 5 : 20,
          left: isMe ? 20 : 5,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: const Radius.circular(12),
            bottomRight: const Radius.circular(12),
            topLeft: isMe ? const Radius.circular(12) : Radius.zero,
            topRight: isMe ? Radius.zero : const Radius.circular(12),
          ),
          color: isMe
              ? Theme.of(context).primaryColor
              : Theme.of(context).primaryColor.withValues(alpha: 0.2),
        ),

        child: Column(
          crossAxisAlignment: isMe ? .end : .start,
          children: [
            Text(
              chatMessage.content,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: isMe ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: .min,
              children: [
                Text(
                  formatTime(chatMessage.timestamp.toDate()),
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: isMe ? Colors.white : Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),

                if (isMe) ...[
                  const SizedBox(width: 5),
                  Icon(
                    size: 15,
                    Icons.done_all_sharp,
                    color: chatMessage.status == MessageStatus.sent
                        ? Colors.white
                        : Colors.blueAccent,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
