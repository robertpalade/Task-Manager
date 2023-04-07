import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/main.dart';
import 'package:task_manager/task.dart';

import 'constants.dart';
import 'custom_list_title.dart';
import 'login_screen.dart';

class MyListView extends StatefulWidget {
  const MyListView({super.key});

  @override
  State<MyListView> createState() => _MyListViewState();
}

class _MyListViewState extends State<MyListView> {
  late Future<List<Task>> _tasksFuture;

  @override
  void initState() {
    // TODO: implement initState
    _tasksFuture = getTasks(auth.currentUser!.uid);
    super.initState();
  }

  Future<void> downloadFromDatabase() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {});
  }

  Future<List<Task>> getTasks(String uid) async {
    List<Task> tasks = [];

    QuerySnapshot snapshot =
        await db.collection('tasks').where('userId', isEqualTo: uid).get();

    snapshot.docs.forEach((doc) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      if (data != null) {
        Task task = Task.fromMap(data);
        task.id = doc.id;
        tasks.add(task);
      }
    });

    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
      ),
      body: Column(
        children: [
          FutureBuilder<List<Task>>(
            future: _tasksFuture,
            builder:
                (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<Task> tasks = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: tasks.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CustomListTile(
                      title: tasks[index].title,
                      isChecked: false,
                      description: "bla bla",
                      // onCheckboxChanged: (bool) {},
                      onFavourite: () {},
                      onDelete: () async {
                        await db
                            .collection("tasks")
                            .doc(tasks[index].id)
                            .delete();
                        setState(() {
                          tasks.removeAt(index);
                        });
                      },
                    );
                  },
                );
              }
            },
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
                    onPressed: () async {
                      Task task = Task(
                        title: textController.text,
                        userId: auth.currentUser!.uid,
                      );
                      DocumentReference ref =
                          await db.collection('tasks').add(task.toMap());
                      task.id = ref.id;

                      setState(() {
                        _tasksFuture = getTasks(auth.currentUser!.uid);
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
