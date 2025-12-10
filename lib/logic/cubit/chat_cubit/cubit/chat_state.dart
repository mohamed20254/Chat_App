part of 'chat_cubit.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

final class ChatInitial extends ChatState {}

final class ChatLoading extends ChatState {}

final class Chatfinish extends ChatState {
  final ChatRoomModel? chatRoom;
  final List<ChatMessage>? messages;
  final String? userStatus;
  const Chatfinish({this.chatRoom, this.messages, this.userStatus});

  Chatfinish copyWith({
    final ChatRoomModel? chatRoom,
    final List<ChatMessage>? messages,
    final String? userStatus,
  }) {
    return Chatfinish(
      chatRoom: chatRoom ?? this.chatRoom,
      messages: messages ?? this.messages,
      userStatus: userStatus ?? this.userStatus,
    );
  }

  @override
  List<Object?> get props => [userStatus, chatRoom, messages];
}

final class ChatFailure extends ChatState {
  final String message;
  const ChatFailure(this.message);

  @override
  List<Object> get props => [message];
}
