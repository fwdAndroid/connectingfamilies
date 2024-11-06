import 'dart:typed_data';
import 'package:connectingfamilies/screen/profile_setup/profile_setup_two.dart';
import 'package:connectingfamilies/uitls/colors.dart';
import 'package:connectingfamilies/widget/save_button.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';

class ProfileSetupOne extends StatefulWidget {
  final Uint8List image;
  final String phoneNumber;
  final String confirmPassword;
  final String password;
  final String fullName;
  final String email;

  ProfileSetupOne({
    Key? key,
    required this.confirmPassword,
    required this.email,
    required this.fullName,
    required this.image,
    required this.password,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<ProfileSetupOne> createState() => _ProfileSetupOneState();
}

class _ProfileSetupOneState extends State<ProfileSetupOne> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController othersController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  String dropdownValue = 'Woman';
  bool showSpecialSituations = false;
  bool showOthersField = false;
  String selectedSpecialSituation = '';

  // Controllers for new member input
  final TextEditingController newMemberNameController = TextEditingController();
  final TextEditingController newMemberAgeController = TextEditingController();

  // Manage members data
  List<Member> members = [];
  final List<String> items = ['Woman', 'Man', 'Boy', 'Girl'];

  // Special situations options list
  List<String> specialSituations = [
    "Wheel chair",
    "Rare Disease",
    "Mobility Problems",
    "Autism",
    "TDAH",
    "High Capacities",
    "Vision Problems",
    "Others",
    "Asperger",
  ];

  String countryValue = "";
  String stateValue = "";
  String cityValue = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Family Description",
                        style: GoogleFonts.poppins(
                            color: black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                    ),
                    TextFormField(
                      maxLines: 5,
                      controller: descriptionController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText:
                            "Enter a brief description of your family and what you're looking for",
                        hintStyle:
                            GoogleFonts.poppins(color: black, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Location",
                        style: GoogleFonts.poppins(
                            color: black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                    ),
                    SelectState(
                      onCountryChanged: (value) {
                        setState(() {
                          countryValue = value;
                        });
                      },
                      onStateChanged: (value) {
                        setState(() {
                          stateValue = value;
                        });
                      },
                      onCityChanged: (value) {
                        setState(() {
                          cityValue = value;
                        });
                      },
                    ),
                    TextFormField(
                      controller: locationController,
                      decoration: InputDecoration(
                        hintText: 'Address',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              buildFamilyTypeSection(),
              if (showSpecialSituations) buildSpecialSituationsSection(),
              if (showOthersField) buildOthersField(),
              buildNewMemberSection(),
              buildMembersTable(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SaveButton(
                  title: "Next",
                  onTap: () {
                    String finalSpecialSituation = showOthersField
                        ? othersController.text
                        : selectedSpecialSituation;

                    String address = countryValue ??
                        "" + stateValue ??
                        "" + cityValue ??
                        "" + locationController.text;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => ProfileSetupTwo(
                          email: widget.email,
                          location: address,
                          password: widget.password,
                          phoneNumber: widget.phoneNumber,
                          specialSituation: finalSpecialSituation,
                          image: widget.image,
                          familyDescription: descriptionController.text.trim(),
                          confirmPassword: widget.confirmPassword,
                          fullName: widget.fullName,
                          dob: newMemberAgeController.text.trim(),
                          familyType: dropdownValue,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFamilyTypeSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSectionTitle('Family Type*'),
          DropdownButton<String>(
            isExpanded: true,
            value: dropdownValue,
            icon: const Icon(Icons.keyboard_arrow_down),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
                showSpecialSituations =
                    ['Man', 'Woman', 'Boy', 'Girl'].contains(newValue);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget buildSpecialSituationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle('Special Situations*'),
        GroupButton(
          options: GroupButtonOptions(
            buttonWidth: 100,
            unselectedTextStyle:
                GoogleFonts.poppins(color: black, fontSize: 10),
            selectedTextStyle:
                GoogleFonts.poppins(color: Colors.white, fontSize: 10),
            selectedBorderColor: firstMainColor,
            borderRadius: BorderRadius.circular(20),
          ),
          onSelected: (value, index, isSelected) {
            setState(() {
              if (value == "Others") {
                showOthersField = true;
                selectedSpecialSituation = '';
              } else {
                showOthersField = false;
                selectedSpecialSituation = value.toString();
              }
            });
          },
          isRadio: true,
          buttons: specialSituations,
        ),
      ],
    );
  }

  Widget buildOthersField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Please specify*',
            style: GoogleFonts.poppins(
                color: black, fontWeight: FontWeight.w500, fontSize: 14),
          ),
          TextFormField(
            controller: othersController,
            decoration: InputDecoration(
              hintText: 'Specify the situation',
              border: const OutlineInputBorder(),
            ),
            onFieldSubmitted: (value) {
              setState(() {
                specialSituations.insert(specialSituations.length - 1, value);
                selectedSpecialSituation = value;
                showOthersField = false;
                othersController.clear();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget buildNewMemberSection() {
    return Column(
      children: [
        buildSectionTitle('Add New Member'),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                maxLength: 20,
                controller: newMemberNameController,
                decoration: InputDecoration(
                  hintText: 'Member Name',
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                maxLength: 2,
                controller: newMemberAgeController,
                decoration: InputDecoration(
                  hintText: 'Age',
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                if (newMemberNameController.text.isNotEmpty &&
                    newMemberAgeController.text.isNotEmpty) {
                  setState(() {
                    members.add(Member(
                      name: newMemberNameController.text,
                      age: newMemberAgeController.text,
                      specialSituation: selectedSpecialSituation.isNotEmpty
                          ? selectedSpecialSituation
                          : (showOthersField ? othersController.text : 'No'),
                    ));
                    newMemberNameController.clear();
                    newMemberAgeController.clear();
                    selectedSpecialSituation = '';
                    showOthersField = false;
                    othersController.clear();
                  });
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget buildMembersTable() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Table(
        border: TableBorder.all(),
        children: [
          buildTableRow(['Members', 'Age', 'Special Situation', 'Actions'],
              isHeader: true),
          for (var member in members) buildMemberRow(member),
        ],
      ),
    );
  }

  TableRow buildTableRow(List<String> cells, {bool isHeader = false}) {
    return TableRow(
      children: cells.map((cell) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: isHeader
              ? Text(cell, style: const TextStyle(fontWeight: FontWeight.bold))
              : Text(cell),
        );
      }).toList(),
    );
  }

  TableRow buildMemberRow(Member member) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(member.name),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(member.age),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(member.specialSituation),
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            setState(() {
              // Remove the member from the list
              members.remove(member);
            });
          },
        ),
      ],
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
            color: black, fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }
}

class Member {
  final String name;
  final String age;
  final String specialSituation;

  Member({
    required this.name,
    required this.age,
    required this.specialSituation,
  });
}
