import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectingfamilies/provider/language_provider.dart';
import 'package:connectingfamilies/screen/chat/chat_message.dart';
import 'package:connectingfamilies/uitls/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        backgroundColor: colorWhite,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(languageProvider.localizedStrings['Chat'] ?? "Chat"),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder(
          stream: _getChatStreams(currentUserId),
          builder:
              (context, AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  var snap =
                      snapshot.data![index].data() as Map<String, dynamic>;
                  return _buildChatTile(
                      context, snap, currentUserId, languageProvider);
                },
              );
            } else {
              return Center(
                child: Text(
                    languageProvider.localizedStrings['No chats found'] ??
                        'No chats found'),
              );
            }
          },
        ),
      ),
    );
  }

  /// Combine user and friend chat streams and remove duplicates based on chatId
  Stream<List<QueryDocumentSnapshot>> _getChatStreams(String? currentUserId) {
    final userChats = FirebaseFirestore.instance
        .collection("chats")
        .where("userId", isEqualTo: currentUserId)
        .snapshots();
    final friendChats = FirebaseFirestore.instance
        .collection("chats")
        .where("friendId", isEqualTo: currentUserId)
        .snapshots();

    return userChats.asyncMap((userSnapshot) async {
      final friendSnapshot = await friendChats.first;
      final userDocs = userSnapshot.docs;
      final friendDocs = friendSnapshot.docs
          .where((doc) => !userDocs.any((userDoc) => userDoc.id == doc.id));
      return [...userDocs, ...friendDocs];
    });
  }

  /// Builds the chat tile widget
  Widget _buildChatTile(BuildContext context, Map<String, dynamic> snap,
      String? currentUserId, LanguageProvider languageProvider) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        elevation: 1,
        color: colorWhite,
        child: ListTile(
          trailing: Text("11:30", // Ideally, this should come from `snap` data
              style: GoogleFonts.roboto(
                  color: black, fontSize: 14, fontWeight: FontWeight.w500)),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (builder) => ChatMessages(
                  friendId: snap['friendId'],
                  friendName: snap['friendName'],
                  friendPhoto: snap['friendPhoto'],
                  userId: currentUserId,
                  chatUUid: snap['chatId'],
                  userName: snap['userName'],
                  userPhoto: snap['userPhoto'],
                ),
              ),
            );
          },
          leading: CircleAvatar(
            backgroundImage: NetworkImage(snap['friendPhoto'] ?? ''),
          ),
          title: Text(
            snap['friendName'] ?? "No Name",
            style: GoogleFonts.poppins(
                fontSize: 18, color: black, fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            snap['lastMessageByCustomer'] ?? "",
            style: GoogleFonts.roboto(
                color: favouriteColor,
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
