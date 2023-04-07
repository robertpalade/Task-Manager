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
                      description: tasks[index].description!,
                      isChecked: tasks[index].isChecked,
                      date: tasks[index].date!,
                      onCheckboxChanged: (bool) {},
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
              final titleController = TextEditingController();
              final descriptionController = TextEditingController();
              final dateController = TextEditingController();
              return AlertDialog(
                title: const Text('Add task'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration:
                      const InputDecoration(hintText: 'Enter task title'),
                    ),
                    TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                          hintText: 'Enter task description'),
                    ),
                    TextFormField(
                      controller: dateController,
                      decoration: const InputDecoration(
                          hintText: 'Enter task date and time (YYYY-MM-DD HH:mm)'),
                      keyboardType: TextInputType.datetime,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a date and time';
                        }
                        return null;
                      },
                    ),
                  ],
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
                        title: titleController.text,
                        description: descriptionController.text,
                        date: DateTime.parse(dateController.text),
                        userId: auth.currentUser!.uid,
                      );
                      DocumentReference ref =
                      await db.collection('tasks').add(task.toMap());
                      task.id = ref.id;

                      setState(() {
                        _tasksFuture = getTasks(auth.currentUser!.uid);
                      });

                      // Add a notification
                      // if (DateTime.now().isBefore(task.date!)) {
                      //   await flutterLocalNotificationsPlugin.zonedSchedule(
                      //     0,
                      //     'Reminder: ${task.title}',
                      //     task.description,
                      //     tz.TZDateTime.from(task.date!, tz.local),
                      //     const NotificationDetails(
                      //       android: AndroidNotificationDetails(
                      //           'your channel id', 'your channel name',
                      //           importance: Importance.high,
                      //           priority: Priority.high),
                      //     ),
                      //     androidAllowWhileIdle: true,
                      //     uiLocalNotificationDateInterpretation:
                      //     UILocalNotificationDateInterpretation.absoluteTime,
                      //   );
                      // }
                      //
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
