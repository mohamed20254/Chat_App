import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/core/helper/time.dart';
import 'package:chat_app/data/model/chat_message_model.dart';
import 'package:chat_app/data/model/chat_room_model.dart';
import 'package:chat_app/data/repo/chat_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepo chatrepo;
  final String currentID;
  ChatCubit({required this.chatrepo, required this.currentID})
    : super(ChatInitial());
  StreamSubscription<Either<Failure, List<ChatMessage>>>? _sub;
  bool _isopenChat = false;

  StreamSubscription? _subUserStatus;

  //===================enter caht
  Future<void> enterChat({required final String otherID}) async {
    isClosed ? null : emit(ChatLoading());
    try {
      final chatRoom = await chatrepo.getOrcreateChatRoom(
        currentID: currentID,
        otherID: otherID,
      );

      _isopenChat = true;
      getUseronlineStatus(otherID);
      _streamSubscription(chatRoom: chatRoom);
    } on Exception catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }

  Future<void> sendMessage({
    required final String content,
    final MessageType type = MessageType.text,
    required final String reciverId,
  }) async {
    try {
      if (state is Chatfinish) {
        await chatrepo.sentmessage(
          content: content,
          chatRoomId: (state as Chatfinish).chatRoom!.id,
          senderId: currentID,
          receiverId: reciverId,
        );
      } else {
        return;
      }
    } on Exception catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }

  //===============================get messages
  Future<void> _streamSubscription({
    required final ChatRoomModel chatRoom,
  }) async {
    _sub?.cancel();
    _sub = chatrepo.getMesages(chatRoomId: chatRoom.id).listen((
      final messages,
    ) {
      if (_isopenChat) {
        markmessagesasread(chatroomId: chatRoom.id);
      }

      messages.fold(
        (final failure) {
          if (!isClosed) {
            emit(ChatFailure(failure.messgae));
          }
        },
        (final messages) {
          if (!isClosed) {
            emit(
              Chatfinish(
                chatRoom: chatRoom,
                messages: messages,
                userStatus: (state is Chatfinish)
                    ? (state as Chatfinish).userStatus
                    : null,
              ),
            );
          }
        },
      );
    });
  }

  //===========================================markmessagesasread
  Future<void> markmessagesasread({required final String chatroomId}) async {
    await chatrepo.markMessageAdRead(chatroomId: chatroomId, userId: currentID);
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }

  void getUseronlineStatus(final String userid) {
    _subUserStatus?.cancel();

    _subUserStatus = chatrepo.getUserOnlineStatus(userid).listen((final event) {
      final lastSean = event["lastSeen"] as Timestamp;
      final isOnline = event["isOnline"];

      emit(
        Chatfinish(
          chatRoom: (state is Chatfinish)
              ? (state as Chatfinish).chatRoom
              : null,
          messages: (state is Chatfinish)
              ? List.of((state as Chatfinish).messages ?? [])
              : null,
          userStatus: isOnline ? "isonline" : formatTime(lastSean.toDate()),
        ),
      );
    });
  }

  void dispose() {
    _sub?.cancel();
    _isopenChat = false;
    _subUserStatus?.cancel();
  }
}
