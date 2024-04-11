import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meds/components/chat_bubble.dart';
import 'package:meds/sevices/chat_service.dart';

class ChatScreen extends StatefulWidget {
  final String receiverUserName;
  final String receiverUserID;
  const ChatScreen({
    super.key,
    required this.receiverUserName,
    required this.receiverUserID,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.receiverUserID,
        _messageController.text,
      );

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.receiverUserName,
          style: const TextStyle(
            fontSize: 22,
          ),
        ),
        elevation: 5,
      ),
      body: Column(
        children: [
          //messages
          Expanded(
            child: _buildMessageList(),
          ),

          //user input
          _buildMessageInut(),
        ],
      ),
    );
  }

  //build message list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
          widget.receiverUserID, _firebaseAuth.currentUser!.uid),
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
              'Message ${widget.receiverUserName}',
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
            horizontal: 8,
          ),
          child: ListView(
            reverse: true,
            children: snapshot.data!.docs
                .map((document) => _buildMessageItem(document))
                .toList(),
          ),
        );
      },
    );
  }

  //build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    //align the message accordingly
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        alignment: alignment,
        child: Column(
          crossAxisAlignment:
              (data['senderId'] == _firebaseAuth.currentUser!.uid)
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
          mainAxisAlignment:
              (data['senderId'] == _firebaseAuth.currentUser!.uid)
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
          children: [
            Text(data['senderEmail'].split("@").first),
            const SizedBox(height: 3),
            Padding(
              padding: (data['senderId'] == _firebaseAuth.currentUser!.uid)
                  ? EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.35)
                  : EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.35),
              child: ChatBubble(
                message: data['message'],
                timestamp: data['timestamp'].toDate(),
                isCurrent: (data['senderId'] == _firebaseAuth.currentUser!.uid),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //build message input
  Widget _buildMessageInut() {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 14, top: 8),
      child: SizedBox(
        child: TextField(
          textAlignVertical: TextAlignVertical.center,
          controller: _messageController,
          decoration: InputDecoration(
            hintText: 'Enter message',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            suffixIcon: IconButton(
              onPressed: sendMessage,
              icon: Icon(
                Icons.send,
                color: Theme.of(context).colorScheme.primary,
                size: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
