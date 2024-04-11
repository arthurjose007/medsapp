// ignore_for_file: no_leading_underscores_for_local_identifiers, avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:meds/screens/account/account_settings.dart';
import 'package:meds/sevices/buy_service.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  User? currentUser = FirebaseAuth.instance.currentUser;

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

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color.fromARGB(255, 7, 83, 96),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // app logo and user icon
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
          Text(
            "Current Orders",
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w600,
              fontSize: 18,
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
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Users')
                        .snapshots(),
                    builder: (context, snapshot) {
                      String? userId = FirebaseAuth.instance.currentUser!.uid;
                      var userFirestore = FirebaseFirestore.instance
                          .collection("Users")
                          .doc(userId)
                          .snapshots();
                      if (snapshot.hasError) {
                        return const Text("Error");
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox();
                      }

                      return StreamBuilder(
                        stream: userFirestore,
                        builder: (context, ssnapshot) {
                          if (ssnapshot.hasData) {
                            // print(userType);
                            return Column(
                              children: snapshot.data!.docs
                                  .map<Widget>((doc) => _buildListItem(doc))
                                  .toList(),
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildListItem(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final MedicineBuyService _buyService = MedicineBuyService();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: StreamBuilder(
        stream: _buyService.getorder(doc.id, _firebaseAuth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error ${snapshot.error}');
          }

          if (snapshot.hasData) {
            return Column(
              children: snapshot.data!.docs
                  .map<Widget>((document) => _buildOrderItem(document))
                  .toList(),
            );
          } else {
            return const SizedBox(
              height: 0,
            );
          }
        },
      ),
    );
  }

  getDate(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();

    // Format DateTime to just the date
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    return formattedDate;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getOrderData(
      String userId, String otherUserId, String orderId) {
    // construct chat room id from the user ids
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String ordersId = ids.join("_");
    return FirebaseFirestore.instance
        .collection('orders')
        .doc(ordersId)
        .collection('order')
        .doc(orderId)
        .snapshots();
  }

  updateStatus(String userId, String otherUserId, String orderId) async {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String ordersId = ids.join("_");

    await FirebaseFirestore.instance
        .collection('orders')
        .doc(ordersId)
        .collection('order')
        .doc(orderId)
        .update({
      'delivered': true,
      'timestamp': Timestamp.now(),
    });
    _showSnackBar("Product delivered.");
  }

  _buildOrderItem(QueryDocumentSnapshot<Object?> document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    return StreamBuilder(
      stream: getOrderData(
          data['buyerId'], FirebaseAuth.instance.currentUser!.uid, document.id),
      builder: (context, osnapshot) {
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(data['buyerId'])
              .snapshots(),
          builder: (context, usnapshot) {
            return Container(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('Medicines')
                    .doc(data['productId'])
                    .snapshots(),
                builder: (context, psnapshot) {
                  if (psnapshot.connectionState == ConnectionState.waiting) {
                    return const LinearProgressIndicator();
                  } else {
                    return Card(
                      child: ListTile(
                        title: Text(
                          psnapshot.data!['medname'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        leading: Image.asset(
                          categoryImagePath(psnapshot.data!['category']),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              usnapshot.data!['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              usnapshot.data!['address'],
                            ),
                            Text(
                              'Ordered On ${getDate(osnapshot.data!['timestamp'])}',
                            ),
                            Text(
                              '${osnapshot.data!['totalPrice']} Rs',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        trailing: Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                updateStatus(
                                  data['buyerId'],
                                  FirebaseAuth.instance.currentUser!.uid,
                                  document.id,
                                );
                              },
                              icon: const Icon(
                                Icons.check,
                                color: Colors.green,
                                size: 35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}
