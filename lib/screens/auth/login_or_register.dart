import 'package:flutter/material.dart';
import 'package:meds/screens/auth/login_screen.dart';
import 'package:meds/screens/auth/register_screen.dart';
import 'package:meds/screens/onboarding_screen.dart';

class LoginOrRegisterScreen extends StatefulWidget {
  const LoginOrRegisterScreen({super.key});

  @override
  State<LoginOrRegisterScreen> createState() => _LoginOrRegisterScreenState();
}

class _LoginOrRegisterScreenState extends State<LoginOrRegisterScreen> {
  bool showLoginScreen = true;
  bool showOnboarding = true;

  void toggleScreens() {
    if (showOnboarding) {
      setState(() {
        showOnboarding = false;
      });
    } else {
      setState(() {
        showLoginScreen = !showLoginScreen;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (showOnboarding) {
      return Onboarding(
        showSignInScreen: toggleScreens,
      );
    } else {
      if (showLoginScreen) {
        return LoginScreen(
          registerTap: toggleScreens,
        );
      } else {
        return RegisterScreen(
          loginTap: toggleScreens,
        );
      }
    }
  }
}
