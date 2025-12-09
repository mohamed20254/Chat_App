import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/data/model/chat_room_model.dart';
import 'package:chat_app/data/repo/chat_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

part 'chat_rooms_state.dart';

class ChatRoomsCubit extends Cubit<ChatRoomsState> {
  final ChatRepo repo;
  final String currentUser;
  ChatRoomsCubit(this.repo, {required this.currentUser})
    : super(ChatRoomsInitial()) {
    getChats();
  }
  StreamSubscription<Either<Failure, List<ChatRoomModel>>>? _sub;
  void getChats() {
    emit(ChatRoomsLoding());
    _sub?.cancel();
    _sub = repo.getChatsRooms(uid: currentUser).listen((final event) {
      event.fold((final failure) => emit(ChatRoomsFailure(failure.messgae)), (
        final chats,
      ) {
        return emit(ChatRoomsfinish(chats));
      });
    });
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
