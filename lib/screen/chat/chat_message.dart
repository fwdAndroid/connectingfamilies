import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String friendId;
  final String friendName;
  final String friendImage;

  ChatScreen({
    required this.chatId,
    required this.friendId,
    required this.friendName,
    required this.friendImage,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  void sendMessage() async {
    if (messageController.text.trim().isEmpty) return;

    int timestamp = DateTime.now().millisecondsSinceEpoch;
    String messageText = messageController.text.trim();

    DocumentReference chatRef =
        firestore.collection('chats').doc(widget.chatId);
    CollectionReference messagesRef = chatRef.collection('messages');

    await messagesRef.add({
      "senderId": currentUserId,
      "receiverId": widget.friendId,
      "message": messageText,
      "timestamp": timestamp,
      "seen": false
    });

    await chatRef.update({
      "lastMessage": messageText,
      "lastMessageTime": timestamp,
      "lastMessageSeen": false
    });

    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.friendName)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore
                  .collection('chats')
                  .doc(widget.chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());

                var messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var msg = messages[index];
                    bool isMine = msg['senderId'] == currentUserId;

                    return Align(
                      alignment:
                          isMine ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: isMine ? Colors.blue : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(msg['message']),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue),
                  onPressed: sendMessage,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
