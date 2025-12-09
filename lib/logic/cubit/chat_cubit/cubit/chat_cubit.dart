import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/data/model/chat_message_model.dart';
import 'package:chat_app/data/model/chat_room_model.dart';
import 'package:chat_app/data/repo/chat_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepo chatrepo;
  final String currentID;
  ChatCubit({required this.chatrepo, required this.currentID})
    : super(ChatInitial());
  StreamSubscription<Either<Failure, List<ChatMessage>>>? _sub;
  Future<void> enterChat({required final String otherID}) async {
    emit(ChatLoading());
    try {
      final chatRoom = await chatrepo.getOrcreateChatRoom(
        currentID: currentID,
        otherID: otherID,
      );
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
          chatRoomId: (state as Chatfinish).chatRoom.id,
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

  Future<void> _streamSubscription({
    required final ChatRoomModel chatRoom,
  }) async {
    _sub?.cancel();
    _sub = chatrepo.getMesages(chatRoomId: chatRoom.id).listen((
      final messages,
    ) {
      messages.fold(
        (final failure) => emit(ChatFailure(failure.messgae)),
        (final messages) => emit(Chatfinish(chatRoom, messages: messages)),
      );
    });
  }

  void dispose() {
    _sub?.cancel();
    log("==================================================================");
  }
}
