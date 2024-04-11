// ignore_for_file: must_be_immutable, no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meds/screens/account/account_settings.dart';
import 'package:meds/screens/user/store/view_stock_screen.dart';

class ViewStoreScreen extends StatefulWidget {
  const ViewStoreScreen({super.key});

  @override
  State<ViewStoreScreen> createState() => _ViewStoreScreenState();
}

class _ViewStoreScreenState extends State<ViewStoreScreen> {
  //current user
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            alignment: Alignment.topCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //logo and name
                const Column(
                  children: [
                    //logo
                    Image(
                      image: AssetImage('assets/icon_small.png'),
                      height: 50,
                    ),
                  ],
                ),

                // user icon widget
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const SettingsPageUI();
                            },
                          ),
                        );
                      },
                      child: (currentUser?.photoURL?.isEmpty ?? true)
                          ? CircleAvatar(
                              radius: 20,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.surface,
                              child: const Icon(Icons.person_outlined),
                            )
                          : CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  NetworkImage(currentUser!.photoURL!),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: GlowingOverscrollIndicator(
              axisDirection: AxisDirection.down,
              color: const Color.fromARGB(255, 7, 83, 96),
              child: SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    children: [
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('Users')
                            .where('userType', isEqualTo: 2)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Text("Error");
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const LinearProgressIndicator();
                          }
                          if (snapshot.data!.docs.isNotEmpty) {
                            return ListView(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: snapshot.data!.docs
                                  .map<Widget>((doc) => _buildSrListItem(doc))
                                  .toList(),
                            );
                          } else {
                            return Center(
                              child: Column(
                                children: [
                                  Image.asset(
                                    height: MediaQuery.of(context).size.height *
                                        0.20,
                                    'assets/images/medication.gif',
                                    color: const Color.fromARGB(
                                        255, 241, 250, 251),
                                    colorBlendMode: BlendMode.darken,
                                  ),
                                  Text(
                                    "No Store Currently Available",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildSrListItem(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(doc.id)
            .collection('Medicines')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text("Loading"));
          }
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      ViewStockScreen(storeName: data['name'], storeID: doc.id),
                ),
              );
            },
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              tileColor: Colors.grey[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              leading: (data['pic'] == null)
                  ? CircleAvatar(
                      radius: 25,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.surface,
                      child: const Icon(Icons.person_outlined),
                    )
                  : CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(data['pic']),
                    ),
              title: Text(
                '${data['name']} Stores',
                style: GoogleFonts.roboto(
                  color: const Color.fromARGB(255, 16, 15, 15),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                'Buy medicines from ${data['email'].split("@").first}',
                style: const TextStyle(
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        },
      ),
    );
  }
}
