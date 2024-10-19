import 'package:connectingfamilies/screen/chat/chat_message.dart';
import 'package:connectingfamilies/screen/profile/report_account.dart';
import 'package:connectingfamilies/widget/save_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OtherUserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

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
                  image: AssetImage(
                      'assets/pic.png'), // Replace with your image path
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
                    'Jessica_Parker023',
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
                      Text('Chicago, IL United States'),
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
                      GestureDetector(
                        onTap: () {
                          // Add navigation to chat
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => ChatMessages()));
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 24,
                          child: Icon(Icons.chat_bubble_outline,
                              color: Colors.black),
                        ),
                      ),
                      SizedBox(width: 20),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 24,
                        child: Icon(Icons.favorite, color: Colors.red),
                      ),
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
                    buildSectionTitle('Interests'),
                    buildTagRow(['Travelling', 'Camping', 'Hiking']),
                    SizedBox(height: 16),
                    buildSectionTitle('Nutrition'),
                    buildTagRow(['Vegetarian']),
                    SizedBox(height: 16),
                    buildSectionTitle('Special Situations'),
                    buildTagRow(['Wheel Chair']),
                    SizedBox(height: 16),
                    buildSectionTitle('Family Type'),
                    buildTagRow(['Son']),
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
}
