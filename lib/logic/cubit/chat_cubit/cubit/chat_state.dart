part of 'chat_cubit.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

final class ChatInitial extends ChatState {}

final class ChatLoading extends ChatState {}

final class Chatfinish extends ChatState {
  final ChatRoomModel chatRoom;
  const Chatfinish(this.chatRoom);

  @override
  List<Object> get props => [chatRoom];
}

final class ChatFailure extends ChatState {
  final String message;
  const ChatFailure(this.message);

  @override
  List<Object> get props => [message];
}
