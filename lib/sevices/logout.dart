// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meds/mainpage.dart';

Future signOut(BuildContext context) async {
  await FirebaseAuth.instance.signOut();

  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const MainPage(),
      ),
      (route) => false);
}
