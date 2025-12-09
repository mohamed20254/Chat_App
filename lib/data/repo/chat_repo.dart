import 'dart:async';
import 'dart:developer';

import 'package:chat_app/config/injection/injection.dart';
import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/core/error/firebase_exception.dart';
import 'package:chat_app/data/model/chat_message_model.dart';
import 'package:chat_app/data/model/chat_room_model.dart';
import 'package:chat_app/data/services/auth_remote.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

abstract class ChatRepo {
  Future<ChatRoomModel> getOrcreateChatRoom({
    required final String currentID,
    required final String otherID,
  });
  //===============================================sned message
  Future<void> sentmessage({
    required final String content,
    required final String chatRoomId,
    required final String senderId,
    required final String receiverId,
    final MessageType type = MessageType.text,
  });

  //=========================================================getMessagesStream
  Stream<Either<Failure, List<ChatMessage>>> getMesages({
    required final String chatRoomId,
  });

  //============================================================getmoremessages
  Future<Either<Failure, List<ChatMessage>>> getMoreMesages({
    required final String chatRoomId,
    required final DocumentSnapshot lastdoc,
  });
  //============================================================getAllChatsRooms
  Stream<Either<Failure, List<ChatRoomModel>>> getChatsRooms({
    required final String uid,
  });
  //===========================================getUn readmessage count
  Stream<int> getUnreadMessages({
    required final String roomId,
    required final String userId,
  });
  //===============================================markmessage as read
  Future<void> markMessageAdRead({
    required final String chatroomId,
    required final String userId,
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

  //==================================================getmessages
  @override
  Stream<Either<Failure, List<ChatMessage>>> getMesages({
    required final String chatRoomId,
    final DocumentSnapshot? lastdoc,
  }) {
    final messags = getChatRoomMessages(
      chatRoomId,
    ).orderBy("timestamp", descending: true).limit(20);
    if (lastdoc != null) {
      messags.startAfterDocument(lastdoc);
    }
    return messags
        .snapshots()
        .map((final snapshot) {
          final messages = snapshot.docs
              .map((e) => ChatMessage.fromFirestore(e))
              .toList();

          return right<Failure, List<ChatMessage>>(messages);
        })
        .handleError((final error) {
          return left<Failure, List<ChatMessage>>(
            Failure(messgae: error.toString()),
          );
        });
  }

  @override
  Future<Either<Failure, List<ChatMessage>>> getMoreMesages({
    required final String chatRoomId,
    required final DocumentSnapshot lastdoc,
  }) async {
    try {
      final messags = await getChatRoomMessages(chatRoomId)
          .startAfterDocument(lastdoc)
          .orderBy("timestamp", descending: true)
          .limit(20)
          .get();

      return right(
        messags.docs.map((final e) => ChatMessage.fromFirestore(e)).toList(),
      );
    } on FirebaseException catch (e) {
      return left(Failure(messgae: MyFirebaseServiceException(e.code).message));
    }
  }

  @override
  Stream<Either<Failure, List<ChatRoomModel>>> getChatsRooms({
    required final String uid,
  }) {
    final chats = _collectionReference
        .where("participants", arrayContains: uid)
        .orderBy("lastMessageTime", descending: true);

    return chats.snapshots().map((final event) {
      try {
        final chats = event.docs
            .map((e) => ChatRoomModel.fromFirestore(e))
            .toList();
        return right<Failure, List<ChatRoomModel>>(chats);
      } on Exception catch (e) {
        return left(Failure(messgae: e.toString()));
      }
    });
  }

  @override
  Stream<int> getUnreadMessages({
    required final String roomId,
    required final String userId,
  }) {
    return getChatRoomMessages(roomId)
        .where("receiverId", isEqualTo: userId)
        .where("status", isEqualTo: MessageStatus.sent.toString())
        .snapshots()
        .map((final event) {
          return event.docs.length;
        });
  }

  @override
  Future<void> markMessageAdRead({
    required final String chatroomId,
    required final String userId,
  }) async {
    final messagesRef = getChatRoomMessages(chatroomId);

    final unreadMessages = await messagesRef
        .where("receiverId", isEqualTo: userId)
        .where("status", isEqualTo: MessageStatus.sent.toString())
        .get();

    if (unreadMessages.docs.isEmpty) return;

    final batch = sl<FirebaseFirestore>().batch();

    for (final doc in unreadMessages.docs) {
      batch.update(doc.reference, {"status": MessageStatus.read.toString()});
    }

    await batch.commit();
  }
}
