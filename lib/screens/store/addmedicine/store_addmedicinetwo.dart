// ignore_for_file: non_constant_identifier_names, unused_local_variable, library_private_types_in_public_api, must_be_immutable, unused_element

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meds/model/category_model.dart';
import 'package:meds/components/controller_data.dart';
import 'package:meds/screens/store/store_mainscreen.dart';

class StoreAddMedicines2 extends StatefulWidget {
  List<CategoryModel> categories = CategoryModel.getCategories();

  StoreAddMedicines2({super.key});

  @override
  _StoreAddMedicines2State createState() => _StoreAddMedicines2State();
}

class _StoreAddMedicines2State extends State<StoreAddMedicines2> {
  //current user
  User? currentUser = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();

  TextEditingController medname =
      MedicationControllerData().medicationNameController;
  TextEditingController meddescription =
      MedicationControllerData().medicationNoteController;

  TextEditingController category =
      MedicationControllerData().medicationTypeController;
  TextEditingController medPrice =
      MedicationControllerData().medicationPriceController;
  TextEditingController total_med =
      MedicationControllerData().medicationCountController;

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color.fromARGB(255, 7, 83, 96),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void addMedicine() async {
    //loading circle
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Color.fromRGBO(7, 82, 96, 1),
          ),
        );
      },
    );

    try {
      final snapshot1 = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.uid)
          .collection('Medicines')
          .add({});

      String newID = snapshot1.id;
      // print('Created medication ID: $newID');

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.uid)
          .collection('Medicines')
          .doc(newID)
          .set({
        'medname': medname.text.isNotEmpty ? medname.text : null,
        'description':
            meddescription.text.isNotEmpty ? meddescription.text : null,
        'category': category.text.isNotEmpty ? category.text : null,
        'total_med':
            total_med.text.isNotEmpty ? int.parse(total_med.text) : null,
        'price': medPrice.text.isNotEmpty ? double.parse(medPrice.text) : null,
      });

      // print('Medication added successfully');

      if (!mounted) {
        return;
      }
      //pop loading cicle
      Navigator.of(context).pop();

      //navigate to dashbaord
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const StoreMainScreen(),
        ),
      );
      _showSnackBar('Medication added successfully');
      MedicationControllerData().clear();
    } on FirebaseException catch (e) {
      Navigator.of(context).pop();
      _showSnackBar('${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Summary',
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
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: ListView(
            children: [
              SizedBox(
                height: 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment
                      .center, // Align children vertically in the center
                  children: [
                    Image.asset(
                      'assets/icons/heartbeat.gif',
                      height: 80,
                      fit: BoxFit.fitHeight,
                      color: const Color.fromARGB(255, 241, 250, 251),
                      colorBlendMode: BlendMode.darken,
                    ),
                    // SizedBox(width: 20),
                  ],
                ),
              ),
              Line(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'MEDICINE DETAILS',
                    style: TextStyle(
                        color: Colors.tealAccent[700],
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Line(),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.38,
                      child: const Text(
                        'Name',
                        textWidthBasis: TextWidthBasis.parent,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                    Text(
                      textAlign: TextAlign.justify,
                      medname.text,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.38,
                      child: const Text(
                        'Description',
                        textWidthBasis: TextWidthBasis.parent,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                    Text(
                      textAlign: TextAlign.justify,
                      meddescription.text,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.38,
                      child: const Text(
                        'Category',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                    Text(
                      category.text,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Line(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'MEDICINE COUNT',
                    style: TextStyle(
                        color: Colors.tealAccent[700],
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Line(),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.38,
                      child: const Text(
                        'Total Medicine Count',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                    Text(
                      total_med.text,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 10,
              ),
              //horizontal line
              Line(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'PRICE',
                    style: TextStyle(
                        color: Colors.tealAccent[700],
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              //horizontal line
              Line(),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.38,
                      child: const Text(
                        'Price Per medicine',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        medPrice.text,
                        maxLines: 8,
                        overflow: TextOverflow.clip,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.42,
                height: 55,
                child: FilledButton(
                  onPressed: addMedicine,
                  // onPressed: test,
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
                    'Done',
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

Widget Line() {
  return Container(
    margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
    width: double.infinity,
    height: 2,
    color: Colors.grey.shade300,
  );
}
