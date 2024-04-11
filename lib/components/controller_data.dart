// ignore_for_file: non_constant_identifier_names

import 'package:flutter/cupertino.dart';

class MedicationControllerData {
  TextEditingController medicationNameController = TextEditingController();
  TextEditingController medicationTypeController = TextEditingController();
  TextEditingController medicationStrengthValueController =
      TextEditingController();
  TextEditingController medicationStrengthController = TextEditingController();
  TextEditingController medicationPhotoController = TextEditingController();
  TextEditingController medicationDosageValueController =
      TextEditingController();
  TextEditingController medicationDosageController = TextEditingController();
  TextEditingController medicationCountController = TextEditingController();
  TextEditingController medicationPriceController = TextEditingController();
  TextEditingController medicationNoteController = TextEditingController();
  TextEditingController medicationTimeOfDayController = TextEditingController();
  TextEditingController medicationTimesController = TextEditingController();
  TextEditingController medicationTimes12HController = TextEditingController();
  TextEditingController medicationNumberOfTimesController =
      TextEditingController();
  TextEditingController medicationStartingDateController =
      TextEditingController();
  TextEditingController medicationEndingDateController =
      TextEditingController();
  TextEditingController medicationFrequencyController = TextEditingController();
  TextEditingController medicationFrequency_isSpecificDays_Controller =
      TextEditingController();
  TextEditingController medicationFrequency_weekday_Controller =
      TextEditingController();

  // Singleton pattern for accessing the instance
  static final MedicationControllerData _instance =
      MedicationControllerData._internal();

  void clear() {
    medicationNameController.clear();
    medicationTypeController.clear();
    medicationStrengthValueController.clear();
    medicationStrengthController.clear();
    medicationPhotoController.clear();
    medicationDosageValueController.clear();
    medicationDosageController.clear();
    medicationCountController = TextEditingController();
    medicationPriceController.clear();
    medicationNoteController.clear();
    medicationTimeOfDayController.clear();
    medicationTimesController.clear();
    medicationTimes12HController.clear();
    medicationNumberOfTimesController.clear();
    medicationStartingDateController.clear();
    medicationEndingDateController.clear();
    medicationFrequencyController.clear();
    medicationFrequency_isSpecificDays_Controller.clear();
    medicationFrequency_weekday_Controller.clear();
  }

  factory MedicationControllerData() {
    return _instance;
  }

  MedicationControllerData._internal();
}
