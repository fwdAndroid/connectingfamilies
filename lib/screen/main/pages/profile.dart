import 'package:connectingfamilies/provider/language_provider.dart';
import 'package:connectingfamilies/screen/profile/edit_profile.dart';
import 'package:connectingfamilies/uitls/colors.dart';
import 'package:connectingfamilies/widget/save_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UserProfilePage extends StatefulWidget {
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
  final List<dynamic> interest;

  UserProfilePage(
      {super.key,
      required this.photo,
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
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

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
                  image: NetworkImage(widget.photo),
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
                    widget.fullName,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.pink),
                      SizedBox(width: 8),
                      Text(widget.location),
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
                            languageProvider
                                    .localizedStrings['Family description'] ??
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
                              hintText: widget.familyDescription,
                              hintStyle: GoogleFonts.poppins(
                                  color: black, fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  _buildSectionTitle(
                      languageProvider.localizedStrings['Family Type'] ??
                          'Family Type'),
                  _buildInfoContainer(widget.familyType),
                  _buildSectionTitle(
                      languageProvider.localizedStrings['Date of Birth'] ??
                          'Date of Birth'),
                  _buildInfoContainer(widget.dateofBirth),
                  _buildSectionTitle(
                      languageProvider.localizedStrings['Special Situation'] ??
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
                    children:
                        List<Widget>.generate(widget.interest.length, (index) {
                      return _buildChip(widget.interest[index]);
                    }),
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
                      title:
                          languageProvider.localizedStrings['Edit Profile'] ??
                              'Edit Profile',
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
