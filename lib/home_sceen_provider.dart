import 'dart:convert';

import 'package:agenda_eletronica/create_contact.dart';
import 'package:agenda_eletronica/models/contact.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class HomeScreenProvider with ChangeNotifier {
  HomeScreenProvider(this.context) {
    _getContact();
  }
  final TextEditingController contactController = TextEditingController();

  final BuildContext context;
  List<Contact>? _originalContacts;
  Future<List<Contact>> get originalContacts async {
    _originalContacts ??= await _getContact();
    return _originalContacts!;
  }

  void setOriginalContacts(List<Contact>? contactlist) {
    _originalContacts = contactlist;
    notifyListeners();
  }

  Future<Iterable<Contact>> get filteredContacts async {
    if (contactController.text.isEmpty) {
      return originalContacts;
    } else {
      return (await originalContacts).where((x) => filterByName(x) || filterByPhones(x));
    }
  }

  bool filterByName(Contact x) => x.name.toLowerCase().contains(contactController.text.toLowerCase());
  bool filterByPhones(Contact x) {
    return x.phones.any((e) => e.toLowerCase().contains(contactController.text.toLowerCase()));
  }

  void searchContacts() {
    notifyListeners();
  }

  Future<List<Contact>> _getContact() async {
    List<Contact> contacts = [];
    var r = await http.get(
      Uri.parse("https://nwwy2vhfj2.execute-api.sa-east-1.amazonaws.com/dev/users"),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    String body = utf8.decode(r.body.codeUnits);
    Map<String, dynamic> json = jsonDecode(body);
    List<dynamic> rawContacts = json['result'];
    for (Map<String, dynamic> contact in rawContacts) {
      contacts.add(Contact.fromMap(contact));
    }
    return contacts;
  }

  void _updateContactsFromAPI() {
    setOriginalContacts(null);
  }

  void createContact() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (c) {
        return const CreateContact();
      }),
    );
    _updateContactsFromAPI();
  }

  void editingButton(Contact contact) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (c) {
        return CreateContact(
          contact: contact,
        );
      }),
    );
    _updateContactsFromAPI();
  }
}
