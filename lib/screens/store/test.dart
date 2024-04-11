// import 'dart:typed_data';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';


// class SellScreen extends StatefulWidget {
//   const SellScreen({super.key});

//   @override
//   State<SellScreen> createState() => _SellScreenState();
// }

// class _SellScreenState extends State<SellScreen> {
//   bool isLoading = false;
//   int selected = 1;
//   Uint8List? img;
//   TextEditingController nameController = TextEditingController();
//   TextEditingController costController = TextEditingController();
//   List<int> keysForDiscount = [0, 70, 60, 50];
// // Expanded spaceThing =
//   @override
//   void dispose() {
//     super.dispose();
//     nameController.dispose();
//     costController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size screenSize = MediaQuery.of(context).size;
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: !isLoading
//             ? SingleChildScrollView(
//                 child: SizedBox(
//                   height: screenSize.height,
//                   width: screenSize.width,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 10.0, horizontal: 20),
//                     child: Center(
//                         child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Stack(
//                           children: [
//                             img == null
//                                 ? Image.network(
//                                     "https://thumbs.dreamstime.com/b/default-avatar-profile-icon-social-media-user-vector-default-avatar-profile-icon-social-media-user-vector-portrait-176194876.jpg",
//                                     height: screenSize.height / 10,
//                                   )
//                                 : Image.memory(
//                                     img!,
//                                     height: screenSize.height / 10,
//                                   ),
//                             IconButton(
//                                 onPressed: () async {
//                                   Uint8List? temp = await Utils().pickImage();
//                                   if (temp != null) {
//                                     setState(() {
//                                       img = temp;
//                                     });
//                                   }
//                                 },
//                                 icon: const Icon(Icons.file_upload))
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 15,
//                         ),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 35, vertical: 10),
//                           height: screenSize.height * 0.7,
//                           width: screenSize.width * 0.7,
//                           decoration: BoxDecoration(
//                               border: Border.all(
//                             color: Colors.grey,
//                             width: 1,
//                           )),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 "Item Details",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold, fontSize: 20),
//                               ),
//                               const SizedBox(
//                                 height: 5,
//                               ),
//                               TextFieldWidget(
//                                   title: "Name",
//                                   controller: nameController,
//                                   obscureText: false,
//                                   hintText: "Enter the name of the item"),
//                               TextFieldWidget(
//                                   title: "Cost",
//                                   controller: costController,
//                                   obscureText: false,
//                                   hintText: "Enter the cost of the item"),
//                               const Text(
//                                 "Discount",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold, fontSize: 17),
//                               ),
//                               ListTile(
//                                 title: const Text("None"),
//                                 leading: Radio(
//                                   value: 1,
//                                   groupValue: selected,
//                                   onChanged: (int? i) {
//                                     setState(() {
//                                       selected = i!;
//                                     });
//                                   },
//                                 ),
//                               ),
//                               ListTile(
//                                 title: const Text("70%"),
//                                 leading: Radio(
//                                   value: 2,
//                                   groupValue: selected,
//                                   onChanged: (int? i) {
//                                     setState(() {
//                                       selected = i!;
//                                     });
//                                   },
//                                 ),
//                               ),
//                               ListTile(
//                                 title: const Text("60%"),
//                                 leading: Radio(
//                                   value: 3,
//                                   groupValue: selected,
//                                   onChanged: (int? i) {
//                                     setState(() {
//                                       selected = i!;
//                                     });
//                                   },
//                                 ),
//                               ),
//                               ListTile(
//                                 title: const Text("50%"),
//                                 leading: Radio(
//                                   value: 4,
//                                   groupValue: selected,
//                                   onChanged: (int? i) {
//                                     setState(() {
//                                       selected = i!;
//                                     });
//                                   },
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         CustomMainButton(
//                             color: yellowColor,
//                             isLoading: isLoading,
//                             onPressed: () async {
//                               String output = await CloudFirestoreClass()
//                                   .uploadProductToDatabase(
//                                       image: img,
//                                       productName: nameController.text,
//                                       rawCost: costController.text,
//                                       discount: keysForDiscount[selected - 1],
//                                       sellerName:
//                                           Provider.of<UserDetailsProvider>(
//                                                   context,
//                                                   listen: false)
//                                               .userDetails!
//                                               .name,
//                                       sellerUid: FirebaseAuth
//                                           .instance.currentUser!.uid);

//                               print("output======$output");
//                               if (output == "success") {
//                                 Utils().showSnackBar(
//                                     context: context,
//                                     content: "Posted Product");
//                               } else {
//                                 Utils().showSnackBar(
//                                     context: context, content: output);
//                               }
//                             },
//                             child: const Text(
//                               "Sell",
//                               style: TextStyle(color: Colors.black),
//                             )),
//                         const SizedBox(
//                           height: 5,
//                         ),
//                         CustomMainButton(
//                             color: Colors.grey[300]!,
//                             isLoading: false,
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             child: const Text(
//                               "Back",
//                               style: TextStyle(color: Colors.black),
//                             )),
//                       ],
//                     )),
//                   ),
//                 ),
//               )
//             : const LoadingWidget(),
//       ),
//     );
//   }
// }





