// ignore_for_file: must_be_immutable, no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meds/screens/account/account_settings.dart';
import 'package:meds/screens/chat/chat_screen.dart';
import 'package:meds/sevices/chat_service.dart';

class ChatMain extends StatefulWidget {
  const ChatMain({super.key});

  @override
  State<ChatMain> createState() => _ChatMainState();
}

class _ChatMainState extends State<ChatMain> {
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
                            .snapshots(),
                        builder: (context, snapshot) {
                          String? userId =
                              FirebaseAuth.instance.currentUser!.uid;
                          var userFirestore = FirebaseFirestore.instance
                              .collection("Users")
                              .doc(userId)
                              .snapshots();
                          if (snapshot.hasError) {
                            return const Text("Error");
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const LinearProgressIndicator();
                          }

                          return StreamBuilder(
                            stream: userFirestore,
                            builder: (context, usnapshot) {
                              if (usnapshot.hasData) {
                                String userType =
                                    usnapshot.data!["userType"].toString();
                                // print(userType);
                                if (userType == "0") {
                                  return ListView(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    children: snapshot.data!.docs
                                        .map<Widget>((doc) =>
                                            _buildDrListItem(doc, 1, userType))
                                        .toList(),
                                  );
                                } else {
                                  return ListView(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    children: snapshot.data!.docs
                                        .map<Widget>((doc) =>
                                            _buildDrListItem(doc, 0, userType))
                                        .toList(),
                                  );
                                }
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          );
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

  //build individual dr list
  Widget _buildDrListItem(
      DocumentSnapshot doc, int userType, String currentUserType) {
    Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
    final ChatService _chatService = ChatService();
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    if (currentUser!.email != data["email"] && data["userType"] == userType) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: StreamBuilder(
          stream:
              _chatService.getMessages(doc.id, _firebaseAuth.currentUser!.uid),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Text("Loading"));
            }

            String? lastMessage;
            DateTime? datetime;

            if (snapshot.data!.docs
                .map((document) {
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  return data['message'];
                })
                .toList()
                .isNotEmpty) {
              lastMessage = snapshot.data!.docs.map((document) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                return data['message'];
              }).toList()[0];

              Timestamp lastTimestamp = snapshot.data!.docs.map((document) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                return data['timestamp'];
              }).toList()[0];

              datetime = lastTimestamp.toDate();
            }

            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      receiverUserName: data['email'].split("@").first,
                      receiverUserID: doc.id,
                    ),
                  ),
                );
              },
              child: currentUserType == "1"
                  ? lastMessage != null
                      ? ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 10),
                          tileColor: Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          leading: (data['pic'] == null)
                              ? CircleAvatar(
                                  radius: 25,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  foregroundColor:
                                      Theme.of(context).colorScheme.surface,
                                  child: const Icon(Icons.person_outlined),
                                )
                              : CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(data['pic']),
                                ),
                          title: Text(
                            data['email'].split("@").first,
                            style: GoogleFonts.roboto(
                              color: const Color.fromARGB(255, 16, 15, 15),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            lastMessage,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Text(
                            '${datetime!.hour}:${datetime.minute}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        )
                      : const SizedBox(
                          height: 0,
                        )
                  : ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 10),
                      tileColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      leading: (data['pic'] == null)
                          ? CircleAvatar(
                              radius: 25,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.surface,
                              child: const Icon(Icons.person_outlined),
                            )
                          : CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(data['pic']),
                            ),
                      title: Text(
                        data['email'].split("@").first,
                        style: GoogleFonts.roboto(
                          color: const Color.fromARGB(255, 16, 15, 15),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: lastMessage != null
                          ? Text(
                              lastMessage,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          : null,
                      trailing: datetime != null
                          ? Text(
                              '${datetime.hour}:${datetime.minute}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            )
                          : null,
                    ),
            );
          },
        ),
      );
    } else {
      return const SizedBox(
        height: 0,
      );
    }
  }
}
