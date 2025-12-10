import 'package:chat_app/core/error/firebseauth_exception.dart';
import 'package:chat_app/data/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRemote {
  //============================  craete Account interface
  Future<UserModel> creatAccount({
    required final String email,
    required final String phone,
    required final String fullName,
    required final String userName,
    required final String password,
  });
  Future<UserModel> signIn({
    required final String email,
    required final String password,
  });
  Future<UserModel> getUser({required final String uid});

  Future<List<UserModel>> getAlluser();
}

class AuthRemoteImpl implements AuthRemote {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final String usercollction = "users";
  AuthRemoteImpl({
    required final FirebaseFirestore firestore,
    required final FirebaseAuth auth,
  }) : _firestore = firestore,
       _auth = auth;

  //============================ Fatch craete Account
  @override
  Future<UserModel> creatAccount({
    required final String phone,
    required final String fullName,
    required final String userName,
    required final String email,
    required final String password,
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (userCredential.user == null) {
      throw MyFirebaseAuthException("Failed to create user");
    }
    final uid = userCredential.user!.uid;
    final userModel = UserModel(
      uid: uid,
      username: userName,
      fulname: fullName,
      email: email,
      phoneNumber: phone,
    );
    await _firestore.collection(usercollction).doc(uid).set(userModel.toMap());
    return userModel;
  }

  @override
  Future<UserModel> signIn({
    required final String email,
    required final String password,
  }) async {
    final userCredinal = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (userCredinal.user == null) {
      throw MyFirebaseAuthException("failed signIn");
    }
    return await getUser(uid: userCredinal.user!.uid);
  }

  @override
  Future<UserModel> getUser({required final String uid}) async {
    final doc = await _firestore.collection(usercollction).doc(uid).get();
    if (!doc.exists) {
      throw MyFirebaseAuthException("user data not found");
    }
    return UserModel.fromFirestore(doc);
  }

  @override
  Future<List<UserModel>> getAlluser() async {
    final snaphots = await _firestore.collection(usercollction).get();
    final docs = snaphots.docs;
    return docs.map((e) => UserModel.fromFirestore(e)).toList();
  }
}
