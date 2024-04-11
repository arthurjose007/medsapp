// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:meds/screens/account/account_settings.dart';
import 'package:meds/screens/user/alarm/alarm_settings.dart';
import 'package:meds/screens/user/more/bmi.dart';
import 'package:meds/screens/user/more/emergency.dart';

class More extends StatefulWidget {
  const More({super.key});

  @override
  State<More> createState() => _SettingsState();
}

class _SettingsState extends State<More> {
  Position? _currentPosition;
  //current user
  User? currentUser = FirebaseAuth.instance.currentUser;

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled, show a dialog to enable them.
        _showLocationServiceAlertDialog();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // The user has denied access to location permissions.

          return;
        }
      }

      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        setState(() {
          _currentPosition = position;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  // Method to show the dialog to enable location services.
  void _showLocationServiceAlertDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enable Location Services'),
          content:
              const Text('Please enable location services to use this app.'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                bool serviceEnabled = await Geolocator.openLocationSettings();
                if (serviceEnabled) {
                  // Location services are now enabled, try getting the location again.
                  await _getCurrentLocation();
                }
              },
              child: const Text('Enable'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // mainAxisSize: MainAxisSize.max,
            children: [
              //app logo and user icon
              Container(
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
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                  image: const AssetImage('assets/icons/more.gif'),
                  height: MediaQuery.of(context).size.height * 0.25,
                  // width: MediaQuery.of(context).size.width * 0.6,
                  color: const Color.fromARGB(255, 241, 250, 251),
                  colorBlendMode: BlendMode.darken,
                ),
              ),
              //1st ROW
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.12,
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: FilledButton(
                          onPressed: () async {
                            await _getCurrentLocation();
                            if (_currentPosition != null) {
                              MapsLauncher.launchQuery('Nearby Hospitals');
                            }
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
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Icon(
                                Icons.location_on_outlined,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Nearby Hospitals',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  //2nd ROW

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.12,
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: FilledButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BMI(),
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
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Icon(
                                Icons.health_and_safety_outlined,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Check your BMI',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.12,
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: FilledButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const AlarmSettingsPage();
                                },
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
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Icon(
                                Icons.alarm_rounded,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Upcoming Alarms',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //3rd row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.12,
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: FilledButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Emergency(),
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
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Icon(
                                Icons.call_outlined,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Emergency Calls',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
