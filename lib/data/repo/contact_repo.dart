import 'dart:developer';
import 'package:chat_app/config/injection/injection.dart';
import 'package:chat_app/data/model/contact_model.dart';
import 'package:chat_app/data/services/auth_remote.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactRepo {
  String get currentUserId => FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<bool> requestContactsPermission() async {
    return await FlutterContacts.requestPermission();
  }

  Future<ContactViewModel> getRegisteredContacts() async {
    try {
      final bool hasPermission = await requestContactsPermission();
      if (!hasPermission) {
        log('Contacts permission denied');
        return ContactViewModel(matchedContacts: [], phoneNumpers: []);
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
              "phonenmper": contact.phones.isNotEmpty
                  ? contact.phones.first.number.replaceAll(
                      RegExp(r'[^\d+]'),
                      '',
                    )
                  : "",
              "photo": contact.photo,
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
              (final user) =>
                  user.phoneNumber == phoneNumper && user.uid != currentUserId,
            );
          })
          .map((final contact) {
            String phoneNumber = contact["phonenmper"]
                .toString(); // Ensure it's a String

            if (phoneNumber.startsWith("+20")) {
              phoneNumber = phoneNumber.substring(3);
            }

            final registeredUser = rejesterUsers.firstWhere(
              (final user) => user.phoneNumber == phoneNumber,
            );

            return ContactModel.fromjson(contact, uid: registeredUser.uid);
          })
          .toList();

      return ContactViewModel(
        matchedContacts: matchedContacts,
        phoneNumpers: phoneNumpers
            .map((e) => ContactModel.fromjson(e))
            .toList(),
      );
    } on Exception catch (e) {
      log('Error getting registered contacts: $e');
      return ContactViewModel(matchedContacts: [], phoneNumpers: []);
    }
  }
}

class ContactViewModel {
  final List<ContactModel> matchedContacts;
  final List<ContactModel> phoneNumpers;

  ContactViewModel({required this.matchedContacts, required this.phoneNumpers});
}
