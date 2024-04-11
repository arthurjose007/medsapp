import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meds/model/medicine_buy_model.dart';

class MedicineBuyService extends ChangeNotifier {
  //get instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  //send message
  Future<void> buyMedicine(
      String shopId, String productId, double totalPrice) async {
    // get current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final Timestamp timestamp = Timestamp.now();

    //create a new order
    Medicine newmedicine = Medicine(
        buyerId: currentUserId,
        shopId: shopId,
        productId: productId,
        timestamp: timestamp,
        delivered: false,
        totalPrice: totalPrice);

    //construct chat room id
    List<String> ids = [currentUserId, shopId];
    ids.sort();
    String orderId = ids.join("_");

    // add new message
    await _firebaseFirestore
        .collection('orders')
        .doc(orderId)
        .collection('order')
        .add(newmedicine.toMap());
  }

  //get order
  Stream<QuerySnapshot> getorder(String userId, String otherUserId) {
    // construct  room id from the user ids
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String orderId = ids.join("_");
    return _firebaseFirestore
        .collection('orders')
        .doc(orderId)
        .collection('order')
        .where('delivered', isEqualTo: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getUserOrder(String userId, String otherUserId) {
    // construct room id from the user ids
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String orderId = ids.join("_");
    return _firebaseFirestore
        .collection('orders')
        .doc(orderId)
        .collection('order')
        .snapshots();
  }
}
