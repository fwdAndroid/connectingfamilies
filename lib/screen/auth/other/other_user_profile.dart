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
  final String dateofBirth;
  final String location;
  final String nutritions;
  final String parentingStyle;
  final String phoneNumber;
  final String familyDescription;
  final String uuid;
  final String familyType;
  final String specialSituation;
  final favorite;
  final List<dynamic> interest;

  OtherUserProfile(
      {super.key,
      required this.photo,
      required this.favorite,
      required this.email,
      required this.specialSituation,
      required this.familyType,
      required this.fullName,
      required this.location,
      required this.dateofBirth,
      required this.interest,
      required this.familyDescription,
      required this.nutritions,
      required this.parentingStyle,
      required this.phoneNumber,
      required this.uuid});

  @override
  State<OtherUserProfile> createState() => _OtherUserProfileState();
}

class _OtherUserProfileState extends State<OtherUserProfile> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final languageProvider = Provider.of<LanguageProvider>(context);
    final screenHeight = MediaQuery.of(context).size.height;

    var uuid = Uuid().v4();
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Image
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      widget.photo), // Replace with your image path
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
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
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
                      Text(widget.location),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Row for actions (Chat, Like, Clear)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 24,
                        child: Icon(Icons.clear, color: Colors.black),
                      ),
                      SizedBox(width: 20),
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("users")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .snapshots(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (!snapshot.hasData || snapshot.data == null) {
                              return Center(
                                  child: Text(languageProvider.localizedStrings[
                                          'No data available'] ??
                                      'No data available'));
                            }
                            var snap = snapshot.data;
                            return GestureDetector(
                              onTap: () async {
                                // Add navigation to chat
                                await FirebaseFirestore.instance
                                    .collection("chats")
                                    .doc(uuid)
                                    .set({
                                  "chatId": uuid,
                                  "userId":
                                      FirebaseAuth.instance.currentUser!.uid,
                                  "userName": snap['fullName'],
                                  "userPhoto": snap['photo'],
                                  "friendId": widget.uuid,
                                  "friendName": widget.fullName,
                                  "friendPhoto": widget.photo,
                                }).then((onValue) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (builder) => ChatMessages(
                                                chatUUid: uuid,
                                                userId: FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                userName: snap['fullName'],
                                                userPhoto: snap['photo'],
                                                friendId: widget.uuid,
                                                friendName: widget.fullName,
                                                friendPhoto: widget.photo,
                                              )));
                                });
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 24,
                                child: Icon(Icons.chat_bubble_outline,
                                    color: Colors.black),
                              ),
                            );
                          }),
                      SizedBox(width: 20),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 24,
                        child: Icon(Icons.favorite, color: Colors.red),
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                ],
              ),
            ),

            // Profile Details (List of Interests, Family, etc.)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ListView(
                  children: [
                    _buildSectionTitle(
                        languageProvider.localizedStrings['Family Type'] ??
                            'Family Type'),
                    _buildInfoContainer(widget.familyType),
                    _buildSectionTitle(
                        languageProvider.localizedStrings['Date of Birth'] ??
                            'Date of Birth'),
                    _buildInfoContainer(widget.dateofBirth),
                    _buildSectionTitle(languageProvider
                            .localizedStrings['Special Situation'] ??
                        'Special Situation'),
                    _buildTag(widget.specialSituation),
                    _buildSectionTitle(
                        languageProvider.localizedStrings['Parenting Style'] ??
                            'Parenting Style'),
                    _buildTag(widget.parentingStyle),
                    _buildSectionTitle(
                        languageProvider.localizedStrings['Nutrition'] ??
                            'Nutrition'),
                    _buildTag(widget.nutritions),
                    SizedBox(height: screenHeight * 0.02),

                    // Dynamic Hobbies Chips from Firebase
                    _buildSectionTitle(
                        languageProvider.localizedStrings['Interests'] ??
                            'Interests'),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: List<Widget>.generate(widget.interest.length,
                          (index) {
                        return _buildChip(widget.interest[index]);
                      }),
                    ),

                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SaveButton(
                          title: "Report Account",
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => ReportAccount()));
                          }),
                    )
                  ],
                ),
              ),
            ),
          ],
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
