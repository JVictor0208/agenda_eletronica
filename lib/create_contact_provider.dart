import 'dart:convert';
import 'package:agenda_eletronica/models/address.dart';
import 'package:agenda_eletronica/models/contact.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;

class CreateContactProvider with ChangeNotifier {
  DateTime? selectedBirthDate;
  DateTime? selectedRemainderDate;
  BuildContext context;
  final Contact? contact;
  String? _image;

  String? get image => _image;

  set image(String? image) {
    _image = image;
    notifyListeners();
  }

  CreateContactProvider(
    this.context,
    this.contact,
  ) {
    if (contact != null) {
      name = contact!.name;
      _setImage(contact!.safeImage);
      phone1.text = contact!.phones[0];
      if (contact!.phones.length >= 2) {
        phone2.text = contact!.phones[1];
      }
      emailController.text = contact!.email ?? '';
      hasAdress = true;
      zipCode.text = contact!.address.cep ?? '';
      city.text = contact!.address.city ?? '';
      uf.text = contact!.address.uf ?? '';
      street.text = contact!.address.street ?? '';
      houseNumber.text = contact!.address.number ?? '';
      complement.text = contact!.address.complement ?? '';
    }
  }

  void _setImage(Future<String?> v) async {
    image = await v;
  }

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController surname = TextEditingController();
  final TextEditingController phone1 = TextEditingController();
  final TextEditingController phone2 = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController zipCode = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController uf = TextEditingController();
  final TextEditingController street = TextEditingController();
  final TextEditingController houseNumber = TextEditingController();
  final TextEditingController complement = TextEditingController();

  String get name => '${firstNameController.text} ${surname.text}';

  set name(String v) {
    var parts = v.split(' ');
    firstNameController.text = parts[0];
    surname.text = parts.length > 1 ? parts[1] : '';
  }

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  set isSaving(bool b) {
    _isSaving = b;
    notifyListeners();
  }

  bool get isEditing => contact != null;

  void selectRemainderTime(TimeOfDay timeOfDay) {
    var dt = selectedRemainderDate ?? DateTime.now();
    selectedRemainderDate = DateTime(dt.year, dt.month, dt.day, timeOfDay.hour, timeOfDay.minute);
  }

  Future<void> onTap() async {
    isSaving = true;
    try {
      if (contact == null) {
        await createContact();
      } else {
        await updateContact();
      }
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      await flutterLocalNotificationsPlugin.zonedSchedule(
          0,
          'Lembrete!',
          'Ligar para $name',
          tz.TZDateTime.from(selectedRemainderDate!, tz.local),
          //tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
          const NotificationDetails(
              android: AndroidNotificationDetails('your channel id', 'your channel name', channelDescription: 'your channel description')),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
      Navigator.pop(context);
    } finally {
      isSaving = false;
    }
  }

  void pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      image = result.files.single.path!;
    }
  }

  Address get address => Address(
        cep: zipCode.text,
        city: city.text,
        uf: uf.text,
        street: street.text,
        number: houseNumber.text,
        complement: complement.text,
      );
  String? get email => emailController.text.isEmpty ? null : emailController.text;

  Future<void> createContact() async {
    Map<String, dynamic> numero = {'phone1': phone1.text, 'phone2': phone2.text};
    Map<String, dynamic> endereco = address.toMap();
    String jsonBody = jsonEncode({
      'name': name,
      'phones': numero,
      'profile_picture': image,
      'email': email,
      'adress': endereco,
      'birthDate': selectedBirthDate?.toIso8601String(),
      'remainder': selectedRemainderDate?.toIso8601String(),
    });
    var r = await http.put(
      Uri.parse("https://nwwy2vhfj2.execute-api.sa-east-1.amazonaws.com/dev/users"),
      body: jsonBody,
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (r.statusCode != 200) {
      throw Exception(r.body);
    }
  }

  Future<void> deleteContact() async {
    String jsonBody = jsonEncode({
      'id': contact!.id,
    });
    var r = await http.delete(
      Uri.parse("https://nwwy2vhfj2.execute-api.sa-east-1.amazonaws.com/dev/users"),
      body: jsonBody,
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (r.statusCode == 200) {
      Navigator.pop(context);
    } else {
      debugPrint(r.body);
    }
  }

  Future<void> updateContact() async {
    Map<String, dynamic> numero = {'phone1': phone1.text, 'phone2': phone2.text};
    Map<String, dynamic> endereco = address.toMap();
    String jsonBody = jsonEncode({
      'id': contact!.id,
      'update': {
        'name': name,
        'profile_picture': image,
        'phones': numero,
        'email': email,
        'adress': endereco,
        'birthDate': selectedBirthDate?.toIso8601String(),
        'remainder': selectedRemainderDate?.toIso8601String(),
      }
    });
    var r = await http.post(
      Uri.parse("https://nwwy2vhfj2.execute-api.sa-east-1.amazonaws.com/dev/users"),
      body: jsonBody,
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (r.statusCode != 200) {
      throw Exception(r.body);
    }
  }

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
  bool get hasRemainder => _hasReminder;
  set hasRemainder(bool v) {
    _hasReminder = v;
    notifyListeners();
  }
}
