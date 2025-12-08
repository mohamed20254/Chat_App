import 'package:chat_app/data/repo/auth_repo.dart';
import 'package:chat_app/data/repo/chat_repo.dart';
import 'package:chat_app/data/repo/contact_repo.dart';
import 'package:chat_app/data/services/auth_remote.dart';
import 'package:chat_app/logic/cubit/auth_cubit/auth_cubit.dart';
import 'package:chat_app/logic/cubit/chat_cubit/cubit/chat_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;
Future<void> injectionApp() async {
  //firebase
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  //services
  sl.registerLazySingleton<AuthRemote>(
    () => AuthRemoteImpl(
      firestore: sl<FirebaseFirestore>(),
      auth: sl<FirebaseAuth>(),
    ),
  );

  //repo
  //Auth repo
  sl.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(remote: sl<AuthRemote>()),
  );

  //contact Ropository
  sl.registerLazySingleton<ContactRepo>(() => ContactRepo());
  //chatRepository

  sl.registerLazySingleton<ChatRepo>(() => ChatRepoImpl());

  //cubit
  sl.registerFactory<AuthCubit>(() => AuthCubit(sl<AuthRepo>()));

  sl.registerLazySingleton<ChatCubit>(
    () => ChatCubit(
      chatrepo: sl<ChatRepo>(),
      currentID: sl<FirebaseAuth>().currentUser?.uid ?? "",
    ),
  );
}
