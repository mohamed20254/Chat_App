import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'chat_rooms_state.dart';

class ChatRoomsCubit extends Cubit<ChatRoomsState> {
  ChatRoomsCubit() : super(ChatRoomsInitial());
}
