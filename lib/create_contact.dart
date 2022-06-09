import 'dart:io';

import 'package:agenda_eletronica/create_contact_provider.dart';
import 'package:agenda_eletronica/models/contact.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:day_night_time_picker/lib/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateContact extends StatelessWidget {
  const CreateContact({Key? key, this.contact}) : super(key: key);

  final Contact? contact;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (c) => CreateContactProvider(
        c,
        contact,
      ),
      child: Consumer<CreateContactProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: AppBar(
              title: Center(
                child: getContactState(provider),
              ),
              elevation: 0,
              actions: [getActionButton(context, provider)],
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    getProfileImage(provider),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          textFieldToWidget('Nome', provider.firstNameController),
                          textFieldToWidget('Sobrenome', provider.surname),
                          textFieldToWidget('Telefone 1', provider.phone1),
                          textFieldToWidget('Telefone 2', provider.phone2),
                          textFieldToWidget('Email', provider.emailController),
                          const SizedBox(
                            height: 10,
                          ),
                          getAddressPanel(provider, context),
                          getBirthdayPanel(provider, context),
                          getRemainderPanel(provider, context),
                          getDeleteButton(context, provider)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Text getContactState(CreateContactProvider provider) {
    if (provider.isEditing) {
      return const Text("Contato");
    } else {
      return const Text("Novo contato");
    }
  }

  Widget getDeleteButton(BuildContext context, CreateContactProvider provider) {
    if (provider.isEditing) {
      return Column(
        children: [
          const Divider(),
          TextButton(
            onPressed: () async {
              await context.read<CreateContactProvider>().deleteContact();
            },
            child: const Text(
              'Apagar contato',
              style: TextStyle(
                color: Colors.red,
                fontSize: 17,
              ),
            ),
          ),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget getActionButton(BuildContext context, CreateContactProvider provider) {
    if (provider.isSaving) {
      return const Center(
          child: CircularProgressIndicator(
        color: Colors.white,
      ));
    } else {
      return TextButton(
        onPressed: () {
          context.read<CreateContactProvider>().onTap();
        },
        child: const Text(
          "Salvar",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }
  }

  Widget getProfileImage(CreateContactProvider provider) {
    if (provider.image == null) {
      return IconButton(
        iconSize: 150,
        icon: const Icon(
          Icons.account_circle,
          color: Colors.grey,
        ),
        onPressed: provider.pickImage,
      );
    } else {
      return InkWell(
        onTap: provider.pickImage,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: CircleAvatar(
            foregroundImage: Image.file(File(provider.image!)).image,
            radius: 75,
          ),
        ),
      );
    }
  }

  Widget getAddressPanel(CreateContactProvider provider, BuildContext context) {
    if (provider.hasAdress) {
      return Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Endereço',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      context.read<CreateContactProvider>().hasAdress = false;
                    },
                    icon: const Icon(
                      Icons.remove_circle,
                      color: Colors.red,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
          textFieldToWidget('CEP', provider.zipCode),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: textFieldToWidget('Cidade', provider.city),
              ),
              Expanded(
                child: textFieldToWidget('UF', provider.uf),
              ),
            ],
          ),
          textFieldToWidget('Logradouro', provider.street),
          textFieldToWidget('Número', provider.houseNumber),
          textFieldToWidget('Complemento', provider.complement),
        ],
      );
    } else {
      return ListTile(
        onTap: () {
          context.read<CreateContactProvider>().hasAdress = true;
        },
        leading: const Icon(
          Icons.add_circle,
          color: Colors.green,
        ),
        title: const Text('Adicionar Endereço'),
      );
    }
  }

  Widget getBirthdayPanel(CreateContactProvider provider, BuildContext context) {
    if (provider.hasBirthday) {
      return Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Aniversário',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      context.read<CreateContactProvider>().hasBirthday = false;
                    },
                    icon: const Icon(
                      Icons.remove_circle,
                      color: Colors.red,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 180,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: DateTime.now(),
              onDateTimeChanged: (dateTime) {
                context.read<CreateContactProvider>().selectedBirthDate = dateTime;
              },
            ),
          ),
        ],
      );
    } else {
      return ListTile(
        onTap: () {
          context.read<CreateContactProvider>().hasBirthday = true;
        },
        leading: const Icon(
          Icons.add_circle,
          color: Colors.green,
        ),
        title: const Text('Adicionar Aniversário'),
      );
    }
  }

  Widget getRemainderPanel(CreateContactProvider provider, BuildContext context) {
    if (provider.hasRemainder) {
      return Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Lembrete',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      context.read<CreateContactProvider>().hasRemainder = false;
                    },
                    icon: const Icon(
                      Icons.remove_circle,
                      color: Colors.red,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 100,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (dateTime) {
                context.read<CreateContactProvider>().selectedRemainderDate = dateTime;
              },
            ),
          ),
          createInlinePicker(
            okText: '',
            cancelText: '',
            elevation: 1,
            value: TimeOfDay.now().replacing(hour: 11, minute: 30),
            onChange: (t) {
              context.read<CreateContactProvider>().selectRemainderTime(t);
            },
            isOnChangeValueMode: true,
            minuteInterval: MinuteInterval.FIVE,
            iosStylePicker: true,
            minHour: 7,
            maxHour: 23,
            is24HrFormat: false,
          ),
        ],
      );
    } else {
      return ListTile(
        onTap: () {
          context.read<CreateContactProvider>().hasRemainder = true;
        },
        leading: const Icon(
          Icons.add_circle,
          color: Colors.green,
        ),
        title: const Text('Adicionar Lembrete'),
      );
    }
  }

  Widget textFieldToWidget(String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: title,
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
