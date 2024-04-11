import 'package:flutter/material.dart';
import 'package:meds/screens/chat/chat_main.dart';

class DoctorMainScreen extends StatelessWidget {
  const DoctorMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(),
      ),
      body: const SafeArea(
        child: ChatMain(),
      ),
    );
  }
}
