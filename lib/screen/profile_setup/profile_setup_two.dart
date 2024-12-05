import 'dart:typed_data';

import 'package:connectingfamilies/screen/profile_setup/profile_setup_three.dart';
import 'package:connectingfamilies/uitls/colors.dart';
import 'package:connectingfamilies/widget/save_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';
import 'package:connectingfamilies/uitls/image_picker.dart';

class ProfileSetupTwo extends StatefulWidget {
  String familyDescription;
  final Uint8List image;
  final String phoneNumber;
  final String confirmPassword;
  final String password;
  final String fullName;
  final String email;
  final String dob;
  final String location;
  final String specialSituation;
  final String familyType;
  ProfileSetupTwo(
      {super.key,
      required this.image,
      required this.confirmPassword,
      required this.fullName,
      required this.dob,
      required this.email,
      required this.familyDescription,
      required this.location,
      required this.password,
      required this.familyType,
      required this.phoneNumber,
      required this.specialSituation});

  @override
  State<ProfileSetupTwo> createState() => _ProfileSetupTwoState();
}

class _ProfileSetupTwoState extends State<ProfileSetupTwo> {
  bool showOthersField = false; // Boolean to control visibility of Others field
  bool showOthersFieldNu =
      false; // Boolean to control visibility of Others field
  TextEditingController _nuController = TextEditingController();
  TextEditingController _controller = TextEditingController();

  // Lists to store multiple values for nutrition and parenting style
  List<String> selectedNutritionSituations = [];
  List<String> selectedParentingSituations = [];

  List<String> nutritionsList = [
    "Non Vegan", // Changed to a more descriptive value
    "Cycling", // Changed to a more descriptive value
    "NSFA", // Changed to a more descriptive value
    "Ultra-Processed Foods Free",
    "Vegan",
    "Vegetarian",
    "Gluten Free",
    "Sugar Free",
    "Pork free",
    "Others",
  ];

  List<String> parentingList = [
    "Avoid using electronic devices",
    "Free use of electronic devices",
    "Moderate use of electronic devices",
    "Respectful Parenting",
    "A Slap in Time",
    "Never Slap in Time",
    "My children have Phone",
    "Others",
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Column(
          children: [
            // Parenting Style Selection
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 16),
                  child: Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Text(
                      'Parenting Style',
                      style: GoogleFonts.poppins(
                          color: black,
                          fontWeight: FontWeight.w500,
                          fontSize: 17),
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
                        selectedTextStyle: GoogleFonts.poppins(
                            color: colorWhite, fontSize: 11),
                        textAlign: TextAlign.center,
                        selectedBorderColor: firstMainColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onSelected: (value, index, isSelected) {
                        setState(() {
                          if (value == "Others") {
                            showOthersField = true;
                          } else {
                            if (isSelected) {
                              selectedParentingSituations.add(value.toString());
                            } else {
                              selectedParentingSituations
                                  .remove(value.toString());
                            }
                            showOthersField = false;
                          }
                        });
                      },
                      isRadio: false, // Allow multiple selections
                      buttons: parentingList),
                ),
                if (showOthersField) buildOthersField(),
              ],
            ),

            // Nutrition Selection
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 16),
                  child: Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Text(
                      'Nutrition',
                      style: GoogleFonts.poppins(
                          color: black,
                          fontWeight: FontWeight.w500,
                          fontSize: 17),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: GroupButton(
                      options: GroupButtonOptions(
                        buttonWidth: 100,
                        unselectedTextStyle:
                            GoogleFonts.poppins(color: black, fontSize: 10),
                        selectedTextStyle: GoogleFonts.poppins(
                            color: colorWhite, fontSize: 10),
                        textAlign: TextAlign.center,
                        selectedBorderColor: firstMainColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onSelected: (value, index, isSelected) {
                        setState(() {
                          if (value == "Others") {
                            showOthersFieldNu = true;
                          } else {
                            if (isSelected) {
                              selectedNutritionSituations.add(value.toString());
                            } else {
                              selectedNutritionSituations
                                  .remove(value.toString());
                            }
                            showOthersFieldNu = false;
                          }
                        });
                      },
                      isRadio: false, // Allow multiple selections
                      buttons: nutritionsList),
                ),
                if (showOthersFieldNu) buildOthersFieldN(),
              ],
            ),

            // Show Selected Values
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected Parenting Styles:',
                    style: GoogleFonts.poppins(
                      color: black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    selectedParentingSituations
                        .join(', '), // Display selected list as a string
                    style: GoogleFonts.poppins(color: black),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Selected Nutrition Preferences:',
                    style: GoogleFonts.poppins(
                      color: black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    selectedNutritionSituations
                        .join(', '), // Display selected list as a string
                    style: GoogleFonts.poppins(color: black),
                  ),
                ],
              ),
            ),

            // Next Button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SaveButton(
                  title: "Next",
                  onTap: () {
                    // Here we can pass the selected values to the next screen or save them.
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => ProfileSetupThree(
                                  email: widget.email,
                                  parenting: selectedParentingSituations,
                                  nutrition: selectedNutritionSituations,
                                  location: widget.location,
                                  password: widget.password,
                                  phoneNumber: widget.phoneNumber,
                                  specialSituation: widget.specialSituation,
                                  image: widget.image,
                                  familyDescription: widget.familyDescription,
                                  confirmPassword: widget.confirmPassword,
                                  fullName: widget.fullName,
                                  dob: widget.dob,
                                  familyType: widget.familyType,
                                )));
                  }),
            ),
          ],
        )
      ])),
    ));
  }

  // Specify Parenting Style
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
                parentingList.insert(parentingList.length - 1, value);
                selectedParentingSituations.add(value);
                showOthersField = false;
                _controller.clear();
              });
            },
            controller: _controller,
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
              hintText: "Specify the Parenting Style",
              hintStyle: GoogleFonts.poppins(color: black, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  // Specify Nutrition
  Widget buildOthersFieldN() {
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
                nutritionsList.insert(nutritionsList.length - 1, value);
                selectedNutritionSituations.add(value);
                showOthersFieldNu = false;
                _nuController.clear();
              });
            },
            controller: _nuController,
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
              hintText: "Specify the Nutrition",
              hintStyle: GoogleFonts.poppins(color: black, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}
