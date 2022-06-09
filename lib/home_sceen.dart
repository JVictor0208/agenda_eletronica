import 'dart:io';

import 'package:agenda_eletronica/home_sceen_provider.dart';
import 'package:agenda_eletronica/models/contact.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (c) => HomeScreenProvider(c),
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
              context.read<HomeScreenProvider>().createContact();
            },
            child: const Icon(Icons.add),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: provider.contactController,
                      decoration: const InputDecoration(
                        isDense: true,
                        hintText: 'Buscar',
                        border: InputBorder.none,
                      ),
                      onChanged: (a) {
                        context.read<HomeScreenProvider>().searchContacts();
                      },
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder<Iterable<Contact>>(
                      builder: (context, snap) {
                        if (snap.hasData) {
                          return SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: <Widget>[
                                ...snap.requireData.map(
                                  (e) {
                                    return contactToWidget(context, e);
                                  },
                                ),
                              ],
                            ),
                          );
                        } else if (snap.hasError) {
                          return Text('${snap.error}');
                        } else {
                          return const Center(child: CircularProgressIndicator());
                        }
                      },
                      future: provider.filteredContacts,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget contactToWidget(BuildContext context, Contact contact) {
    return GestureDetector(
      child: ListTile(
        onTap: () {
          context.read<HomeScreenProvider>().editingButton(contact);
        },
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: getImageContact(contact),
        ),
        title: Text(contact.name),
        subtitle: Text(contact.phones[0]),
        trailing: IconButton(
          onPressed: () {
            context.read<HomeScreenProvider>().editingButton(contact);
          },
          icon: const Icon(
            Icons.edit_rounded,
            color: Colors.black,
            size: 30,
          ),
        ),
      ),
    );
  }

  Widget getImageContact(Contact contact) {
    return FutureBuilder<String?>(
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.done) {
          if (snap.data == null) {
            return const Icon(
              Icons.account_circle,
              color: Colors.deepPurple,
              size: 40,
            );
          } else {
            return CircleAvatar(
              foregroundImage: Image.file(File(snap.data!)).image,
              radius: 75,
            );
          }
        } else if (snap.hasError) {
          return const Icon(
            Icons.account_circle,
            color: Colors.red,
            size: 40,
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
      future: contact.safeImage,
    );
  }
}
