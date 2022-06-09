import 'dart:io';

import 'package:agenda_eletronica/models/Address.dart';

class Contact {
  String name;
  List<String> phones;
  Address address;
  String? email;
  String? image;
  String? id;
  String? remainder;

  Future<String?> get safeImage async {
    if (image == null) {
      return null;
    } else {
      if (await File(image!).exists()) {
        return image;
      }
    }
    return null;
  }

  Contact({
    required this.name,
    required this.phones,
    required this.address,
    this.email,
    this.image,
    this.id,
    this.remainder,
  });

  factory Contact.fromMap(Map<String, dynamic> map) {
    Map<String, dynamic> phones = map['phones'];
    List<dynamic> ps = phones.values.toList();
    return Contact(
      name: map['name'],
      phones: ps.map((phone) => phone.toString()).toList(),
      address: Address.fromMap(map['address']),
      email: map['email'],
      image: map['profile_picture'],
      id: map['id'],
      remainder: map['remainder'],
    );
  }
}
