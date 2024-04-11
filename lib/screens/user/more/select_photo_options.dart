// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// import '/components/re_usable_select_photo_button.dart';

// class SelectPhotoOptionsScreen extends StatelessWidget {
//   final Function(ImageSource) onTap;
//   const SelectPhotoOptionsScreen({
//     super.key,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // color: Colors.grey.shade300,
//       padding: const EdgeInsets.all(20),
//       child: Stack(
//         alignment: AlignmentDirectional.center,
//         clipBehavior: Clip.none,
//         children: [
//           Positioned(
//             top: -35,
//             child: Container(
//               width: 50,
//               height: 6,
//               margin: const EdgeInsets.only(bottom: 20),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(2.5),
//                 color: Colors.white,
//               ),
//             ),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SelectPhoto(
//                 onTap: () => onTap(ImageSource.gallery),
//                 icon: Icons.image_outlined,
//                 textLabel: 'Browse Gallery',
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               const Center(
//                 child: Text(
//                   'or',
//                   style: TextStyle(fontSize: 18),
//                 ),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               SelectPhoto(
//                 onTap: () => onTap(ImageSource.camera),
//                 icon: Icons.camera_alt_outlined,
//                 textLabel: 'Use Camera',
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
