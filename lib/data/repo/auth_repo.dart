import 'package:chat_app/core/constant/app_strings.dart';
import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/core/error/firebase_exception.dart';
import 'package:chat_app/core/error/firebseauth_exception.dart';
import 'package:chat_app/core/helper/internet.dart';
import 'package:chat_app/data/model/user_model.dart';
import 'package:chat_app/data/services/auth_remote.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepo {
  Future<Either<Failure, UserModel>> creatAccount({
    required final String email,
    required final String phone,
    required final String fullName,
    required final String userName,
    required final String password,
  });
  Future<Either<Failure, UserModel>> signIn({
    required final String email,
    required final String password,
  });
}

class AuthRepoImpl implements AuthRepo {
  final AuthRemote remote;

  AuthRepoImpl({required this.remote});
  @override
  Future<Either<Failure, UserModel>> creatAccount({
    required final String email,
    required final String phone,
    required final String fullName,
    required final String userName,
    required final String password,
  }) async {
    return await _runAuth(
      () => remote.creatAccount(
        email: email,
        phone: phone,
        fullName: fullName,
        userName: userName,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, UserModel>> signIn({
    required final String email,
    required final String password,
  }) async {
    return await _runAuth(
      () => remote.signIn(email: email, password: password),
    );
  }

  Future<Either<Failure, UserModel>> _runAuth(
    final Future<UserModel> Function() action,
  ) async {
    try {
      if (!await InternetConnection.instance.checkInternet()) {
        return left(Failure(messgae: AppStrings.nowInternete));
      }
      final user = await action();
      return right(user);
    } on MyFirebaseAuthException catch (e) {
      return left(Failure(messgae: e.code));
    } on FirebaseAuthException catch (e) {
      return left(Failure(messgae: MyFirebaseAuthException(e.code).message));
    } on FirebaseException catch (e) {
      return left(Failure(messgae: MyFirebaseServiceException(e.code).message));
    } catch (e) {
      return left(Failure(messgae: e.toString()));
    }
  }
}
