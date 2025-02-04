import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectingfamilies/screen/main/main_dashboard.dart';
import 'package:connectingfamilies/uitls/colors.dart';
import 'package:connectingfamilies/widget/save_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';

class EditInterest extends StatefulWidget {
  const EditInterest({super.key});

  @override
  State<EditInterest> createState() => _EditInterestState();
}

class _EditInterestState extends State<EditInterest> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<String> selectedInterest = [];
  TextEditingController _nuController = TextEditingController();
  bool showOthersFieldNu = false;
  bool isLoading = false;
  List<String> interest = [];

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    setState(() => isLoading = true);

    try {
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();

      var userinterests = userDoc['interest'];
      interest = userinterests is List ? List<String>.from(userinterests) : [];
      selectedInterest = List.from(interest);
    } catch (e) {
      print("Error fetching user data: $e");
    }

    setState(() => isLoading = false);
  }

  Future<void> updateUserProfile() async {
    setState(() => isLoading = true);

    try {
      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'interest': selectedInterest,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );

      Navigator.push(
          context, MaterialPageRoute(builder: (builder) => MainDashboard()));
    } catch (e) {
      print("Error updating user profile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile')),
      );
    }

    setState(() => isLoading = false);
  }

  List<String> interestsList = [
    "Camping",
    "Hikking",
    "Traveling",
    "Take a Walk",
    "Board Games",
    "Out Door Activities",
    "Ball Park",
    "Cycling",
    "Pet Walks",
    "Soccer",
    "Cultural Activities",
    "Basket",
    "Skating",
    "Beach",
    "Reading (Books)",
    "Sports",
    "Laser Games",
    "Scape Rooms",
    "Peaceful Activities",
    "City Family",
    "Going to the Park",
    "Country Side Family",
    "Others",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(children: [
          sectionHeader("interest"),
          selectedChips(selectedInterest),
          sectionHeader("New interest Values"),
          groupButtonSelection(
              interestsList, selectedInterest, showOthersFieldNu, (value) {
            setState(() {
              if (value == "Others")
                showOthersFieldNu = true;
              else {
                if (selectedInterest.contains(value)) {
                  selectedInterest.remove(value);
                } else {
                  selectedInterest.add(value);
                }
                showOthersFieldNu = false;
              }
            });
          }),
          if (showOthersFieldNu)
            buildOthersField(_nuController, selectedInterest, () {
              setState(() => showOthersFieldNu = false);
            }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                SaveButton(title: "Update Profile", onTap: updateUserProfile),
          )
        ]),
      ),
    );
  }

  Widget sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 16),
      child: Align(
        alignment: AlignmentDirectional.topStart,
        child: Text(
          title,
          style: GoogleFonts.poppins(
              color: black, fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
    );
  }

  Widget selectedChips(List<String> items) {
    return Wrap(
      children: items
          .map((item) => Chip(
                label: Text(item, style: TextStyle(color: colorWhite)),
                backgroundColor: firstMainColor,
                deleteIcon: Icon(Icons.cancel, color: Colors.white, size: 18),
                onDeleted: () {
                  setState(() {
                    items.remove(item);
                  });
                },
              ))
          .toList(),
    );
  }

  Widget groupButtonSelection(List<String> buttons, List<String> selectedList,
      bool showOthers, Function(String) onSelected) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: GroupButton(
        options: GroupButtonOptions(
          buttonWidth: 100,
          unselectedTextStyle: GoogleFonts.poppins(color: black, fontSize: 10),
          selectedTextStyle:
              GoogleFonts.poppins(color: colorWhite, fontSize: 10),
          textAlign: TextAlign.center,
          selectedBorderColor: firstMainColor,
          borderRadius: BorderRadius.circular(20),
        ),
        onSelected: (value, index, isSelected) => onSelected(value),
        isRadio: false,
        buttons: buttons,
      ),
    );
  }

  Widget buildOthersField(TextEditingController controller,
      List<String> selectedList, VoidCallback onAdded) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 16),
          child: Align(
            alignment: AlignmentDirectional.topStart,
            child: Text(
              'Please specify*',
              style: GoogleFonts.poppins(
                  color: black, fontWeight: FontWeight.w500, fontSize: 17),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
          padding: const EdgeInsets.all(8),
          child: TextFormField(
            onFieldSubmitted: (value) {
              setState(() {
                if (value.isNotEmpty) {
                  selectedList.add(value);
                  onAdded();
                  controller.clear();
                }
              });
            },
            controller: controller,
            style: GoogleFonts.poppins(color: black),
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xffF7F8F9),
              border: OutlineInputBorder(),
              hintText: "Specify your choice",
            ),
          ),
        ),
      ],
    );
  }
}
