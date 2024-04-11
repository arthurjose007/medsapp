// ignore_for_file: must_be_immutable, use_build_context_synchronously, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class MedCard3 extends StatefulWidget {
  final String medID;
  final VoidCallback refreshCallback;

  const MedCard3({
    super.key,
    required this.medID,
    required this.refreshCallback,
  });

  @override
  State<MedCard3> createState() => _MedCard3State();
}

class _MedCard3State extends State<MedCard3> {
  User? currentUser = FirebaseAuth.instance.currentUser;

  final TextEditingController _medicationCountController =
      TextEditingController();
  final TextEditingController _medicationPriceController =
      TextEditingController();

  late FocusNode focusNode_totalPill;
  late FocusNode focusNode_price;

  @override
  void initState() {
    super.initState();
    focusNode_totalPill = FocusNode();
    focusNode_price = FocusNode();
  }

  Future<DocumentSnapshot> getMedData() async {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('Medicines')
        .doc(widget.medID)
        .get(const GetOptions(source: Source.cache));
  }

  String categoryImagePath(String catgoryStr) {
    switch (catgoryStr) {
      case 'Capsule':
        return 'assets/icons/pills.gif';
      case 'Tablet':
        return 'assets/icons/tablet.gif';
      case 'Liquid':
        return 'assets/icons/liquid.gif';
      case 'Topical':
        return 'assets/icons/tube.gif';
      case 'Cream':
        return 'assets/icons/cream.gif';
      case 'Drops':
        return 'assets/icons/drops.gif';
      case 'Foam':
        return 'assets/icons/foam.gif';
      case 'Gel':
        return 'assets/icons/tube.gif';
      case 'Herbal':
        return 'assets/icons/herbal.gif';
      case 'Inhaler':
        return 'assets/icons/inhalator.gif';
      case 'Injection':
        return 'assets/icons/syringe.gif';
      case 'Lotion':
        return 'assets/icons/lotion.gif';
      case 'Nasal Spray':
        return 'assets/icons/nasalspray.gif';
      case 'Ointment':
        return 'assets/icons/tube.gif';
      case 'Patch':
        return 'assets/icons/patch.gif';
      case 'Powder':
        return 'assets/icons/powder.gif';
      case 'Spray':
        return 'assets/icons/spray.gif';
      case 'Suppository':
        return 'assets/icons/suppository.gif';
      default:
        return 'assets/icons/medicine.gif';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getMedData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            Map<String, dynamic>? medData = snapshot.data!.data() != null
                ? snapshot.data!.data() as Map<String, dynamic>
                : <String, dynamic>{};
            //data
            String? medname = medData['medname'];
            String? category = medData['category'];
            int? total_med = medData['total_med'];
            double? price = medData['price'];

            return GestureDetector(
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Are you sure want to delete "$medname"?'),
                      actions: [
                        TextButton(
                          child: Text(
                            'OK',
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('Users')
                                .doc(currentUser!.uid)
                                .collection('Medicines')
                                .doc(widget.medID)
                                .delete();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor:
                                    const Color.fromARGB(255, 7, 83, 96),
                                behavior: SnackBarBehavior.floating,
                                duration: const Duration(seconds: 2),
                                content: Text(
                                  '"$medname" deleted successfully',
                                ),
                              ),
                            );
                            // setState(() {});
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              onTap: () {
                _medicationCountController.text = total_med.toString();
                _medicationPriceController.text = price.toString();
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        'Edit $medname?',
                        textAlign: TextAlign.center,
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            focusNode: focusNode_totalPill,
                            keyboardType: TextInputType.number,
                            obscureText: false,
                            controller: _medicationCountController,
                            style: GoogleFonts.roboto(
                              height: 2,
                              color: const Color.fromARGB(255, 16, 15, 15),
                            ),
                            cursorColor: const Color.fromARGB(255, 7, 82, 96),
                            decoration: InputDecoration(
                              hintText: "100",
                              filled: true,
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              // fillColor: Colors.white,
                              focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    20,
                                  ),
                                ),
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 7, 82, 96),
                                ),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    20,
                                  ),
                                ),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              labelText: "Total count",
                              labelStyle: GoogleFonts.roboto(
                                color: const Color.fromARGB(255, 16, 15, 15),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            focusNode: focusNode_price,
                            keyboardType: TextInputType.number,
                            obscureText: false,
                            controller: _medicationPriceController,
                            style: GoogleFonts.roboto(
                              height: 2,
                              color: const Color.fromARGB(255, 16, 15, 15),
                            ),
                            cursorColor: const Color.fromARGB(255, 7, 82, 96),
                            decoration: InputDecoration(
                              hintText: "100",
                              filled: true,
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              // fillColor: Colors.white,
                              focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    20,
                                  ),
                                ),
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 7, 82, 96),
                                ),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    20,
                                  ),
                                ),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              labelText: "Price per unit",
                              labelStyle: GoogleFonts.roboto(
                                color: const Color.fromARGB(255, 16, 15, 15),
                              ),
                            ),
                          ),
                          // const SizedBox(height: 10),
                        ],
                      ),
                      actions: [
                        TextButton(
                          child: Text(
                            'OK',
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('Users')
                                .doc(currentUser!.uid)
                                .collection('Medicines')
                                .doc(widget.medID)
                                .update({
                              'total_med':
                                  int.parse(_medicationCountController.text),
                              'price':
                                  int.parse(_medicationPriceController.text),
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor:
                                    const Color.fromARGB(255, 7, 83, 96),
                                behavior: SnackBarBehavior.floating,
                                duration: const Duration(seconds: 2),
                                content: Text(
                                  '"$medname" edited successfully',
                                ),
                              ),
                            );

                            Navigator.of(context).pop();
                            setState(() {});
                          },
                        ),
                        TextButton(
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(255, 76, 112, 117),
                  boxShadow: const [
                    BoxShadow(
                        color: Color.fromARGB(255, 174, 194, 197),
                        blurRadius: 5.0,
                        offset: Offset(0, 2))
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //category icon
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          categoryImagePath(category!),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    //medication name

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            medname!,
                            style: GoogleFonts.roboto(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                        ),
                        Text(
                          "Price: ${price.toString()} Rs",
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.surface,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Count: ${total_med.toString()}",
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.surface,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Container(
              width: double.infinity,
              height: 120.0,
              margin: const EdgeInsets.fromLTRB(50, 20, 25, 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.grey.shade300,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.signal_wifi_off_rounded,
                      color: Colors.grey.shade600),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Network Error',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              enabled: true,
              child: const SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    BannerPlaceholder(),
                  ],
                ),
              ));
        }
        return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            enabled: true,
            child: const SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  BannerPlaceholder(),
                ],
              ),
            ));
      },
    );
  }
}

class BannerPlaceholder extends StatelessWidget {
  const BannerPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120.0,
      margin: const EdgeInsets.fromLTRB(50, 20, 25, 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
      ),
    );
  }
}
