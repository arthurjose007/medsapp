// ignore_for_file: no_leading_underscores_for_local_identifiers, avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meds/sevices/buy_service.dart';

class UserOrdersScreen extends StatefulWidget {
  const UserOrdersScreen({super.key});

  @override
  State<UserOrdersScreen> createState() => _UserOrdersScreenState();
}

class _UserOrdersScreenState extends State<UserOrdersScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Orders"),
      ),
      body: Column(
        children: [
          // app logo and user icon

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
        stream:
            _buyService.getUserOrder(doc.id, _firebaseAuth.currentUser!.uid),
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

  _buildOrderItem(QueryDocumentSnapshot<Object?> document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    return StreamBuilder(
      stream: getOrderData(
          data['shopId'], FirebaseAuth.instance.currentUser!.uid, document.id),
      builder: (context, osnapshot) {
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(data['shopId'])
              .snapshots(),
          builder: (context, ssnapshot) {
            return Container(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(data['shopId'])
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
                              "${ssnapshot.data!['name']} Stores",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            if (osnapshot.data!['delivered'] == false)
                              Text(
                                'Ordered Placed On ${getDate(osnapshot.data!['timestamp'])}',
                              ),
                            if (osnapshot.data!['delivered'] == true)
                              Text(
                                'Order Delivered On ${getDate(osnapshot.data!['timestamp'])}',
                              ),
                            Text(
                              '${osnapshot.data!['totalPrice']} Rs',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
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
