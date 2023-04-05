import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/main.dart';

import 'custom_list_title.dart';
import 'login_screen.dart';

class MyListView extends StatefulWidget {
  const MyListView({super.key});

  @override
  State<MyListView> createState() => _MyListViewState();
}

class _MyListViewState extends State<MyListView> {
  List<String> myData = ['Item 1', 'Item 2', 'Item 3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: myData.length,
              itemBuilder: (BuildContext context, int index) {
                return CustomListTile(
                  title: myData[index],
                  isChecked: false,
                  description: "bla bla",
                  // onCheckboxChanged: (bool) {},
                  onFavourite: () {},
                  onDelete: () {
                    setState(() {
                      myData.removeAt(index);
                    });
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              );
            },
            child: const Text('Sign out'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add task',
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              final textController = TextEditingController();
              return AlertDialog(
                title: const Text('Add task'),
                content: TextFormField(
                  controller: textController,
                  decoration:
                      const InputDecoration(hintText: 'Enter text here'),
                ),
                actions: <Widget>[
                  ElevatedButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  ElevatedButton(
                    child: const Text('OK'),
                    onPressed: () {
                      setState(() {
                        myData.add(textController.text);
                        print(myData);
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
