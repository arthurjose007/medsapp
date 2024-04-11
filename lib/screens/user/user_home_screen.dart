// ignore_for_file: avoid_print

import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timeline_calendar/timeline/flutter_timeline_calendar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meds/components/medcard.dart';
import 'package:meds/screens/account/account_settings.dart';
import 'package:meds/screens/user/addmedicine/add_medication1.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  //date listener
  final ValueNotifier<CalendarDateTime> _selectedDate =
      ValueNotifier<CalendarDateTime>(
    CalendarDateTime(
        year: DateTime.now().year,
        month: DateTime.now().month,
        day: DateTime.now().day),
  );

  //current user
  User? currentUser = FirebaseAuth.instance.currentUser;

  //document IDs of medicatiions
  late List<String> docIds = [];
  late List<String> dateIds = [];
  late List<String> timeIds = [];
  late List<String> dates = [];
  late List<String> times = [];

  //alarm list
  late List<AlarmSettings> alarms;

  static StreamSubscription? subscription;

  void refresh() {
    setState(() {
      _selectedDate.value;
    });
  }

  Future setAlarms() async {
    print('Running set alarms...');
    docIds = [];
    dates = [];
    times = [];

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.uid)
          .collection('Medications')
          .get();

      for (final document in snapshot.docs) {
        print('Medications Doc ID: ${document.reference.id}');

        final snapshotDates = await FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser!.uid)
            .collection('Medications')
            .doc(document.reference.id)
            .collection('Logs')
            .get();

        for (final document1 in snapshotDates.docs) {
          print('DateTime: ${document1.reference.id}');
          List<String> dateTimeStr = document1.reference.id.split(' ');
          print("Date time [0] ${dateTimeStr[0]}");
          dates.add(dateTimeStr[0]);

          Map<String, dynamic> medData = document.data();
          List<String> date = dateTimeStr[0].split('-');

          int year = int.parse(date[0]);
          int month = int.parse(date[1]);
          int day = int.parse(date[2]);

          List<String> time = dateTimeStr[1].toString().split(':');

          int hours = int.parse(time[0]);
          int mins = int.parse(time[1]);

          DateTime dateTime = DateTime(
            year,
            month,
            day,
            hours,
            mins,
            0,
            0,
          );

          print("My date$dateTime");
          Duration difference = dateTime.difference(DateTime.now());
          print('Difference: $difference');
          // int id = DateTime.now().millisecondsSinceEpoch % 100000;
          int id = dateTime.hashCode;
          print('Alaram ID: $id');
          if (!difference.isNegative) {
            final alarmSettings = AlarmSettings(
              id: id,
              dateTime: dateTime,
              assetAudioPath: 'assets/audio/marimba.mp3',
              // volumeMax: false,
              vibrate: false,
              notificationTitle: 'Medication Reminder',
              notificationBody:
                  'Take ${medData['medcount']} ${medData['category']}(s) of ${medData['medname']}',
              // enableNotificationOnKill: false,
              // stopOnNotificationOpen: false,
            );
            Alarm.set(alarmSettings: alarmSettings);
            print('Alarm setted!');
          }
        }
      }
    } on FirebaseException catch (e) {
      print('ERROR: ${e.code}');
    }

    print('Date array: $dates');
    print('Times array: $times');
    // print(alarms);
  }

  Future getDocIDs() async {
    docIds = [];
    dateIds = [];
    timeIds = [];

    final snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('Medications')
        .get();

    for (final document in snapshot.docs) {
      // print('Medications Doc ID: ${document.reference.id}');

      final snapshot1 = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.uid)
          .collection('Medications')
          .doc(document.reference.id)
          .collection('Logs')
          .get();

      for (final document1 in snapshot1.docs) {
        print('Date ID: ${document1.reference.id}');
        List<String> dateTime = document1.reference.id.split(' ');
        //check selected date from timeline calendar
        if (dateTime[0] == _selectedDate.value.toString()) {
          docIds.add(document.reference.id);
          dateIds.add(dateTime[0]);
          timeIds.add(dateTime[1]);
          // print('${document.reference.id} added for list on ${_selectedDate.value.toString()}');
          // print('Array LENGTH: ${docIds.length}');
        } else {
          // print('Not added to list');
        }
      }
    }
  }

  @override
  initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    setAlarms();
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //floating action button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddMedication1(),
            ),
          );
        },
        backgroundColor: const Color.fromARGB(255, 14, 149, 173),
        foregroundColor: Theme.of(context).colorScheme.background,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          //app logo and user icon
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            alignment: Alignment.topCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //logo and name
                const Column(
                  children: [
                    //logo
                    Image(
                      image: AssetImage('assets/icon_small.png'),
                      height: 50,
                    ),
                  ],
                ),

                // user icon widget
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const SettingsPageUI();
                            },
                          ),
                        );
                      },
                      child: (currentUser?.photoURL?.isEmpty ?? true)
                          ? CircleAvatar(
                              radius: 20,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.surface,
                              child: const Icon(Icons.person_outlined),
                            )
                          : CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  NetworkImage(currentUser!.photoURL!),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // calendar, selected date and reminder text widget
          Column(
            children: [
              Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: TimelineCalendar(
                    calendarType: CalendarType.GREGORIAN,
                    calendarLanguage: "en",
                    calendarOptions: CalendarOptions(
                      viewType: ViewType.DAILY,
                      toggleViewType: true,
                      headerMonthElevation: 0,
                      headerMonthBackColor:
                          const Color.fromARGB(255, 241, 250, 251),
                    ),
                    dayOptions: DayOptions(
                      compactMode: true,
                      dayFontSize: 15,
                      weekDaySelectedColor:
                          Theme.of(context).colorScheme.primary,
                      selectedBackgroundColor:
                          Theme.of(context).colorScheme.primary,
                      disableDaysBeforeNow: false,
                      unselectedBackgroundColor: Colors.white,
                    ),
                    headerOptions: HeaderOptions(
                      weekDayStringType: WeekDayStringTypes.SHORT,
                      monthStringType: MonthStringTypes.FULL,
                      backgroundColor: const Color.fromARGB(255, 241, 250, 251),
                      headerTextColor: Colors.black,
                    ),
                    onChangeDateTime: (date) {
                      setState(() {
                        _selectedDate.value = date;
                      });
                    },
                    onDateTimeReset: (p0) {
                      setState(() {
                        _selectedDate.value = CalendarDateTime(
                            year: DateTime.now().year,
                            month: DateTime.now().month,
                            day: DateTime.now().day);
                      });
                    },
                    dateTime: _selectedDate.value,
                  ),
                ),
              ),

              //date text and reminder
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //title
                    Text(
                      _selectedDate.value.toString().substring(0, 10),
                      style: GoogleFonts.roboto(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),

          //timeline widget
          Expanded(
            child: GlowingOverscrollIndicator(
              axisDirection: AxisDirection.down,
              color: const Color.fromARGB(255, 7, 83, 96),
              child: SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    children: [
                      FutureBuilder(
                        future: getDocIDs(),
                        builder: (context, snapshot) {
                          // print('${snapshot.hasData}');
                          print(snapshot);
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            print('Building cards');
                            print('DocID Array Length: ${docIds.length}');
                            if (docIds.isEmpty) {
                              print('No reminders');
                              //no reminders widget
                              return Column(
                                children: [
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.asset(
                                      'assets/icons/no_reminders.gif',
                                      color: const Color.fromARGB(
                                          255, 241, 250, 251),
                                      colorBlendMode: BlendMode.darken,
                                      height: 100.0,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'Your medication reminders\n will be displayed here.',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  FilledButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AddMedication1(),
                                        ),
                                      );
                                    },
                                    style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Color.fromARGB(255, 217, 237, 239)),
                                      foregroundColor: MaterialStatePropertyAll(
                                          Color.fromRGBO(7, 82, 96, 1)),
                                      shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      'Add a Medication',
                                      style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return ListView.builder(
                                itemCount: docIds.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return ValueListenableBuilder<
                                          CalendarDateTime>(
                                      valueListenable: _selectedDate,
                                      builder: (context, value, child) {
                                        print(docIds[index]);
                                        print("called medcard");
                                        return MedCard(
                                          documentID: docIds[index],
                                          dateID: dateIds[index],
                                          timeID: timeIds[index],
                                          index: index,
                                          size: docIds.length,
                                          selectedDate: value,
                                          refreshCallback: refresh,
                                        );
                                      });
                                },
                              );
                            }
                          } else {
                            return const LinearProgressIndicator();
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
