import 'package:agenda_eletronica/create_contact.dart';
import 'package:agenda_eletronica/home_sceen_provider.dart';
import 'package:agenda_eletronica/models/contact.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (c) => HomeScreenProvider(),
      child: Consumer<HomeScreenProvider>(builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Center(
              child: Text("Contatos"),
            ),
            elevation: 0,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (c) {
                  return ChangeNotifierProvider.value(
                    value: provider,
                    child: const CreateContact(),
                  );
                }),
              );
            },
            child: const Icon(Icons.add),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: provider.contactController,
                      decoration: const InputDecoration(
                        isDense: true,
                        hintText: 'Buscar',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  ...provider.contacts.map((e) {
                    return contactToWidget(e);
                  }),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget contactToWidget(Contact contact) {
    return GestureDetector(
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(
            Icons.person,
            color: Colors.white,
            size: 30,
          ),
        ),
        title: Text(contact.name),
        subtitle: Text(contact.phone),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.edit_rounded,
            color: Colors.black,
            size: 30,
          ),
        ),
      ),
    );
  }
}
