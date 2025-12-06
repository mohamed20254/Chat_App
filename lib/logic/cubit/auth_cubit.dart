import 'package:bloc/bloc.dart';
import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/data/model/user_model.dart';
import 'package:chat_app/data/repo/auth_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo repo;

  AuthCubit(this.repo) : super(AuthInitial());
  //crate account
  Future<void> creatAcount({
    required final String email,
    required final String phone,
    required final String fullName,
    required final String userName,
    required final String password,
  }) async {
    emit(AuthLoading());
    final Either<Failure, UserModel> res = await repo.creatAccount(
      email: email,
      phone: phone,
      fullName: fullName,
      userName: userName,
      password: password,
    );
    res.fold(
      (final faliure) {
        if (!isClosed) {
          emit(AuthFailure(messgae: faliure.messgae));
        }
      },
      (final user) {
        if (!isClosed) {
          emit(Authfinish(user));
        }
      },
    );
  }

  //Login
  Future<void> login({
    required final String email,
    required final String password,
  }) async {
    emit(AuthLoading());
    final Either<Failure, UserModel> res = await repo.signIn(
      email: email,
      password: password,
    );
    res.fold(
      (final faliure) {
        if (!isClosed) {
          emit(AuthFailure(messgae: faliure.messgae));
        }
      },
      (final user) {
        if (!isClosed) {
          emit(Authfinish(user));
        }
      },
    );
  }
}
