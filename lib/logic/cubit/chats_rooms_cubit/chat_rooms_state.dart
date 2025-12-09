part of 'chat_rooms_cubit.dart';

sealed class ChatRoomsState extends Equatable {
  const ChatRoomsState();

  @override
  List<Object> get props => [];
}

final class ChatRoomsInitial extends ChatRoomsState {}
