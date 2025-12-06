import 'dart:developer';
import 'package:chat_app/config/injection/injection.dart';
import 'package:chat_app/data/services/auth_remote.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactRepo {
  String get currentUserId => FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<bool> requestContactsPermission() async {
    return await FlutterContacts.requestPermission();
  }

  Future<List<Map<String, dynamic>>> getRegisteredContacts() async {
    try {
      final bool hasPermission = await requestContactsPermission();
      if (!hasPermission) {
        print('Contacts permission denied');
        return [];
      }
      final List<Contact> contacs = await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: true,
      );

      final phoneNumpers = contacs
          .where((final contact) => contact.phones.isNotEmpty)
          .map(
            (final contact) => {
              "fullname": contact.displayName,
              "phonenmper": contact.phones.first.number.replaceAll(
                RegExp(r'[^\d+]'),
                '',
              ),
              "phott": contact.photo,
            },
          );

      final rejesterUsers = await sl<AuthRemote>().getAlluser();

      final matchedContacts = phoneNumpers
          .where((final numper) {
            final phoneNumper = numper["phonenmper"].toString();

            if (phoneNumper.startsWith("+20")) {
              phoneNumper.substring(3);
            }
            return rejesterUsers.any(
              (user) =>
                  user.phoneNumber == phoneNumper && user.uid != currentUserId,
            );
          })
          .map((final contact) {
            String phoneNumber = contact["phoneNumber"]
                .toString(); // Ensure it's a String

            if (phoneNumber.startsWith("+20")) {
              phoneNumber = phoneNumber.substring(3);
            }

            final registeredUser = rejesterUsers.firstWhere(
              (final user) => user.phoneNumber == phoneNumber,
            );

            return {
              'id': registeredUser.uid,
              'name': contact['fullname'],
              'phoneNumber': contact['phonenmper'],
            };
          })
          .toList();
      return matchedContacts;
    } on Exception catch (e) {
      log('Error getting registered contacts: $e');
      return [];
    }
  }
}
