// ignore_for_file: must_be_immutable, avoid_print, library_private_types_in_public_api, non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meds/model/category_model.dart';
import 'package:meds/components/controller_data.dart';
import 'package:meds/components/text_field.dart';
import 'package:meds/screens/store/addmedicine/store_addmedicinetwo.dart';

class StoreAddMedicines1 extends StatefulWidget {
  List<CategoryModel> categories = CategoryModel.getCategories();

  StoreAddMedicines1({super.key});

  @override
  _StoreAddMedicines1State createState() => _StoreAddMedicines1State();
}

class _StoreAddMedicines1State extends State<StoreAddMedicines1> {
  final user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _medicationNameController =
      MedicationControllerData().medicationNameController;
  final TextEditingController _medicationTypeController =
      MedicationControllerData().medicationTypeController;
  final TextEditingController _medicationCountController =
      MedicationControllerData().medicationCountController;
  final TextEditingController _medicationPriceController =
      MedicationControllerData().medicationPriceController;
  final TextEditingController _medicationNoteController =
      MedicationControllerData().medicationNoteController;

  late FocusNode focusNode_medName;
  late FocusNode focusNode_totalPill;
  late FocusNode focusNode_price;
  late FocusNode focusNode_note;

  int _selectedCategoryIndex = -1;

  @override
  void initState() {
    super.initState();
    focusNode_medName = FocusNode();
    focusNode_totalPill = FocusNode();
    focusNode_price = FocusNode();
    focusNode_note = FocusNode();
  }

  void goToNextPage() {
    if (_medicationNameController.text.isEmpty) {
      focusNode_medName.requestFocus();
    } else if (_medicationNoteController.text.isEmpty) {
      focusNode_note.requestFocus();
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
    } else if (_medicationCountController.text.isEmpty) {
      focusNode_totalPill.requestFocus();
    } else if (_medicationPriceController.text.isEmpty) {
      focusNode_price.requestFocus();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StoreAddMedicines2(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Medicine',
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
                height: 10,
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
                height: 10,
              ),
              Text_Field(
                label: 'Medication Name',
                hint: 'Vitamin C',
                isPassword: false,
                keyboard: TextInputType.text,
                txtEditController: _medicationNameController,
                focusNode: focusNode_medName,
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.all(10),
                width: double.infinity,
                height: 2,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 10),
              //description
              const Text(
                'Medication Description',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 10,
              ),
              Text_Field(
                label: 'Medication Description',
                hint: '',
                isPassword: false,
                keyboard: TextInputType.text,
                txtEditController: _medicationNoteController,
                focusNode: focusNode_note,
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.all(10),
                width: double.infinity,
                height: 2,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 10),

              //category
              const Text(
                'Category',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 10,
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
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.all(10),
                width: double.infinity,
                height: 2,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 10),
              //total pill count
              const Text(
                'Available Pill Count ',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Text_Field(
                label: 'Total Pill Count',
                hint: '100',
                isPassword: false,
                keyboard: TextInputType.number,
                txtEditController: _medicationCountController,
                focusNode: focusNode_totalPill,
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.all(10),
                width: double.infinity,
                height: 2,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 10),

              //Price
              const Text(
                'Price ',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Text_Field(
                label: 'Price per unit',
                hint: '100',
                isPassword: false,
                keyboard: TextInputType.number,
                txtEditController: _medicationPriceController,
                focusNode: focusNode_price,
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
