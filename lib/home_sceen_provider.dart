import 'package:agenda_eletronica/models/contact.dart';
import 'package:flutter/material.dart';

class HomeScreenProvider with ChangeNotifier {
  final TextEditingController contactController = TextEditingController();

  List<Contact> contacts = [
    Contact(name: "Victor", phone: "85 996639598"),
  ];
}
