import 'package:connectingfamilies/screen/profile/edit_profile.dart';
import 'package:connectingfamilies/uitls/colors.dart';
import 'package:connectingfamilies/widget/save_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image
            Container(
              height: screenHeight * 0.35,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
                image: DecorationImage(
                  image: AssetImage(
                      'assets/pic.png'), // Replace with your image path
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Name, Age, and Location
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sarah, 21',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Row(
                    children: [
                      Icon(Icons.hiking, color: Colors.pink),
                      SizedBox(width: 8),
                      Text('Hiking'),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.pink),
                      SizedBox(width: 8),
                      Text('Lahore'),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                        ),
                        child: Align(
                          alignment: AlignmentDirectional.topStart,
                          child: Text(
                            'Family description',
                            style: GoogleFonts.poppins(
                                color: black,
                                fontWeight: FontWeight.w500,
                                fontSize: 17),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 8),
                        height: 155,
                        child: TextFormField(
                          maxLines: 10,
                          readOnly: true,
                          style: GoogleFonts.poppins(color: black),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: borderColor)),
                              errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: borderColor)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: borderColor)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: borderColor)),
                              hintText: "It is My Family Description Text",
                              hintStyle: GoogleFonts.poppins(
                                  color: black, fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  _buildSectionTitle('Family Type'),
                  _buildInfoContainer('Mother'),
                  _buildSectionTitle('Date of Birth'),
                  _buildInfoContainer('23 December 2023'),
                  _buildSectionTitle('Special Situation'),
                  _buildTag('Rare Disease'),
                  _buildSectionTitle('Parenting Style'),
                  _buildTag('Respectful Parenting'),
                  _buildSectionTitle('Activities'),
                  _buildTag('Camper'),
                  _buildSectionTitle('Nutrition'),
                  _buildTag('Ultra-Processed Foods Free'),
                  _buildSectionTitle('Language I Know'),
                  _buildInfoContainer('Catalan'),
                  SizedBox(height: screenHeight * 0.02),
                  // Hobbies Chips
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: [
                      _buildChip('Hiking'),
                      _buildChip('Traveling'),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  // Edit Profile Button
                  Center(
                    child: SaveButton(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => EditProfile()));
                      },
                      title: 'Edit Profile',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
