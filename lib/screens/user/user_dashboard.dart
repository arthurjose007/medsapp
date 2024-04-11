// ignore_for_file: avoid_types_as_parameter_names

// import 'dart:async';

// import 'package:alarm/alarm.dart';
import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meds/screens/user/alarm/alarm_ring.dart';
import 'package:meds/screens/chat/chat_main.dart';
import 'package:meds/screens/user/medication.dart';
import 'package:meds/screens/user/more/more.dart';
import 'package:meds/screens/user/store/view_store_screen.dart';
import 'package:meds/screens/user/user_home_screen.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  final user = FirebaseAuth.instance.currentUser;

  //bottom nav bar
  int _selectedIndex = 0;

  //alarm list
  late List<AlarmSettings> alarms;

  static StreamSubscription? subscription;

  void loadAlarms() {
    setState(() {
      alarms = Alarm.getAlarms();
      alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    });
  }

//show alarm ring screen
  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AlarmScreen(alarmSettings: alarmSettings),
        ));
    loadAlarms();
  }

  @override
  void initState() {
    loadAlarms();
    subscription ??= Alarm.ringStream.stream.listen(
      (alarmSettings) => navigateToRingScreen(alarmSettings),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //pages
    final List<Widget> pages = <Widget>[
      //main page
      const UserHomeScreen(),
      //medication
      const Mediaction(),
      //statistic
      const ViewStoreScreen(),
      //chat
      const ChatMain(),
      //settings
      const More(),
    ];

    //scaffold
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(),
      ),
      body: SafeArea(
        child: Center(
          child: pages.elementAt(_selectedIndex),
        ),
      ),

      //bottom navigation
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color.fromARGB(255, 242, 253, 255),
        destinations: const [
          //home
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
            ),
            label: "Home",
            selectedIcon: Icon(
              Icons.home_rounded,
              color: Color.fromRGBO(7, 82, 96, 1),
            ),
          ),
          //medications
          NavigationDestination(
            icon: Icon(
              Icons.medication_outlined,
            ),
            label: "Medication",
            selectedIcon: Icon(
              Icons.medication,
              color: Color.fromRGBO(7, 82, 96, 1),
            ),
          ),
          //history
          NavigationDestination(
            icon: Icon(
              Icons.shopping_bag_outlined,
            ),
            label: "Store",
            selectedIcon: Icon(
              Icons.shopping_bag,
              color: Color.fromRGBO(7, 82, 96, 1),
            ),
          ),
          NavigationDestination(
            icon: Icon(
              Icons.chat_bubble_outline,
            ),
            label: "Chat",
            selectedIcon: Icon(
              Icons.chat,
              color: Color.fromRGBO(7, 82, 96, 1),
            ),
          ),
          //settings
          NavigationDestination(
            icon: Icon(
              Icons.dashboard_customize_outlined,
            ),
            label: "More",
            selectedIcon: Icon(
              Icons.dashboard_customize_rounded,
              color: Color.fromRGBO(7, 82, 96, 1),
            ),
          ),
        ],
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int) {
          setState(() {
            _selectedIndex = int;
          });
        },
      ),
    );
  }
}
