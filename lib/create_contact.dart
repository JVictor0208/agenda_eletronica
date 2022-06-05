import 'package:agenda_eletronica/create_contact_provider.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:day_night_time_picker/lib/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateContact extends StatelessWidget {
  const CreateContact({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (c) => CreateContactProvider(),
      child: Consumer<CreateContactProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Center(
                child: Text("Novo contato"),
              ),
              elevation: 0,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Icon(
                      Icons.account_circle,
                      size: 150,
                      color: Colors.grey,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          textFieldToWidget('Nome'),
                          textFieldToWidget('Sobrenome'),
                          textFieldToWidget('Telefone 1'),
                          textFieldToWidget('Telefone 2'),
                          textFieldToWidget('Email'),
                          textFieldToWidget('Empresa'),
                          const SizedBox(
                            height: 10,
                          ),
                          getAddressPanel(provider, context),
                          getBirthdayPanel(provider, context),
                          getReminderPanel(provider, context),
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
          textFieldToWidget('CEP'),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: textFieldToWidget('Cidade'),
              ),
              Expanded(
                child: textFieldToWidget('UF'),
              ),
            ],
          ),
          textFieldToWidget('Logradouro'),
          textFieldToWidget('Número'),
          textFieldToWidget('Complemento'),
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
              initialDateTime: provider.dateTime,
              onDateTimeChanged: (dateTime) {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ButtonStyle(elevation: MaterialStateProperty.all(0)),
                onPressed: () {},
                child: const Text('Salvar'),
              ),
            ),
          )
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

  Widget getReminderPanel(CreateContactProvider provider, BuildContext context) {
    if (provider.hasReminder) {
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
                      context.read<CreateContactProvider>().hasReminder = false;
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
              initialDateTime: provider.dateTime,
              onDateTimeChanged: (dateTime) {},
            ),
          ),
          createInlinePicker(
            okText: '',
            cancelText: '',
            elevation: 1,
            value: TimeOfDay.now().replacing(hour: 11, minute: 30),
            onChange: (m) {},
            minuteInterval: MinuteInterval.FIVE,
            iosStylePicker: true,
            minHour: 9,
            maxHour: 21,
            is24HrFormat: false,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ButtonStyle(elevation: MaterialStateProperty.all(0)),
                onPressed: () {},
                child: const Text('Salvar'),
              ),
            ),
          )
        ],
      );
    } else {
      return ListTile(
        onTap: () {
          context.read<CreateContactProvider>().hasReminder = true;
        },
        leading: const Icon(
          Icons.add_circle,
          color: Colors.green,
        ),
        title: const Text('Adicionar Lembrete'),
      );
    }
  }

  Widget textFieldToWidget(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
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
