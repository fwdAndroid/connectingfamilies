import 'package:connectingfamilies/screen/profile_setup/profile_setup_three.dart';
import 'package:connectingfamilies/uitls/colors.dart';
import 'package:connectingfamilies/widget/save_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';

class ProfileSetupTwo extends StatefulWidget {
  const ProfileSetupTwo({super.key});

  @override
  State<ProfileSetupTwo> createState() => _ProfileSetupTwoState();
}

class _ProfileSetupTwoState extends State<ProfileSetupTwo> {
  bool showOthersField = false; // Boolean to control visibility of Others field
  bool showOthersFieldNu =
      false; // Boolean to control visibility of Others field
  TextEditingController _nuController = TextEditingController();
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Column(
          children: [
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
                      selectedTextStyle:
                          GoogleFonts.poppins(color: colorWhite, fontSize: 11),
                      textAlign: TextAlign.center,
                      selectedBorderColor: firstMainColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onSelected: (value, index, isSelected) {
                      // Check if "Others" is selected
                      setState(() {
                        showOthersField = (value == "Others");
                      });
                    },
                    isRadio: true,
                    buttons: [
                      "Avoid using electronic devices",
                      "Free use of electronic devices",
                      "Moderate use of electronic devices",
                      "Respectful Parenting",
                      "A Slap in Time",
                      "Never Slap in Time",
                      "My children have Phone",
                      "Others",
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 130,
                        child: SaveButton(title: "Add", onTap: () {}),
                      ),
                    ],
                  ),
                )
              ],
            ),
            if (showOthersField) buildOthersField(),
            // Column(
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.only(top: 10.0, left: 16),
            //       child: Align(
            //         alignment: AlignmentDirectional.topStart,
            //         child: Text(
            //           'Activities',
            //           style: GoogleFonts.poppins(
            //               color: black,
            //               fontWeight: FontWeight.w500,
            //               fontSize: 17),
            //         ),
            //       ),
            //     ),
            //     Container(
            //       margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
            //       child: GroupButton(
            //         options: GroupButtonOptions(
            //           buttonWidth: 100,
            //           unselectedTextStyle:
            //               GoogleFonts.poppins(color: black, fontSize: 10),
            //           selectedTextStyle:
            //               GoogleFonts.poppins(color: colorWhite, fontSize: 10),
            //           textAlign: TextAlign.center,
            //           selectedBorderColor: firstMainColor,
            //           borderRadius: BorderRadius.circular(20),
            //         ),
            //         onSelected: (value, index, isSelected) {},
            //         isRadio: false,
            //         buttons: [
            //           "Take a Walk",
            //           "Camper",
            //           "Deep Chats",
            //           "Hiking",
            //           "Family trips",
            //           "Cine",
            //           "Pinics",
            //           "High Capacities",
            //           "Vision problems",
            //           "Audition problemsne",
            //           "Asperger",
            //           "Others",
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
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
                      selectedTextStyle:
                          GoogleFonts.poppins(color: colorWhite, fontSize: 10),
                      textAlign: TextAlign.center,
                      selectedBorderColor: firstMainColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onSelected: (value, index, isSelected) {
                      // Check if "Others" is selected
                      setState(() {
                        showOthersFieldNu = (value == "Others");
                      });
                    },
                    isRadio: true,
                    buttons: [
                      "No Preference",
                      "Ultra-Processed Foods Free",
                      "Vegan",
                      "Vegetarian",
                      "Gluten Free",
                      "Sugar Free",
                      "Pork free",
                      "Others",
                    ],
                  ),
                ),
                if (showOthersFieldNu) buildOthersFieldN(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 130,
                        child: SaveButton(title: "Add", onTap: () {}),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SaveButton(
                  title: " Next",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => ProfileSetupThree()));
                  }),
            )
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

  //Nutrition
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
