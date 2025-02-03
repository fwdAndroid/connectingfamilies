import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectingfamilies/provider/language_provider.dart';
import 'package:connectingfamilies/screen/chat/chat_message.dart';
import 'package:connectingfamilies/uitls/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: colorWhite,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          languageProvider.localizedStrings['Chat'] ?? "Chat",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: currentUserId == null
          ? Center(child: Text("User not logged in"))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .where('users', arrayContains: currentUserId)
                  .orderBy('lastMessageTime', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No chats available"));
                }

                var chats = snapshot.data!.docs;
                print("Fetched ${chats.length} chats for user: $currentUserId");

                return ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    var chat = chats[index];

                    String friendId = chat['user1Id'] == currentUserId
                        ? chat['user2Id']
                        : chat['user1Id'];
                    String friendName = chat['user1Id'] == currentUserId
                        ? chat['user2Name']
                        : chat['user1Name'];
                    String friendPhoto = chat['user1Id'] == currentUserId
                        ? chat['user2Photo']
                        : chat['user1Photo'];

                    String lastMessage =
                        chat['lastMessage'] ?? "No messages yet";
                    bool lastMessageSeen = chat['lastMessageSeen'] ?? false;

                    // ✅ Convert int timestamp to DateTime
                    String formattedTime = "";
                    if (chat['lastMessageTime'] != null) {
                      try {
                        int lastMessageTime =
                            chat['lastMessageTime']; // Get as int
                        DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                            lastMessageTime);
                        formattedTime = DateFormat('hh:mm a').format(dateTime);
                      } catch (e) {
                        print("Error formatting time: $e");
                      }
                    }

                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: friendPhoto.isNotEmpty
                              ? NetworkImage(friendPhoto)
                              : AssetImage('assets/default_user.png')
                                  as ImageProvider,
                        ),
                        title: Text(friendName,
                            style: GoogleFonts.poppins(fontSize: 16)),
                        subtitle: Text(lastMessage,
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        trailing: Text(
                          formattedTime,
                          style: TextStyle(
                            color: lastMessageSeen ? Colors.grey : Colors.blue,
                            fontWeight: lastMessageSeen
                                ? FontWeight.normal
                                : FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                friendId: friendId,
                                chatId: chat.id,
                                friendName: friendName,
                                friendImage: friendPhoto,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
