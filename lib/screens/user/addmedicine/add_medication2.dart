// ignore_for_file: must_be_immutable, library_private_types_in_public_api, non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meds/model/category_model.dart';
import 'package:meds/components/controller_data.dart';
import 'package:meds/components/text_field.dart';
import 'package:meds/screens/user/addmedicine/add_medication3.dart';

class AddMedication2 extends StatefulWidget {
  List<CategoryModel> categories = [];

  AddMedication2({super.key});

  void _getInitialInfo() {
    categories = CategoryModel.getCategories();
  }

  @override
  _AddMedication2State createState() => _AddMedication2State();
}

bool isPillCountRequired = false;

class _AddMedication2State extends State<AddMedication2> {
  final user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _medicationDosageController =
      MedicationControllerData().medicationDosageController;
  final TextEditingController _medicationCountController =
      MedicationControllerData().medicationCountController;
  final TextEditingController _medicationNoteController =
      MedicationControllerData().medicationNoteController;

  late FocusNode focusNode_dosage;
  late FocusNode focusNode_totalPill;
  late FocusNode focusNode_note;

  @override
  void initState() {
    super.initState();
    widget._getInitialInfo();
    focusNode_dosage = FocusNode();
    focusNode_note = FocusNode();
    focusNode_totalPill = FocusNode();
  }

  void goToNextPage() {
    if (_medicationDosageController.text.isEmpty) {
      focusNode_dosage.requestFocus();
    } else {
      if (_medicationCountController.text.isNotEmpty &&
          int.parse(_medicationCountController.text) <
              int.parse(_medicationDosageController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color.fromARGB(255, 7, 83, 96),
            behavior: SnackBarBehavior.floating,
            content: Text(
              'Available pill count should be greater than the dosage',
            ),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddMedication3(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    widget._getInitialInfo();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Medication',
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
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: ListView(
            children: [
              const Text(
                'Dosage Per Intake',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              //dosage
              Text_Field(
                  label: 'Count',
                  hint: '1',
                  isPassword: false,
                  keyboard: TextInputType.number,
                  txtEditController: _medicationDosageController,
                  focusNode: focusNode_dosage),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.all(10),
                width: double.infinity,
                height: 2,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 20),
              //total pill count
              const Row(
                children: [
                  Text(
                    'Available Pill Count ',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '(Optional)',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text_Field(
                label: 'Total Pill Count',
                hint: '30',
                isPassword: false,
                keyboard: TextInputType.number,
                txtEditController: _medicationCountController,
                focusNode: focusNode_totalPill,
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.all(10),
                width: double.infinity,
                height: 2,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 20),
              //user note
              const Row(
                children: [
                  Text(
                    'Medication Note ',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '(Optional)',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text_Field(
                label: 'Medication Note ',
                hint: 'Using for illness',
                isPassword: false,
                keyboard: TextInputType.name,
                txtEditController: _medicationNoteController,
                focusNode: focusNode_note,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.42,
                height: 55,
                child: FilledButton(
                  onPressed: goToNextPage,
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
                    'Next',
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
