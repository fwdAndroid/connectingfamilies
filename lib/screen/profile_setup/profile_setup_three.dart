import 'dart:typed_data';

import 'package:connectingfamilies/service/database.dart';
import 'package:connectingfamilies/uitls/colors.dart';
import 'package:connectingfamilies/widget/save_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';

class ProfileSetupThree extends StatefulWidget {
  String familyDescription;
  final Uint8List image;
  final String phoneNumber;
  final String confirmPassword;
  final String password;
  final String fullName;
  final String email;
  final String location;
  final String specialSituation;
  final String familyType;
  final List<String> nutrition;
  final List<String> parenting;
  final List<Map<String, String>> familyMembers;
  final String genders;

  ProfileSetupThree(
      {super.key,
      required this.image,
      required this.confirmPassword,
      required this.fullName,
      required this.genders,
      required this.familyMembers,
      required this.nutrition,
      required this.parenting,
      required this.email,
      required this.familyDescription,
      required this.location,
      required this.password,
      required this.familyType,
      required this.phoneNumber,
      required this.specialSituation});

  @override
  State<ProfileSetupThree> createState() => _ProfileSetupThreeState();
}

class _ProfileSetupThreeState extends State<ProfileSetupThree> {
  TextEditingController othersController = TextEditingController();
  bool showOthersField = false; // Boolean to control visibility of Others field
  List<String> selectedActivities = [];
  bool isLoading = false;
  final List<String> activities = [
    "Ball Park",
    "Basket",
    "Beach",
    "Board Games",
    "Camping",
    "City Family",
    "Country Side Family",
    "Cultural Activities",
    "Cycling",
    "Going to the Park",
    "Hiking",
    "Laser Games",
    "Others",
    "Outdoor Activities",
    "Peaceful Activities",
    "Pet Walks",
    "Reading (Books)",
    "Scape Rooms",
    "Skating",
    "Soccer",
    "Sports",
    "Take a Walk",
    "Traveling",
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 16),
                  child: Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Text(
                      'Your interests',
                      style: GoogleFonts.poppins(
                          color: black,
                          fontWeight: FontWeight.bold,
                          fontSize: 24),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0, left: 16),
                  child: Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Text(
                      'Pick at least 3 things you love. It’ll help you to match with other families who love them too.',
                      style: GoogleFonts.poppins(
                          color: textColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 12),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: GroupButton(
                    options: GroupButtonOptions(
                      buttonWidth: 150,
                      unselectedTextStyle:
                          GoogleFonts.poppins(color: black, fontSize: 11),
                      selectedTextStyle:
                          GoogleFonts.poppins(color: colorWhite, fontSize: 11),
                      textAlign: TextAlign.center,
                      selectedBorderColor: firstMainColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onSelected: (value, index, isSelected) {
                      setState(() {
                        if (isSelected) {
                          selectedActivities.add(value);
                        } else {
                          selectedActivities.remove(value);
                        }
                        showOthersField = (value == "Others");
                      });
                    },
                    isRadio: false, // Set to false to allow multiple selections
                    buttons: activities,
                  ),
                ),
              ],
            ),
            if (showOthersField) buildOthersField(),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SaveButton(
                        title: " Registered",
                        onTap: () async {
                          if (selectedActivities.length < 3) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Please select at least 3 activities')),
                            );
                            return;
                          }
                          if (showOthersField &&
                              othersController.text.isNotEmpty) {
                            selectedActivities.add(othersController.text);
                          }

                          setState(() {
                            isLoading = true;
                          });

                          await DatabaseMethods().signUpUser(
                            familyMembers: widget.familyMembers,
                            context: context,
                            confirmPassword: widget.confirmPassword,
                            fullName: widget.fullName,
                            nutrition: widget.nutrition,
                            parenting: widget.parenting,
                            email: widget.email,
                            familyDescription: widget.familyDescription,
                            location: widget.location,
                            password: widget.password,
                            familyType: widget.familyType,
                            interest: selectedActivities,
                            phoneNumber: widget.phoneNumber,
                            specialSituation: widget.specialSituation,
                            file: widget.image,
                            genders: widget.genders,
                          );

                          setState(() {
                            isLoading = false;
                          });

                          // Show success message or navigate
                        }))
          ],
        )
      ]),
    )));
  }

  Widget buildOthersField() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 16),
          child: Align(
            alignment: AlignmentDirectional.topStart,
            child: Text(
              'Please specify*',
              style: GoogleFonts.poppins(
                color: black,
                fontWeight: FontWeight.w500,
                fontSize: 17,
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
          padding: const EdgeInsets.all(8),
          child: TextFormField(
            onFieldSubmitted: (value) {
              setState(() {
                activities.insert(selectedActivities.length - 1, value);
                othersController.text = value;
                showOthersField = false;
                othersController.clear();
              });
            },
            controller: othersController,
            style: GoogleFonts.poppins(color: black),
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xffF7F8F9),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor),
              ),
              hintText: "Specify the Interest",
              hintStyle: GoogleFonts.poppins(color: black, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}
