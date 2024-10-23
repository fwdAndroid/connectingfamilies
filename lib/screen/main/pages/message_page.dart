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
            stream: FirebaseFirestore.instance
                .collection("chats")
                .where("userId",
                    isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data == null) {
                return Center(
                    child: Text(languageProvider
                            .localizedStrings['No data available'] ??
                        'No data available'));
              }
              var snap = snapshot.data;

              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Card(
                      elevation: 1,
                      color: colorWhite,
                      child: ListTile(
                        trailing: Text("11:30",
                            style: GoogleFonts.roboto(
                                color: black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500)),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => ChatMessages(
                                      friendId: snap['friendId'],
                                      friendName: snap['friendName'],
                                      friendPhoto: snap['friendPhoto'],
                                      userId: FirebaseAuth
                                          .instance.currentUser?.uid,
                                      chatUUid: snap['chatId'],
                                      userName: snap['userName'],
                                      userPhoto: snap['userPhoto'])));
                        },
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(snap['friendPhoto']),
                        ),
                        title: Text(
                          snap['friendName'],
                          style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: black,
                              fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(snap['lastMessageByCustomer'],
                            style: GoogleFonts.roboto(
                                color: favouriteColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500)),
                      ),
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}
