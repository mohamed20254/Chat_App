part of 'chat_rooms_cubit.dart';

sealed class ChatRoomsState extends Equatable {
  const ChatRoomsState();

  @override
  List<Object?> get props => [];
}

final class ChatRoomsInitial extends ChatRoomsState {}

final class ChatRoomsLoding extends ChatRoomsState {}

final class ChatRoomsfinish extends ChatRoomsState {
  final List<ChatRoomModel> chats;

  const ChatRoomsfinish({required this.chats});
  @override
  List<Object?> get props => [chats];
}

final class ChatRoomsFailure extends ChatRoomsState {
  final String message;
  const ChatRoomsFailure(this.message);
  @override
  List<Object> get props => [message];
}
