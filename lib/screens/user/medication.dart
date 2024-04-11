// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meds/components/medcard2.dart';
import 'package:meds/screens/account/account_settings.dart';
import 'package:meds/screens/user/addmedicine/add_medication1.dart';

class Mediaction extends StatefulWidget {
  const Mediaction({super.key});

  @override
  State<Mediaction> createState() => _MediactionState();
}

class _MediactionState extends State<Mediaction> {
  bool isFABvisible = true;

  //current user
  User? currentUser = FirebaseAuth.instance.currentUser;

  //document IDs of medicatiions
  late List<String> docIds = [];
  late List<String> dateIds = [];
  late List<String> timeIds = [];

  returnFAB() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddMedication1(),
          ),
        );
      },
      backgroundColor: const Color.fromARGB(255, 146, 191, 199),
      child: const Icon(Icons.add),
    );
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
      print('Medications Doc ID: ${document.reference.id}');
      docIds.add(document.reference.id);
    }
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
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
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
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //medication gif
              Image.asset(
                height: MediaQuery.of(context).size.height * 0.20,
                'assets/images/medication.gif',
                color: const Color.fromARGB(255, 241, 250, 251),
                colorBlendMode: BlendMode.darken,
              ),
            ],
          ),
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
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            // print('Building cards');
                            // print('DocID Array Length: ${docIds.length}');
                            if (docIds.isEmpty) {
                              // print('No reminders');
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
                                    'Your medications\n will be displayed here.',
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
                                  return MedCard2(
                                    medID: docIds[index],
                                    refreshCallback: () {
                                      setState(() {});
                                    },
                                  );
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
