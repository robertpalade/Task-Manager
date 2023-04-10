import 'dart:html' as html;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/task.dart';

import 'constants.dart';

class AddTaskButton extends StatefulWidget {
  final Function() callback;

  const AddTaskButton({Key? key, required this.callback}) : super(key: key);

  @override
  State<AddTaskButton> createState() => _AddTaskButtonState();
}

class _AddTaskButtonState extends State<AddTaskButton> {
  final _formKey = GlobalKey<FormState>();

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
            DateTime _selectedDate =
                DateTime.now();
            return AlertDialog(
              title: const Text('Add task'),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration:
                          const InputDecoration(hintText: 'Enter task title'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a task title';
                        }
                        return null;
                      },
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
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

                    Task task = Task(
                      title: titleController.text,
                      description: descriptionController.text.isNotEmpty
                          ? descriptionController.text
                          : '',
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
