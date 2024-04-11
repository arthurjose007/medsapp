// ignore_for_file: non_constant_identifier_names, prefer_final_fields, dead_code, unreachable_switch_case, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meds/components/text_field.dart';
import 'package:meds/screens/auth/password_reset.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.registerTap,
  });
  final Function()? registerTap;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //controllers - keep track what types
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late FocusNode focusNode_email;
  late FocusNode focusNode_pwd;

  bool isLoading = false;

  bool _isEmail = false;
  bool _isError = false;
  String errorMsg = '';

  bool isName(String input) => RegExp('[a-zA-Z]').hasMatch(input);
  bool isEmail(String input) => RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(input);
  bool isPhone(String input) =>
      RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$')
          .hasMatch(input);

  @override
  void initState() {
    super.initState();
    focusNode_email = FocusNode();
    focusNode_pwd = FocusNode();
  }

  Future signIn() async {
    if (_emailController.text.isEmpty) {
      focusNode_email.requestFocus();
    } else if (_passwordController.text.isEmpty) {
      focusNode_pwd.requestFocus();
    } else {
      if (!isEmail(_emailController.text)) {
        setState(() {
          _isEmail = true;
        });
      } else {
        setState(() {
          _isEmail = false;
        });
        try {
          setState(() {
            isLoading = true;
          });

          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
        } on FirebaseAuthException catch (e) {
          print(e.code);
          setState(() {
            isLoading = false;
          });

          setState(() {
            _isError = true;
            errorMsg = getErrorMessage(e.code);
          });
        }
      }
    }
    // if (mounted) {
    setState(() {
      isLoading = false;
    });
    // }
  }

  // for memory mgt
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    focusNode_email.dispose();
    focusNode_pwd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Color.fromRGBO(7, 82, 96, 1),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Center(
            child: GlowingOverscrollIndicator(
              axisDirection: AxisDirection.down,
              color: const Color.fromRGBO(7, 82, 96, 1),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(35, 0, 35, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //logo
                    const Image(
                      image: AssetImage('assets/icon_small.png'),
                      height: 80,
                    ),
                    //app name
                    Text(
                      'MyMeds',
                      style: GoogleFonts.poppins(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromRGBO(7, 82, 96, 1),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    //text
                    Text(
                      'Welcome back!',
                      style: GoogleFonts.roboto(
                        fontSize: 35,
                        color: const Color.fromARGB(255, 16, 15, 15),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    //FORM
                    FormUI(),

                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      'or',
                      style: GoogleFonts.roboto(
                        fontSize: 15,
                        color: const Color.fromARGB(255, 67, 63, 63),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    //link to sign up
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //text
                        Text(
                          'Don\'t have an account? ',
                          style: GoogleFonts.roboto(
                            fontSize: 15,
                            color: const Color.fromARGB(255, 67, 63, 63),
                          ),
                        ),
                        //sign up button
                        ElevatedButton(
                          onPressed: widget.registerTap,
                          style: ButtonStyle(
                            elevation: const MaterialStatePropertyAll(0),
                            backgroundColor: const MaterialStatePropertyAll(
                              Colors.transparent,
                            ),
                            padding: MaterialStateProperty.all(EdgeInsets.zero),
                            shape: const MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          child: Text(
                            'Sign Up',
                            style: GoogleFonts.roboto(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              // color: const Color.fromARGB(255, 7, 82, 96),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget FormUI() {
    return Column(
      children: [
        //email
        Text_Field(
          label: 'Email',
          hint: 'name@email.com',
          isPassword: false,
          keyboard: TextInputType.emailAddress,
          txtEditController: _emailController,
          focusNode: focusNode_email,
        ),
        const SizedBox(
          height: 5,
        ),
        //text not a valid email
        Visibility(
          visible: _isEmail,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
              child: Text(
                'Enter valid email address',
                style: GoogleFonts.roboto(
                  fontSize: 12,
                  color: const Color.fromRGBO(255, 16, 15, 15),
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        //password
        Text_Field(
          label: 'Password',
          hint: 'Password',
          isPassword: true,
          keyboard: TextInputType.visiblePassword,
          txtEditController: _passwordController,
          focusNode: focusNode_pwd,
        ),
        //forgot password
        Visibility(
          visible: _isError,
          maintainSize: false,
          maintainAnimation: true,
          maintainState: true,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: GlowingOverscrollIndicator(
                axisDirection: AxisDirection.right,
                color: const Color.fromRGBO(255, 16, 15, 15),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: Color.fromRGBO(255, 16, 15, 15),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      errorMsg,
                      style: GoogleFonts.roboto(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromRGBO(255, 16, 15, 15),
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        //forgot pwd button
        Row(
          children: [
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  //password reset screen
                  MaterialPageRoute(
                    builder: (context) {
                      return const PasswordReset();
                    },
                  ),
                );
              },
              style: ButtonStyle(
                elevation: const MaterialStatePropertyAll(0),
                backgroundColor: const MaterialStatePropertyAll(
                  Colors.transparent,
                ),
                padding: MaterialStateProperty.all(
                  const EdgeInsets.fromLTRB(8, 0, 8, 0),
                ),
                shape: const MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
              ),
              child: Text(
                'Forgot password?',
                style: GoogleFonts.roboto(
                  fontSize: 15,
                  // color: const Color.fromARGB(255, 7, 82, 96),
                ),
              ),
            ),
          ],
        ),

        //sign in button
        SizedBox(
          width: double.infinity,
          height: 55,
          child: FilledButton(
            onPressed: signIn,
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
            child: !isLoading
                ? Text(
                    'Sign In',
                    style: GoogleFonts.roboto(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : const CircularProgressIndicator(color: Colors.white),
          ),
        ),
      ],
    );
  }

  String getErrorMessage(String errorCode) {
    switch (errorCode) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        return "Email already used. Go to login page.";
        break;
      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        return "Incorrect email or password.";
        break;
      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        return "No user found with this email.";
        break;
      case "ERROR_USER_DISABLED":
      case "user-disabled":
        return "User disabled.";
        break;
      case "ERROR_TOO_MANY_REQUESTS":
      case "operation-not-allowed":
        return "Too many requests to log into this account.";
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
      case "operation-not-allowed":
        return "Server error, please try again later.";
        break;
      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        return "Incorrect email or password.E";
        break;
      case 'network-request-failed':
        return 'Network error.';
      default:
        return "Sign in failed. Please try again.";
        break;
    }
  }
}
