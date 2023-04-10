import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/task.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:task_manager/weather_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:weather/weather.dart';

import 'add_task_button.dart';
import 'constants.dart';
import 'display_task_widget.dart';
import 'login_screen.dart';

class MyListView extends StatefulWidget {
  const MyListView({super.key});

  @override
  State<MyListView> createState() => _MyListViewState();
}

class _MyListViewState extends State<MyListView> {
  late Future<List<Task>> _tasksFuture;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  late Future<Weather> _weather;

  // final wf = WeatherFactory('AdgPZDDH8ogGBYkJMcu3D0JMHIkWAQB6');
  // final Weather? currentWeather = wf.currentWeatherByCityName('Bucharest') as Weather?;

  @override
  void initState() {
    _tasksFuture = getTasks(auth.currentUser!.uid);
    super.initState();
    _weather = _getWeather();
    // Handle incoming notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      AndroidNotification? android = message.notification?.android;
    });
    // Get the current notification settings
    _firebaseMessaging.requestPermission();
  }

  Future<Weather> _getWeather() async {
    WeatherFactory wf = WeatherFactory(
      "de92591a98dea437f95642b0fe92bf17",
      language: Language.ROMANIAN,
    );
    Weather weather = await wf.currentWeatherByCityName("Bucharest");
    return weather;
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

    final user = FirebaseAuth.instance.currentUser;
    final displayName = user != null ? user.displayName ?? user.email : '';
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  WeatherWidget(),
                  // Positioned(
                  //   left: 16.0,
                  //   bottom: 16.0,
                  //   child: Text(
                  //     'Welcome, $displayName',
                  //     style: TextStyle(
                  //       fontSize: 16.0,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              centerTitle: true,
              title: Text('Task Manager'),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
                icon: Tooltip(
                  message: 'Logout',
                  child: Icon(Icons.exit_to_app),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: DisplayTaskWidget(tasksFuture: _tasksFuture),
          ),
        ],
      ),
      floatingActionButton: AddTaskButton(
        callback: () {
          setState(() {
            _tasksFuture = getTasks(auth.currentUser!.uid);
          });
        },
      ),
    );
  }

}
