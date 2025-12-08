import 'package:bloc/bloc.dart';
import 'package:chat_app/data/model/chat_message_model.dart';
import 'package:chat_app/data/model/chat_room_model.dart';
import 'package:chat_app/data/repo/chat_repo.dart';
import 'package:equatable/equatable.dart';
part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepo chatrepo;
  final String currentID;
  ChatCubit({required this.chatrepo, required this.currentID})
    : super(ChatInitial());

  Future<void> enterChat({required final String otherID}) async {
    emit(ChatLoading());
    try {
      final chatRoom = await chatrepo.getOrcreateChatRoom(
        currentID: currentID,
        otherID: otherID,
      );
      emit(Chatfinish(chatRoom));
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
      }
    } on Exception catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }
}
