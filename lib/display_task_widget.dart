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

import 'add_task_button.dart';
import 'constants.dart';
import 'custom_list_title.dart';
import 'login_screen.dart';

class DisplayTaskWidget extends StatefulWidget {
  final Future<List<Task>> tasksFuture;

  const DisplayTaskWidget({Key? key, required this.tasksFuture}) : super(key: key);

  @override
  State<DisplayTaskWidget> createState() => _DisplayTaskWidgetState();
}

class _DisplayTaskWidgetState extends State<DisplayTaskWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Task>>(
        future: widget.tasksFuture,
        builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
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
                  onCheckboxChanged: (value) async {
                    await db
                        .collection("tasks")
                        .doc(tasks[index].id)
                        .update({"isChecked": value});

                    setState(() {
                      tasks[index].isChecked = value;
                    });
                  },
                  onFavourite: () {},
                  onDelete: () async {
                    await db.collection("tasks").doc(tasks[index].id).delete();
                    setState(() {
                      tasks.removeAt(index);
                    });
                  },
                );
              },
            );
          }
        },

    );
  }
}
