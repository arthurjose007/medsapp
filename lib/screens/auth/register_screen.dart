// ignore_for_file: non_constant_identifier_names, unused_field, prefer_final_fields, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meds/components/text_field.dart';
import 'package:toggle_switch/toggle_switch.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, required this.loginTap});
  final Function()? loginTap;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

enum Genders { male, female, other }

class _RegisterScreenState extends State<RegisterScreen> {
  //controllers - keep track what types
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final cnfPasswordController = TextEditingController();
  final certificateIdController = TextEditingController();
  final storeIdController = TextEditingController();

  late FocusNode focusNode_email;
  late FocusNode focusNode_pwd;
  late FocusNode focusNode_pwdConfirm;
  late FocusNode focusNode_name;
  late FocusNode focusNode_certId;
  late FocusNode focusNode_stoerId;

  bool _isEmail = false;
  bool _isName = false;
  bool _isPwd = false;
  bool _isPwdConfirm = false;
  bool _isCirtId = false;
  bool _isStoreId = false;

  bool isLoading = false;
  bool isLoadingGoogle = false;

  bool _isError = false;
  bool _isSuccess = false;

  int selectedRoleIndex = 0;

  //firebase error message
  String errorMsg = '';

  bool isName(String input) => RegExp(r'^[a-zA-Z]').hasMatch(input);
  bool isEmail(String input) => RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(input);
  bool isPassword(String input) =>
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
          .hasMatch(input);

  @override
  void initState() {
    focusNode_email = FocusNode();
    focusNode_pwd = FocusNode();
    focusNode_pwdConfirm = FocusNode();
    focusNode_name = FocusNode();
    focusNode_certId = FocusNode();
    focusNode_stoerId = FocusNode();
    super.initState();
  }

  bool isPasswordConfirmed() {
    if (passwordController.text.trim() == cnfPasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  Future signUp() async {
    //check empty fields
    if (nameController.text.isEmpty) {
      focusNode_name.requestFocus();
    } else if (certificateIdController.text.isEmpty && selectedRoleIndex == 1) {
      focusNode_certId.requestFocus();
    } else if (storeIdController.text.isEmpty && selectedRoleIndex == 2) {
      focusNode_stoerId.requestFocus();
    } else if (emailController.text.isEmpty) {
      focusNode_email.requestFocus();
    } else if (passwordController.text.isEmpty) {
      focusNode_pwd.requestFocus();
    } else if (cnfPasswordController.text.isEmpty) {
      focusNode_pwdConfirm.requestFocus();
    } else {
      //check input validation (RegEx)

      if (!isName(nameController.text)) {
        //show error
        setState(() {
          _isName = true;
        });
      } else {
        //hide error
        setState(() {
          _isName = false;
        });
      }

      if (!isEmail(emailController.text)) {
        setState(() {
          _isEmail = true;
        });
      } else {
        setState(() {
          _isEmail = false;
        });
      }

      if (!isPassword(passwordController.text)) {
        setState(() {
          _isPwd = true;
        });
      } else {
        setState(() {
          _isPwd = false;
        });

        try {
          //check confirm password
          if (isPasswordConfirmed()) {
            //passwords mismatch
            setState(() {
              _isPwdConfirm = false;
            });

            setState(() {
              isLoading = true;
            });

            //create user

            await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            )
                .then((value) {
              FirebaseFirestore.instance
                  .collection('Users')
                  .doc(value.user!.uid)
                  .set(
                {
                  'name': nameController.text.trim(),
                  'email': emailController.text,
                  'userType': selectedRoleIndex,
                  'doctorId': certificateIdController.text,
                  'storeId': storeIdController.text,
                  'dob': null,
                  'gender': null,
                  'pic': null,
                  'address': null,
                  'mobile': null,
                  'approved': selectedRoleIndex != 0 ? false : true,
                },
              );
              if (selectedRoleIndex != 0) {
                FirebaseFirestore.instance
                    .collection("admin_request_database")
                    .add({
                  "name": nameController.text.trim(),
                  "email": emailController.text.trim(),
                  "Id": value.user!.uid,
                  "approved": false,
                });
              }
            });

            //account created successfully
            setState(() {
              _isError = false;
              _isSuccess = true;
              isLoading = false;
            });
          } else {
            //passwords mismatch
            setState(() {
              _isPwdConfirm = true;
            });
          }
        } on FirebaseAuthException catch (e) {
          //firebase error
          setState(() {
            _isError = true;
            _isSuccess = false;
            isLoading = false;
            errorMsg = getErrorMessage(e.code);
          });
        }
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    cnfPasswordController.dispose();
    certificateIdController.dispose();
    storeIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Center(
            child: GlowingOverscrollIndicator(
              axisDirection: AxisDirection.down,
              color: const Color.fromARGB(255, 7, 83, 96),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(35, 0, 35, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        //text
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Let\'s \nGet Started',
                            style: GoogleFonts.roboto(
                              fontSize: 35,
                              height: 1.0,
                              color: const Color.fromARGB(255, 16, 15, 15),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            //logo
                            const Image(
                              image: AssetImage('assets/icon_small.png'),
                              height: 50,
                            ),
                            //title
                            Text(
                              'MyMeds',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: const Color.fromRGBO(7, 82, 96, 1),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),

                    //role toggle
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: ToggleSwitch(
                        cornerRadius: 15,
                        fontSize: 18,
                        activeBgColor: [Theme.of(context).colorScheme.primary],
                        borderWidth: 5,
                        animate: true,
                        minWidth: 130,
                        animationDuration: 400,
                        initialLabelIndex: selectedRoleIndex,
                        totalSwitches: 3,
                        labels: const ['User', "Doctor", "Store"],
                        onToggle: (index) {
                          setState(() {
                            selectedRoleIndex = index!;
                          });
                        },
                      ),
                    ),

                    //name
                    Text_Field(
                      label: 'Name',
                      hint: 'FirstName LastName',
                      isPassword: false,
                      keyboard: TextInputType.text,
                      txtEditController: nameController,
                      focusNode: focusNode_name,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    //text not a valid name
                    Visibility(
                      visible: _isName,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                          child: Text(
                            'Enter a valid name',
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

                    //certificate id
                    if (selectedRoleIndex == 1)
                      Text_Field(
                        label: 'Certificate Id',
                        hint: '###############',
                        isPassword: false,
                        keyboard: TextInputType.text,
                        txtEditController: certificateIdController,
                        focusNode: focusNode_certId,
                      ),
                    if (selectedRoleIndex == 1)
                      const SizedBox(
                        height: 2,
                      ),

                    //text not a valid Id
                    if (selectedRoleIndex == 1)
                      Visibility(
                        visible: _isCirtId,
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                            child: Text(
                              'Enter a valid name',
                              style: GoogleFonts.roboto(
                                fontSize: 12,
                                color: const Color.fromRGBO(255, 16, 15, 15),
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                      ),
                    if (selectedRoleIndex == 1)
                      const SizedBox(
                        height: 5,
                      ),

                    //Store id
                    if (selectedRoleIndex == 2)
                      Text_Field(
                        label: 'Store Id',
                        hint: '###############',
                        isPassword: false,
                        keyboard: TextInputType.text,
                        txtEditController: storeIdController,
                        focusNode: focusNode_stoerId,
                      ),
                    if (selectedRoleIndex == 2)
                      const SizedBox(
                        height: 2,
                      ),

                    //text not a valid Id
                    if (selectedRoleIndex == 2)
                      Visibility(
                        visible: _isStoreId,
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                            child: Text(
                              'Enter a valid name',
                              style: GoogleFonts.roboto(
                                fontSize: 12,
                                color: const Color.fromRGBO(255, 16, 15, 15),
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                      ),
                    if (selectedRoleIndex == 2)
                      const SizedBox(
                        height: 5,
                      ),

                    //email
                    Text_Field(
                      label: 'Email',
                      hint: 'name@email.com',
                      isPassword: false,
                      keyboard: TextInputType.emailAddress,
                      txtEditController: emailController,
                      focusNode: focusNode_email,
                    ),
                    const SizedBox(
                      height: 2,
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
                            'Enter a valid email address',
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
                      txtEditController: passwordController,
                      focusNode: focusNode_pwd,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    //text not a valid password
                    Visibility(
                      visible: _isPwd,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                          child: Text(
                            'Enter a strong password',
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

                    //confirm password
                    Text_Field(
                      label: 'Confirm Password',
                      hint: 'Password',
                      isPassword: true,
                      keyboard: TextInputType.visiblePassword,
                      txtEditController: cnfPasswordController,
                      focusNode: focusNode_pwdConfirm,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    //text password mismatch
                    Visibility(
                      visible: _isPwdConfirm,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                          child: Text(
                            'Passwords do not match',
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              color: const Color.fromRGBO(255, 16, 15, 15),
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                    ),
                    //firebase error message
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
                                    color:
                                        const Color.fromRGBO(255, 16, 15, 15),
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),

                    //success message
                    Visibility(
                      visible: _isSuccess,
                      maintainSize: false,
                      maintainAnimation: true,
                      maintainState: true,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: GlowingOverscrollIndicator(
                            axisDirection: AxisDirection.right,
                            color: const Color.fromARGB(239, 0, 198, 89),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const Icon(
                                  Icons.check_circle_outline,
                                  color: Color.fromARGB(239, 0, 198, 89),
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  'Account created successfully!',
                                  style: GoogleFonts.roboto(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        const Color.fromARGB(239, 0, 198, 89),
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    //sign up button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: FilledButton(
                        onPressed: signUp,
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
                                'Sign Up',
                                style: GoogleFonts.roboto(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            : const CircularProgressIndicator(
                                color: Colors.white,
                              ),
                      ),
                    ),

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

                    //redirect to register
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: GoogleFonts.roboto(
                            fontSize: 15,
                            color: const Color.fromARGB(255, 67, 63, 63),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: widget.loginTap,
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
                            'Sign In',
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

  // firebase error messages
  String getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'email-already-in-use':
        return 'Email already used. Go to Sign In page.';
      case 'operation-not-allowed':
        return 'Operation is not allowed.';
      case 'invalid-email':
        return 'Email address is invalid.';
      case 'weak-password':
        return 'Enter a strong password.';
      case 'network-request-failed':
        return 'Network error.';
      default:
        return 'Account creation failed. Please try again';
    }
  }
}
