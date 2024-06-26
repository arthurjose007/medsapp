// ignore_for_file: non_constant_identifier_names, unused_local_variable, library_private_types_in_public_api, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meds/model/category_model.dart';
import 'package:meds/components/controller_data.dart';
import 'package:meds/screens/user/user_dashboard.dart';

class AddMedication4 extends StatefulWidget {
  List<CategoryModel> categories = CategoryModel.getCategories();

  AddMedication4({super.key});

  @override
  _AddMedication4State createState() => _AddMedication4State();
}

class _AddMedication4State extends State<AddMedication4> {
  //current user
  User? currentUser = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();

  TextEditingController medname =
      MedicationControllerData().medicationNameController;
  TextEditingController category =
      MedicationControllerData().medicationTypeController;
  TextEditingController strength =
      MedicationControllerData().medicationStrengthValueController;
  TextEditingController strength_unit =
      MedicationControllerData().medicationStrengthController;

  TextEditingController medcount =
      MedicationControllerData().medicationDosageController;
  // TextEditingController _medicationDosageController =
  //     MedicationControllerData().medicationDosageController;
  TextEditingController total_med =
      MedicationControllerData().medicationCountController;
  TextEditingController user_note =
      MedicationControllerData().medicationNoteController;

  TextEditingController times =
      MedicationControllerData().medicationTimeOfDayController;
  TextEditingController number_of_times =
      MedicationControllerData().medicationTimesController;
  TextEditingController frequency =
      MedicationControllerData().medicationFrequencyController;
  TextEditingController start_date =
      MedicationControllerData().medicationStartingDateController;
  TextEditingController end_date =
      MedicationControllerData().medicationEndingDateController;

  final TextEditingController isSpecificDays =
      MedicationControllerData().medicationFrequency_isSpecificDays_Controller;

  final TextEditingController weeekdays_List =
      MedicationControllerData().medicationFrequency_weekday_Controller;

  final TextEditingController times12H =
      MedicationControllerData().medicationTimes12HController;

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color.fromARGB(255, 7, 83, 96),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void test() {
    List<String> days = [];

    List start = start_date.text.split('-');
    DateTime startDate =
        DateTime(int.parse(start[0]), int.parse(start[1]), int.parse(start[2]));

    //if end date is empty add 3 months from start date
    end_date.text = end_date.text.isEmpty
        ? end_date.text =
            startDate.add(const Duration(days: 90)).toString().substring(0, 10)
        : end_date.text;

    List end = end_date.text.split('-');
    DateTime endDate =
        DateTime(int.parse(end[0]), int.parse(end[1]), int.parse(end[2]));

    if (isSpecificDays.text == "false") {
      switch (frequency.text) {
        case "Every Day":
          for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
            days.add(
                startDate.add(Duration(days: i)).toString().substring(0, 10));
          }
          break;
        case "Every 2 Days":
          for (int i = 0;
              i <= endDate.difference(startDate).inDays;
              i = i + 2) {
            days.add(
                startDate.add(Duration(days: i)).toString().substring(0, 10));
          }
          break;
        case "Every 3 Days":
          for (int i = 0;
              i <= endDate.difference(startDate).inDays;
              i = i + 3) {
            days.add(
                startDate.add(Duration(days: i)).toString().substring(0, 10));
          }
          break;
        case "Every 4 Days":
          for (int i = 0;
              i <= endDate.difference(startDate).inDays;
              i = i + 4) {
            days.add(
                startDate.add(Duration(days: i)).toString().substring(0, 10));
          }
          break;
        case "Every 5 Days":
          for (int i = 0;
              i <= endDate.difference(startDate).inDays;
              i = i + 5) {
            days.add(
                startDate.add(Duration(days: i)).toString().substring(0, 10));
          }
          break;
        case "Every 6 Days":
          for (int i = 0;
              i <= endDate.difference(startDate).inDays;
              i = i + 6) {
            days.add(
                startDate.add(Duration(days: i)).toString().substring(0, 10));
          }
          break;
        case "Every Week (7 Days)":
          for (int i = 0;
              i <= endDate.difference(startDate).inDays;
              i = i + 7) {
            days.add(
                startDate.add(Duration(days: i)).toString().substring(0, 10));
          }
          break;
        case "Every 2 Weeks (14 Days)":
          for (int i = 0;
              i <= endDate.difference(startDate).inDays;
              i = i + 14) {
            days.add(
                startDate.add(Duration(days: i)).toString().substring(0, 10));
          }
          break;
        case "Every 3 Weeks (21 Days)":
          for (int i = 0;
              i <= endDate.difference(startDate).inDays;
              i = i + 21) {
            days.add(
                startDate.add(Duration(days: i)).toString().substring(0, 10));
          }
          break;
        case "Every Month (30 Days)":
          for (int i = 0;
              i <= endDate.difference(startDate).inDays;
              i = i + 30) {
            days.add(
                startDate.add(Duration(days: i)).toString().substring(0, 10));
          }
          break;
        case "Every 2 Months (60 Days)":
          for (int i = 0;
              i <= endDate.difference(startDate).inDays;
              i = i + 60) {
            days.add(
                startDate.add(Duration(days: i)).toString().substring(0, 10));
          }
          break;
        case "Every 3 Month (90 Days)":
          for (int i = 0;
              i <= endDate.difference(startDate).inDays;
              i = i + 90) {
            days.add(
                startDate.add(Duration(days: i)).toString().substring(0, 10));
          }
          break;
      }
    } else {
      //spcific days logic
      List<String> weekdaysStr = weeekdays_List.text.split(', ');
      List<int> weekdays = weekdaysStr.map(int.parse).toList();
      // print(weekdays);
      for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
        for (var day in weekdays) {
          if (startDate.add(Duration(days: i)).weekday == day) {
            days.add(
                startDate.add(Duration(days: i)).toString().substring(0, 10));
          }
        }
      }
    }

    // print(days);
  }

  void addMedication() async {
    //loading circle
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Color.fromRGBO(7, 82, 96, 1),
          ),
        );
      },
    );

    try {
      final snapshot1 = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.uid)
          .collection('Medications')
          .add({});

      String newID = snapshot1.id;
      // print('Created medication ID: $newID');

      List<String> medtimesOriginal = times.text.split(', ');
      List medtimes = List.filled(24, null);

      //add time if available or null
      for (int i = 0; i < medtimes.length; i++) {
        if (medtimesOriginal.length > i) {
          medtimes[i] = medtimesOriginal[i];
        }
      }

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.uid)
          .collection('Medications')
          .doc(newID)
          .set({
        'medname': medname.text.isNotEmpty ? medname.text : null,
        'category': category.text.isNotEmpty ? category.text : null,
        'strength': strength.text.isNotEmpty ? int.parse(strength.text) : null,
        'strength_unit':
            strength_unit.text.isNotEmpty ? strength_unit.text : null,
        'medcount': int.parse(medcount.text),
        'total_med:':
            total_med.text.isNotEmpty ? int.parse(total_med.text) : null,
        'times': times12H.text,
        'frequency': frequency.text.isNotEmpty ? frequency.text : null,
        'start_date': start_date.text.isNotEmpty ? start_date.text : null,
        'end_date': end_date.text.isNotEmpty ? end_date.text : null,
        'user_note': user_note.text.isNotEmpty ? user_note.text : null,
      });

      // print('Medication added successfully');

      //adding days
      List<String> days = [];

      List start = start_date.text.split('-');
      DateTime startDate = DateTime(
          int.parse(start[0]), int.parse(start[1]), int.parse(start[2]));

      //if end date is empty add 3 months from start date
      end_date.text = end_date.text.isEmpty
          ? end_date.text = startDate
              .add(const Duration(days: 90))
              .toString()
              .substring(0, 10)
          : end_date.text;

      List end = end_date.text.split('-');
      DateTime endDate =
          DateTime(int.parse(end[0]), int.parse(end[1]), int.parse(end[2]));

      if (isSpecificDays.text == "false") {
        switch (frequency.text) {
          case "Every Day":
            for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
              days.add(
                  startDate.add(Duration(days: i)).toString().substring(0, 10));
            }
            break;
          case "Every 2 Days":
            for (int i = 0;
                i <= endDate.difference(startDate).inDays;
                i = i + 2) {
              days.add(
                  startDate.add(Duration(days: i)).toString().substring(0, 10));
            }
            break;
          case "Every 3 Days":
            for (int i = 0;
                i <= endDate.difference(startDate).inDays;
                i = i + 3) {
              days.add(
                  startDate.add(Duration(days: i)).toString().substring(0, 10));
            }
            break;
          case "Every 4 Days":
            for (int i = 0;
                i <= endDate.difference(startDate).inDays;
                i = i + 4) {
              days.add(
                  startDate.add(Duration(days: i)).toString().substring(0, 10));
            }
            break;
          case "Every 5 Days":
            for (int i = 0;
                i <= endDate.difference(startDate).inDays;
                i = i + 5) {
              days.add(
                  startDate.add(Duration(days: i)).toString().substring(0, 10));
            }
            break;
          case "Every 6 Days":
            for (int i = 0;
                i <= endDate.difference(startDate).inDays;
                i = i + 6) {
              days.add(
                  startDate.add(Duration(days: i)).toString().substring(0, 10));
            }
            break;
          case "Every Week (7 Days)":
            for (int i = 0;
                i <= endDate.difference(startDate).inDays;
                i = i + 7) {
              days.add(
                  startDate.add(Duration(days: i)).toString().substring(0, 10));
            }
            break;
          case "Every 2 Weeks (14 Days)":
            for (int i = 0;
                i <= endDate.difference(startDate).inDays;
                i = i + 14) {
              days.add(
                  startDate.add(Duration(days: i)).toString().substring(0, 10));
            }
            break;
          case "Every 3 Weeks (21 Days)":
            for (int i = 0;
                i <= endDate.difference(startDate).inDays;
                i = i + 21) {
              days.add(
                  startDate.add(Duration(days: i)).toString().substring(0, 10));
            }
            break;
          case "Every Month (30 Days)":
            for (int i = 0;
                i <= endDate.difference(startDate).inDays;
                i = i + 30) {
              days.add(
                  startDate.add(Duration(days: i)).toString().substring(0, 10));
            }
            break;
          case "Every 2 Months (60 Days)":
            for (int i = 0;
                i <= endDate.difference(startDate).inDays;
                i = i + 60) {
              days.add(
                  startDate.add(Duration(days: i)).toString().substring(0, 10));
            }
            break;
          case "Every 3 Month (90 Days)":
            for (int i = 0;
                i <= endDate.difference(startDate).inDays;
                i = i + 90) {
              days.add(
                  startDate.add(Duration(days: i)).toString().substring(0, 10));
            }
            break;
        }
      } else {
        //spcific days logic
        List<String> weekdaysStr = weeekdays_List.text.split(', ');
        List<int> weekdays = weekdaysStr.map(int.parse).toList();
        // print(weekdays);
        for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
          for (var day in weekdays) {
            if (startDate.add(Duration(days: i)).weekday == day) {
              days.add(
                  startDate.add(Duration(days: i)).toString().substring(0, 10));
            }
          }
        }
      }

      // print(days);

      // add collection logs

      //adding days
      for (var day in days) {
        for (var time in medtimesOriginal) {
          List<String> dateStr = day.split('-');
          List<String> timeStr = time.split(':');
          DateTime dateTime = DateTime(
              int.parse(dateStr[0]),
              int.parse(dateStr[1]),
              int.parse(dateStr[2]),
              int.parse(timeStr[0]),
              int.parse(timeStr[1]));

          final snapshot2 = await FirebaseFirestore.instance
              .collection('Users')
              .doc(currentUser!.uid)
              .collection('Medications')
              .doc(newID)
              .collection('Logs')
              .doc(dateTime.toString())
              .set({
            'isTaken': false,
          });
          // print('created : $day - $time');
        }
      }
      // print('Added log dates and times');

      if (!mounted) {
        return;
      }
      //pop loading cicle
      Navigator.of(context).pop();

      //navigate to dashbaord
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const UserDashboard(),
        ),
      );
      _showSnackBar('Medication added successfully');
      MedicationControllerData().clear();
    } on FirebaseException catch (e) {
      // print('ERROR: ${e.code}');
      //pop loading cicle
      Navigator.of(context).pop();
      _showSnackBar('${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Summary',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 5,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: ListView(
            children: [
              SizedBox(
                height: 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment
                      .center, // Align children vertically in the center
                  children: [
                    Image.asset(
                      'assets/icons/heartbeat.gif',
                      height: 80,
                      fit: BoxFit.fitHeight,
                      color: const Color.fromARGB(255, 241, 250, 251),
                      colorBlendMode: BlendMode.darken,
                    ),
                    // SizedBox(width: 20),
                  ],
                ),
              ),
              Line(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'MEDICATION DETAILS',
                    style: TextStyle(
                        color: Colors.tealAccent[700],
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Line(),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.38,
                      child: const Text(
                        'Name',
                        textWidthBasis: TextWidthBasis.parent,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                    Text(
                      textAlign: TextAlign.justify,
                      medname.text,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.38,
                      child: const Text(
                        'Category',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                    Text(
                      category.text,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: (strength
                    .text.isNotEmpty), // Check if both texts are not empty
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.38,
                        child: const Text(
                          'Strength ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      Text(
                        '${strength.text} ${strength_unit.text}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 10,
              ),
              Line(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'MEDICATION INTAKE',
                    style: TextStyle(
                        color: Colors.tealAccent[700],
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Line(),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.38,
                      child: const Text(
                        'Dosage Per Intake',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                    Text(
                      medcount.text,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              //This is optional
              Visibility(
                visible: total_med.text.isNotEmpty, // Set your condition here
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.38,
                        child: const Text(
                          'Dosage Per Intake',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      Text(
                        total_med.text,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 10,
              ),
              //horizontal line
              Line(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'FREQUENCY',
                    style: TextStyle(
                        color: Colors.tealAccent[700],
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              //horizontal line
              Line(),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.38,
                      child: Text(
                        'Medication Times ${number_of_times.text} time(s) per day',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        times12H.text,
                        maxLines: 8,
                        overflow: TextOverflow.clip,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.38,
                      child: const Text(
                        'Frequency',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                    Text(
                      frequency.text,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.38,
                      child: const Text(
                        'Start Date',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                    Text(
                      start_date.text,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              //This is optional
              Visibility(
                visible:
                    end_date.text.isNotEmpty, // Check if the data is not empty
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.38,
                        child: const Text(
                          'End Date',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      Text(
                        end_date.text,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),
              //horoizontal line
              Visibility(
                visible: user_note.text.isNotEmpty,
                child: Column(
                  children: [
                    Line(),

                    //This is optional
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.38,
                            child: const Text(
                              'Medication Note ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                          Text(
                            user_note.text,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.42,
                height: 55,
                child: FilledButton(
                  onPressed: addMedication,
                  // onPressed: test,
                  style: const ButtonStyle(
                    elevation: MaterialStatePropertyAll(2),
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  child: Text(
                    'Done',
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget Line() {
  return Container(
    margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
    width: double.infinity,
    height: 2,
    color: Colors.grey.shade300,
  );
}
