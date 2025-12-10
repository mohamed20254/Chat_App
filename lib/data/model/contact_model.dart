import 'dart:typed_data';

class ContactModel {
  final String? id;
  final String phoneNumper;
  final String name;
  final Uint8List? photo;

  ContactModel({
    required this.id,
    required this.phoneNumper,
    required this.name,
    this.photo,
  });

  factory ContactModel.fromjson(
    final Map<String, dynamic> json, {
    final String? uid,
    final List<ContactModel>? unregeaster,
  }) {
    return ContactModel(
      id: uid,
      phoneNumper: json["phonenmper"] ?? "numper is empty",
      name: json["fullname"] ?? "NO Name",
      photo: json["photo"],
    );
  }
}
