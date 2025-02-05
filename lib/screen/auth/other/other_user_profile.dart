import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectingfamilies/provider/language_provider.dart';
import 'package:connectingfamilies/screen/chat/chat_message.dart';
import 'package:connectingfamilies/screen/profile/report_account.dart';
import 'package:connectingfamilies/widget/save_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class OtherUserProfile extends StatefulWidget {
  final String photo;
  final String fullName;
  final String email;
  final String location;
  final List<dynamic> nutritions;
  final List<dynamic> parentingStyle;
  final String phoneNumber;
  final String familyDescription;
  final String uuid;
  final String familyType;
  final String specialSituation;
  final List<dynamic> favorite;
  final List<dynamic> interest;

  OtherUserProfile({
    super.key,
    required this.photo,
    required this.favorite,
    required this.email,
    required this.specialSituation,
    required this.familyType,
    required this.fullName,
    required this.location,
    required this.interest,
    required this.familyDescription,
    required this.nutritions,
    required this.parentingStyle,
    required this.phoneNumber,
    required this.uuid,
  });

  @override
  State<OtherUserProfile> createState() => _OtherUserProfileState();
}

class _OtherUserProfileState extends State<OtherUserProfile> {
  late bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    // Fetch current user's favorite list and check if this user is favorited
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    final currentUserDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserUid)
        .get();

    final currentUserFavorites = currentUserDoc.data()?['favorite'] ?? [];
    setState(() {
      isFavorite = currentUserFavorites.contains(widget.uuid);
    });
  }

  Future<void> initiateChat(BuildContext context) async {
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    String chatId = currentUserUid.compareTo(widget.uuid) <= 0
        ? "${currentUserUid}_${widget.uuid}"
        : "${widget.uuid}_${currentUserUid}";

    DocumentReference chatRef =
        FirebaseFirestore.instance.collection("chats").doc(chatId);

    // Check if chat already exists
    DocumentSnapshot chatSnap = await chatRef.get();

    if (!chatSnap.exists) {
      // Fetch current user data
      final currentUserDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserUid)
          .get();

      if (!currentUserDoc.exists) return;

      var currentUserData = currentUserDoc.data()!;
      await chatRef.set({
        "chatId": chatId,
        "users": [currentUserUid, widget.uuid], // Important for queries
        "user1Id": currentUserUid,
        "user2Id": widget.uuid,
        "user1Name": currentUserData['fullName'],
        "user2Name": widget.fullName,
        "user1Photo": currentUserData['photo'] ?? "",
        "user2Photo": widget.photo,
        "lastMessage": "",
        "lastMessageTime": 0,
        "lastMessageSeen": false
      });
    }

    // Navigate to Chat Screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          chatId: chatId,
          friendId: widget.uuid,
          friendName: widget.fullName,
          friendImage: widget.photo,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final languageProvider = Provider.of<LanguageProvider>(context);

    var uuid1 = Uuid().v4();

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile Image
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.photo), // Profile picture
                    fit: BoxFit.cover,
                  ),
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 24,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ),
              ),

              // User Details
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Username
                    Text(
                      widget.fullName,
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),

                    // Location
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.pink),
                        SizedBox(width: 8),
                        Expanded(child: Text(widget.location)),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Row for actions (Chat, Like, Clear)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("users")
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .snapshots(),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              if (!snapshot.hasData || snapshot.data == null) {
                                return Center(
                                    child: Text(
                                        languageProvider.localizedStrings[
                                                'No data available'] ??
                                            'No data available'));
                              }
                              var snap = snapshot.data;
                              return GestureDetector(
                                onTap: () => initiateChat(context),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 24,
                                  child: Icon(Icons.chat_bubble_outline,
                                      color: Colors.black),
                                ),
                              );
                            }),
                        SizedBox(width: 20),
                        GestureDetector(
                          onTap: () async {
                            final currentUser =
                                FirebaseAuth.instance.currentUser!;
                            final currentUserDoc = FirebaseFirestore.instance
                                .collection("users")
                                .doc(currentUser.uid);

                            setState(() {
                              isFavorite = !isFavorite;
                            });

                            if (isFavorite) {
                              // Add this user to the favorite list
                              await currentUserDoc.update({
                                "favorite": FieldValue.arrayUnion([widget.uuid])
                              });
                            } else {
                              // Remove this user from the favorite list
                              await currentUserDoc.update({
                                "favorite":
                                    FieldValue.arrayRemove([widget.uuid])
                              });
                            }
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 24,
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_outline,
                              color: isFavorite ? Colors.red : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildSectionTitle(
                    languageProvider.localizedStrings['Family Type'] ??
                        'Family Type'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildInfoContainer(widget.familyType),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildSectionTitle(
                    languageProvider.localizedStrings['Date of Birth'] ??
                        'Date of Birth'),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildSectionTitle(
                    languageProvider.localizedStrings['Parenting Style'] ??
                        'Parenting Style'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: List<Widget>.generate(widget.parentingStyle.length,
                      (index) {
                    return _buildChip(widget.parentingStyle[index]);
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildSectionTitle(
                    languageProvider.localizedStrings['Nutrition'] ??
                        'Nutrition'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children:
                      List<Widget>.generate(widget.nutritions.length, (index) {
                    return _buildChip(widget.nutritions[index]);
                  }),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Dynamic Hobbies Chips from Firebase
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildSectionTitle(
                    languageProvider.localizedStrings['Interests'] ??
                        'Interests'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children:
                      List<Widget>.generate(widget.interest.length, (index) {
                    return _buildChip(widget.interest[index]);
                  }),
                ),
              ),

              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SaveButton(
                    title:
                        languageProvider.localizedStrings['Report Account'] ??
                            "Report Account",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => ReportAccount()));
                    }),
              )
              // Profile Details (List of Interests, Family, etc.)
            ],
          ),
        ),
      ),
    );
  }

  // Section Title Widget
  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  // Tag Row Widget (for Interests, Nutrition, etc.)
  Widget buildTagRow(List<String> tags) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: tags.map((tag) {
        return Chip(
          label: Text(tag),
          backgroundColor: Colors.grey[200],
        );
      }).toList(),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoContainer(String info) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Text(
        info,
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Colors.pink, Colors.purple],
        ),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildChip(String label) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.purple,
    );
  }
}
