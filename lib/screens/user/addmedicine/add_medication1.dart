// ignore_for_file: must_be_immutable, avoid_print, library_private_types_in_public_api, non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meds/model/category_model.dart';
import 'package:meds/components/controller_data.dart';
import 'package:meds/components/text_field.dart';
import 'package:meds/screens/user/addmedicine/add_medication2.dart';

class AddMedication1 extends StatefulWidget {
  List<CategoryModel> categories = CategoryModel.getCategories();

  AddMedication1({super.key});

  @override
  _AddMedication1State createState() => _AddMedication1State();
}

class _AddMedication1State extends State<AddMedication1> {
  final user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _medicationNameController =
      MedicationControllerData().medicationNameController;
  final TextEditingController _medicationTypeController =
      MedicationControllerData().medicationTypeController;
  final TextEditingController _medicationStrengthValueController =
      MedicationControllerData().medicationStrengthValueController;
  final TextEditingController _medicationStrengthController =
      MedicationControllerData().medicationStrengthController;

  late FocusNode focusNode_medName;
  late FocusNode focusNode_medStrengthValue;

  int _selectedCategoryIndex = -1;

  @override
  void initState() {
    super.initState();
    focusNode_medName = FocusNode();
    focusNode_medStrengthValue = FocusNode();
  }

  void goToNextPage() {
    if (_medicationNameController.text.isEmpty) {
      focusNode_medName.requestFocus();
    } else if (_selectedCategoryIndex < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color.fromARGB(255, 7, 83, 96),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
          content: Text(
            'Please select medication category',
          ),
        ),
      );
    } else {
      if (_medicationStrengthValueController.text.isNotEmpty &&
          _medicationStrengthController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color.fromARGB(255, 7, 83, 96),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
            content: Text(
              'Please select strength type',
            ),
          ),
        );
      } else if (_medicationStrengthValueController.text.isEmpty &&
          _medicationStrengthController.text.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color.fromARGB(255, 7, 83, 96),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
            content: Text(
              'Please select strength type',
            ),
          ),
        );
      } else {
        //print all controller values
        // print(_medicationNameController.text);
        // print(_medicationTypeController.text);
        // print(_medicationStrengthValueController.text +
        //     _medicationStrengthController.text);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddMedication2(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(
                height: 20,
              ),
              //medication name
              const Text(
                'Medication Name',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 20,
              ),
              Text_Field(
                label: 'Medication Name',
                hint: 'Vitamin C',
                isPassword: false,
                keyboard: TextInputType.text,
                txtEditController: _medicationNameController,
                focusNode: focusNode_medName,
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.all(10),
                width: double.infinity,
                height: 2,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 20),
              const Text(
                'Category',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  itemCount: widget.categories.length,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 0, right: 20),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          right: 16), // Adjust the right padding for space
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            if (_selectedCategoryIndex == index) {
                              // If the same category is tapped again, deselect it
                              widget.categories[_selectedCategoryIndex]
                                      .boxColor =
                                  const Color.fromARGB(255, 158, 158, 158);
                              widget.categories[_selectedCategoryIndex]
                                  .isSelected = false;
                              _selectedCategoryIndex = -1;
                              _medicationTypeController.text = '';
                            } else {
                              // Deselect the previously selected category
                              if (_selectedCategoryIndex != -1) {
                                widget.categories[_selectedCategoryIndex]
                                        .boxColor =
                                    const Color.fromARGB(255, 158, 158, 158);
                                widget.categories[_selectedCategoryIndex]
                                    .isSelected = false;
                              }

                              // Select the tapped category
                              _selectedCategoryIndex = index;
                              _medicationTypeController.text =
                                  widget.categories[index].name;
                              widget.categories[index].boxColor =
                                  const Color.fromARGB(255, 7, 82, 96)
                                      .withOpacity(0.3);
                              widget.categories[index].isSelected = true;
                            }
                            print(_medicationTypeController.text);
                          });
                        },
                        child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                            color: widget.categories[index].boxColor
                                .withOpacity(0.3),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    widget.categories[index].iconPath,
                                  ),
                                ),
                              ),
                              Text(
                                widget.categories[index].name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.all(10),
                width: double.infinity,
                height: 2,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text(
                    'Strength ',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  const Text(
                    '(Optional)',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _medicationStrengthController.clear();
                      _medicationStrengthValueController.clear();
                    },
                    child: const Text('Clear'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _medicationStrengthValueController,
                      focusNode: focusNode_medStrengthValue,
                      keyboardType: TextInputType.number,
                      cursorColor: const Color.fromARGB(255, 7, 82, 96),
                      style: const TextStyle(
                        height: 2,
                      ),
                      decoration: InputDecoration(
                        hintText: '100',
                        labelText: 'Strength Value',
                        labelStyle: GoogleFonts.roboto(
                          color: const Color.fromARGB(255, 16, 15, 15),
                        ),
                        filled: true,
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 7, 82, 96),
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  //strength type
                  DropdownMenu(
                    controller: _medicationStrengthController,
                    textStyle: GoogleFonts.roboto(
                      height: 2,
                      color: const Color.fromARGB(255, 16, 15, 15),
                    ),
                    width: MediaQuery.of(context).size.width * 0.43,
                    menuStyle: const MenuStyle(
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    inputDecorationTheme: const InputDecorationTheme(
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            20,
                          ),
                        ),
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 7, 82, 96),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            20,
                          ),
                        ),
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                    dropdownMenuEntries: const [
                      DropdownMenuEntry(label: 'mg', value: 'mg'),
                      DropdownMenuEntry(label: 'mcg', value: 'mcg'),
                      DropdownMenuEntry(label: 'g', value: 'g'),
                      DropdownMenuEntry(label: 'ml', value: 'ml'),
                      DropdownMenuEntry(label: 'tsp', value: 'tsp'),
                      DropdownMenuEntry(label: 'tbsp', value: 'tbsp'),
                      DropdownMenuEntry(label: '%', value: '%'),
                      DropdownMenuEntry(label: 'cup', value: 'cup'),
                      DropdownMenuEntry(label: 'IU', value: 'IU'),
                      DropdownMenuEntry(label: 'oz', value: 'oz'),
                      DropdownMenuEntry(label: 'pt', value: 'pt'),
                      DropdownMenuEntry(label: 'qt', value: 'qt'),
                      DropdownMenuEntry(label: 'gal', value: 'gal'),
                      DropdownMenuEntry(label: 'lb', value: 'lb'),
                      DropdownMenuEntry(label: 'mg/mL', value: 'mg/mL'),
                    ],
                    menuHeight: 200,
                    label: const Text('Type'),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
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
