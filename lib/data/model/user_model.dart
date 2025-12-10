import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String username;
  final String fulname;
  final String email;
  final String phoneNumber;
  final bool isonline;
  final List<String> blocs;
  final Timestamp lastseen;
  final Timestamp creadetdAt;
  final String? fcmtokin;

  UserModel({
    required this.uid,
    required this.username,
    required this.fulname,
    required this.email,
    this.isonline = false,
    this.blocs = const [],
    final Timestamp? lastseen,
    final Timestamp? creadetdAt,
    this.fcmtokin,
    required this.phoneNumber,
  }) : lastseen = lastseen ?? Timestamp.now(),
       creadetdAt = creadetdAt ?? Timestamp.now();

  UserModel copyWith({
    final String? uid,
    final String? username,
    final String? fulname,
    final String? email,
    final bool? isonline,
    final List<String>? blocs,
    final Timestamp? lastseen,
    final Timestamp? creadetdAt,
    final String? fcmtokin,
    final String? phonenumper,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      fulname: fulname ?? this.fulname,
      email: email ?? this.email,
      isonline: isonline ?? this.isonline,
      blocs: blocs ?? this.blocs,
      lastseen: lastseen ?? this.lastseen,
      creadetdAt: creadetdAt ?? this.creadetdAt,
      fcmtokin: fcmtokin ?? this.fcmtokin,
      phoneNumber: phonenumper ?? phoneNumber,
    );
  }

  factory UserModel.fromFirestore(final DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      username: data["username"] ?? "",
      fulname: data["fullName"] ?? "",
      email: data["email"] ?? "",
      phoneNumber: data["phoneNumber"] ?? "",
      fcmtokin: data["fcmToken"],
      lastseen: data["lastSeen"] ?? Timestamp.now(),
      creadetdAt: data["createdAt"] ?? Timestamp.now(),
      blocs: List<String>.from(data["blockedUsers"]),
      isonline: data["isOnline"] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'fullName': fulname,
      'phoneNumber': phoneNumber,
      'isOnline': isonline,
      'lastSeen': lastseen,
      'createdAt': creadetdAt,
      'blockedUsers': blocs,
      'fcmToken': fcmtokin,
    };
  }
}
