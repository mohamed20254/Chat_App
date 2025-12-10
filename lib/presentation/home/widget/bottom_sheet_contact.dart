import 'package:chat_app/config/injection/injection.dart';
import 'package:chat_app/config/routing/app_routing.dart';
import 'package:chat_app/core/helper/cereat_colors.dart';
import 'package:chat_app/data/model/contact_model.dart';
import 'package:chat_app/data/repo/contact_repo.dart';
import 'package:flutter/material.dart';

Future<void> showBottomSheetContact(final BuildContext contextt) {
  return showModalBottomSheet(
    isScrollControlled: true,
    context: contextt,
    builder: (final context) {
      return Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.9,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        decoration: const BoxDecoration(),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text("Contact", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder(
                future: sl<ContactRepo>().getRegisteredContacts(),
                builder: (final context, final snapshot) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasData) {
                    final matchedData = snapshot.data!.matchedContacts;
                    final contacts = snapshot.data!.phoneNumpers;

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Divider(color: Theme.of(context).primaryColor),
                          Text(
                            "registered",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 10),
                          matchedData.isNotEmpty
                              ? Column(
                                  children: List.generate(matchedData.length, (
                                    final index,
                                  ) {
                                    final matchcontac = matchedData[index];
                                    return InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          contextt,
                                          AppRouting.chat,
                                          arguments: matchcontac,
                                        );
                                      },
                                      child: _customListTile(
                                        context,
                                        matchcontac,
                                      ),
                                    );
                                  }),
                                )
                              : const Text("No contact regetration"),
                          const SizedBox(height: 10),

                          Divider(color: Theme.of(context).primaryColor),
                          Text(
                            "Contact your device",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),

                          const SizedBox(height: 10),
                          contacts.isNotEmpty
                              ? Column(
                                  children: List.generate(contacts.length, (
                                    final index,
                                  ) {
                                    final contact = contacts[index];
                                    return _customListTile(context, contact);
                                  }),
                                )
                              : const Text("No contact "),
                        ],
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

ListTile _customListTile(
  final BuildContext context,
  final ContactModel contact,
) {
  return ListTile(
    leading: CircleAvatar(
      backgroundColor: randomColor().withValues(alpha: 0.4),
      child: Text(
        contact.name[0].toString().toUpperCase(),
        style: Theme.of(
          context,
        ).textTheme.titleSmall!.copyWith(color: Colors.black),
      ),
    ),
    title: Text(
      contact.name.toString(),
      style: Theme.of(context).textTheme.bodyLarge,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    ),
    subtitle: Text(
      contact.phoneNumper.toString(),
      style: Theme.of(context).textTheme.bodySmall,
    ),

    trailing: contact.id != null
        ? null
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(
                context,
              ).primaryColor.withValues(alpha: 0.2),
              padding: const EdgeInsets.all(0),
            ),
            onPressed: () {},
            child: Text(
              "Invite",
              style: Theme.of(
                context,
              ).textTheme.labelLarge!.copyWith(height: 0),
            ),
          ),
  );
}
