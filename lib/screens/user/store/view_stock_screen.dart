// ignore_for_file: unused_element

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meds/screens/user/store/buy_screen.dart';

class ViewStockScreen extends StatefulWidget {
  final String storeName;
  final String storeID;
  const ViewStockScreen({
    super.key,
    required this.storeName,
    required this.storeID,
  });

  @override
  State<ViewStockScreen> createState() => _ViewStockScreenState();
}

class _ViewStockScreenState extends State<ViewStockScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.storeName,
          style: const TextStyle(
            fontSize: 22,
          ),
        ),
        elevation: 5,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(widget.storeID)
            .collection('Medicines')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text("Loading"));
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No Stock Available',
                style: GoogleFonts.roboto(
                  color: const Color.fromARGB(255, 16, 15, 15),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: MediaQuery.of(context).size.height * 0.28,
                mainAxisSpacing: 10,
                crossAxisSpacing: 20,
                crossAxisCount: 2,
              ),
              children: snapshot.data!.docs
                  .map<Widget>((document) => _buildStoreItem(document))
                  .toList(),
            ),
          );
        },
      ),
    );
  }

  _buildStoreItem(QueryDocumentSnapshot<Map<String, dynamic>> document) {
    Map<String, dynamic> data = document.data();

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

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MedicineBuyScreen(
              data: data,
              storeId: widget.storeID,
              productId: document.id,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.15,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(
                      categoryImagePath(data['category']),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                data['medname'],
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                '${data['price'].toString()} Rs',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
