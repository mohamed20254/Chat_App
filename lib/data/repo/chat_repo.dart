import 'dart:developer';

import 'package:chat_app/config/injection/injection.dart';
import 'package:chat_app/data/model/chat_room_model.dart';
import 'package:chat_app/data/services/auth_remote.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ChatRepo {
  Future<ChatRoomModel> getOrcreateChatRoom({
    required final String currentID,
    required final String otherID,
  });
}

class ChatRepoImpl implements ChatRepo {
  CollectionReference get _collectionReference =>
      sl<FirebaseFirestore>().collection("chatRoom");

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
}
