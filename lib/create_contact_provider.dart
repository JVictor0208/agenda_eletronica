import 'package:flutter/material.dart';

class CreateContactProvider with ChangeNotifier {
  DateTime dateTime = DateTime.now();

  bool _hasAdress = false;
  bool get hasAdress => _hasAdress;
  set hasAdress(bool v) {
    _hasAdress = v;
    notifyListeners();
  }

  bool _hasBirthday = false;
  bool get hasBirthday => _hasBirthday;
  set hasBirthday(bool v) {
    _hasBirthday = v;
    notifyListeners();
  }

  bool _hasReminder = false;
  bool get hasReminder => _hasReminder;
  set hasReminder(bool v) {
    _hasReminder = v;
    notifyListeners();
  }
}
