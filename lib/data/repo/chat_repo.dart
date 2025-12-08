import 'dart:developer';

import 'package:chat_app/config/injection/injection.dart';
import 'package:chat_app/data/model/chat_message_model.dart';
import 'package:chat_app/data/model/chat_room_model.dart';
import 'package:chat_app/data/services/auth_remote.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ChatRepo {
  Future<ChatRoomModel> getOrcreateChatRoom({
    required final String currentID,
    required final String otherID,
  });

  Future<void> sentmessage({
    required final String content,
    required final String chatRoomId,
    required final String senderId,
    required final String receiverId,
    final MessageType type = MessageType.text,
  });
}

final class ChatRepoImpl implements ChatRepo {
  CollectionReference get _collectionReference =>
      sl<FirebaseFirestore>().collection("chatRoom");

  CollectionReference getChatRoomMessages(final String chatRoomId) {
    return _collectionReference.doc(chatRoomId).collection("messages");
  }

  @override
  Future<ChatRoomModel> getOrcreateChatRoom({
    required final String currentID,
    required final String otherID,
  }) async {
    try {
      final users = [currentID, otherID]..sort();
      final roomId = users.join("_");

      final chatRoom = await _collectionReference.doc(roomId).get();
      if (chatRoom.exists) {
        return ChatRoomModel.fromFirestore(chatRoom);
      }
      final currentuser = await sl<AuthRemote>().getUser(uid: currentID);
      final otherUser = await sl<AuthRemote>().getUser(uid: otherID);
      final newchatRoom = ChatRoomModel(
        id: roomId,
        participants: users,
        participantsName: {
          currentID: currentuser.fulname.toString(),
          otherID: otherUser.fulname.toString(),
        },
        lastReadTime: {currentID: Timestamp.now(), otherID: Timestamp.now()},
      );
      _collectionReference.doc(roomId).set(newchatRoom.toMap());
      return newchatRoom;
    } on Exception catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> sentmessage({
    required final String content,
    required final String chatRoomId,
    required final String senderId,
    required final String receiverId,
    final MessageType type = MessageType.text,
  }) async {
    final batch = sl<FirebaseFirestore>().batch();
    final messageRef = getChatRoomMessages(chatRoomId);
    final messageDoc = messageRef.doc();

    //new message
    final message = ChatMessage(
      id: messageDoc.id,
      chatRoomId: chatRoomId,
      senderId: senderId,
      receiverId: receiverId,
      content: content,
      timestamp: Timestamp.now(),
      readBy: [senderId],
    );

    //add message
    batch.set(messageDoc, message.toMap());

    //udateChatRoom
    batch.update(_collectionReference.doc(chatRoomId), {
      "lastMessage": content,
      "lastMessageSenderId": senderId,
      "lastMessageTime": message.timestamp,
    });
    await batch.commit();
  }
}
