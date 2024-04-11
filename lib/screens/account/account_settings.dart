// ignore_for_file: non_constant_identifier_names, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meds/screens/account/help_center.dart';
import 'package:meds/screens/account/orders_screen.dart';
import 'package:meds/screens/termsNconditions.dart';
import 'package:meds/screens/account/user_profile.dart';
import 'package:meds/sevices/logout.dart';
import 'package:settings_ui/settings_ui.dart';

// import 'package:settings/usersettings.dart';

class SettingsPageUI extends StatefulWidget {
  const SettingsPageUI({super.key});

  @override
  _SettingPageUIState createState() => _SettingPageUIState();
}

class _SettingPageUIState extends State<SettingsPageUI> {
  final currentUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 22,
          ),
        ),
        elevation: 5,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return SettingsList(
              lightTheme: const SettingsThemeData(
                settingsListBackground: Color.fromRGBO(241, 250, 251, 1),
              ),
              sections: [
                SettingsSection(
                  title: Text(
                    'Account Settings',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  tiles: <SettingsTile>[
                    SettingsTile.navigation(
                      leading: const Icon(Icons.account_circle_outlined),
                      title: const Text('Edit Profile'),
                      onPressed: (context) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UserProfile()),
                        );
                      },
                    ),
                  ],
                ),
                SettingsSection(
                  title: Text(
                    'Other',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  tiles: <SettingsTile>[
                    SettingsTile.navigation(
                        leading: const Icon(Icons.help_outline_outlined),
                        title: const Text('Help Center'),
                        onPressed: (context) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HelpCenter()),
                          );
                        }),
                    SettingsTile.navigation(
                      leading: const Icon(Icons.description_outlined),
                      title: const Text('Terms and Conditions'),
                      onPressed: (context) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TermsAndConditions(),
                          ),
                        );
                      },
                    ),
                    if (userData['userType'] == 0)
                      SettingsTile(
                        leading: const Icon(Icons.shopping_cart_outlined),
                        title: const Text('Your orders'),
                        onPressed: (context) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UserOrdersScreen(),
                            ),
                          );
                        },
                      ),
                  ],
                ),
                SettingsSection(
                  title: const Text(''),
                  tiles: <SettingsTile>[
                    SettingsTile.navigation(
                      leading: const Icon(Icons.login_rounded),
                      // title: const Text('Sign Out'),
                      title: const Text('Sign Out'),
                      onPressed: (context) {
                        signOut(context);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
