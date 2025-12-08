import 'package:chat_app/data/model/chat_message_model.dart';
import 'package:chat_app/data/model/contact_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final ContactModel contact;
  const ChatScreen({super.key, required this.contact});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buidAppBar(context),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: 30,
              itemBuilder: (final context, final index) {
                return MessageBubble(
                  chatMessage: ChatMessage(
                    id: "id",
                    chatRoomId: "chatRoomId",
                    senderId: "senderId",
                    receiverId: "receiverId",
                    content: "  hello my name is content",
                    timestamp: Timestamp.now(),
                    readBy: [],
                  ),
                  isMe: false,
                );
              },
            ),
          ),
          Container(
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

                IconButton(onPressed: () {}, icon: const Icon(Icons.send)),
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
              Text(
                "online",
                style: Theme.of(
                  context,
                ).textTheme.labelLarge!.copyWith(color: Colors.green),
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
                  "214 Am",
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: isMe ? Colors.white : Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(width: 10),
                isMe
                    ? Icon(
                        Icons.done_all_sharp,
                        color: chatMessage.status == MessageStatus.sent
                            ? Colors.white
                            : Colors.blueAccent,
                      )
                    : const SizedBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
