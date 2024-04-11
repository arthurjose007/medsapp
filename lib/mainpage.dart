// ignore_for_file: must_be_immutable, avoid_print, dead_code

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meds/screens/auth/email_verify.dart';
import 'package:meds/screens/auth/login_or_register.dart';
import 'package:meds/screens/auth/pending_screen.dart';
import 'package:meds/screens/doctor/doctor_mainscreen.dart';
import 'package:meds/screens/store/store_mainscreen.dart';
import 'package:meds/screens/user/user_dashboard.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {
          //if user logged in show dashbaord else go to authentication page
          if (snapshot.hasData) {
            if (FirebaseAuth.instance.currentUser!.emailVerified || true) {
              String? userId = FirebaseAuth.instance.currentUser!.uid;

              var userFirestore = FirebaseFirestore.instance
                  .collection("Users")
                  .doc(userId)
                  .snapshots();

              return StreamBuilder(
                stream: userFirestore,
                builder: (context, usnapshot) {
                  if (usnapshot.hasData) {
                    String? userType = usnapshot.data!["userType"].toString();
                    // print(userType);
                    if (usnapshot.data!['approved']) {
                      if (userType == "0") {
                        return const UserDashboard();
                      } else if (userType == "1") {
                        return const DoctorMainScreen();
                      } else {
                        return const StoreMainScreen();
                      }
                    } else {
                      return const PendingScreen();
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              );
            } else {
              //email verification
              return const EmailVerificationScreen();
            }
            // return Dashboard();
          } else {
            //auth page
            return const LoginOrRegisterScreen();
          }
        },
      ),
    );
  }
}
