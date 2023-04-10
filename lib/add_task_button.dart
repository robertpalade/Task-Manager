import 'dart:html' as html;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/task.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:task_manager/weather_widget.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:weather/weather.dart';

import 'constants.dart';
import 'custom_list_title.dart';
import 'login_screen.dart';

class AddTaskButton extends StatefulWidget {
  final Function() callback;
  const AddTaskButton({Key? key, required this.callback}) : super(key: key);

  @override
  State<AddTaskButton> createState() => _AddTaskButtonState();
}

class _AddTaskButtonState extends State<AddTaskButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: 'Add task',
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            final titleController = TextEditingController();
            final descriptionController = TextEditingController();
            // final dateController = TextEditingController();
            DateTime _selectedDate =
            DateTime.now(); // declare _selectedDate here
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
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('Pick a date'),
                    subtitle: Text(
                      '${DateFormat.yMd().add_jm().format(_selectedDate)}',
                    ),
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365 * 5)),
                      );
                      if (picked != null) {
                        TimeOfDay? time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(_selectedDate),
                        );
                        if (time != null) {
                          setState(() {
                            _selectedDate = DateTime(
                              picked.year,
                              picked.month,
                              picked.day,
                              time.hour,
                              time.minute,
                            );
                          });
                        }
                      }
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
                      date: _selectedDate,
                      userId: auth.currentUser!.uid,
                    );
                    DocumentReference ref =
                    await db.collection('tasks').add(task.toMap());
                    task.id = ref.id;
widget.callback();

                    // Add a notification
                    if (task.date != null &&
                        DateTime.now().isBefore(task.date!)) {
                      var selectedDate = task.date!;
                      var currentDate = DateTime.now();

                      if (currentDate.year == selectedDate.year &&
                          currentDate.month == selectedDate.month &&
                          currentDate.day == selectedDate.day &&
                          currentDate.hour == selectedDate.hour &&
                          currentDate.minute == selectedDate.minute) {
                        if (html.Notification.supported) {
                          if (html.Notification.permission == 'granted') {
                            html.Notification('Reminder: ${task.title}',
                                body: task.description,
                                icon: 'path/to/notification-icon.png');
                          } else if (html.Notification?.permission !=
                              'denied') {
                            html.Notification.requestPermission()
                                .then((permission) {
                              if (permission == 'granted') {
                                html.Notification('Reminder: ${task.title}',
                                    body: task.description,
                                    icon: 'path/to/notification-icon.png');
                              }
                            });
                          }
                        }
                      }
                    }

                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      child: const Icon(Icons.add),
    );
  }
}
