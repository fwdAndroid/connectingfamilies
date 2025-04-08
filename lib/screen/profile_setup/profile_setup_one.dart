import 'dart:typed_data';
import 'package:connectingfamilies/screen/profile_setup/profile_setup_two.dart';
import 'package:connectingfamilies/uitls/colors.dart';
import 'package:connectingfamilies/widget/save_button.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
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
  String dropdownValue = 'Male';
  String selectedSpecialSituation = '';
  bool showOthersField = false;

  // Controllers for new member input
  final TextEditingController newMemberNameController = TextEditingController();
  final TextEditingController newMemberAgeController = TextEditingController();

  // Gender list for members
  String memberGender = 'Male'; // Default gender when adding a new member

  // Manage members data
  List<Member> members = [];
  final List<String> items = ['Male', 'Female'];

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

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

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
                    Text(
                      "Location",
                      style: GoogleFonts.poppins(
                          color: black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    TextFormField(
                      controller: locationController,
                      decoration: InputDecoration(
                        hintText: 'Location',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              buildSpecialSituationsSection(), // Always visible
              if (showOthersField) buildOthersField(),
              buildNewMemberSection(),
              buildMembersTable(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SaveButton(
                  title: "Next",
                  onTap: () {
                    if (locationController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please enter a Address.')));
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (builder) => ProfileSetupTwo(
                            familyMembers: members
                                .map((member) => {
                                      "name": member.name,
                                      "age": member.age,
                                      "gender": member.gender,
                                      "specialSituation":
                                          member.specialSituation
                                    })
                                .toList(),
                            email: widget.email,
                            location: locationController.text,
                            password: widget.password,
                            phoneNumber: widget.phoneNumber,
                            specialSituation:
                                selectedSpecialSituation ?? "Wheel Chair",
                            image: widget.image,
                            familyDescription:
                                descriptionController.text.trim(),
                            confirmPassword: widget.confirmPassword,
                            fullName: widget.fullName,
                            familyType: dropdownValue,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSpecialSituationsSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
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
                  print(
                      'Selected Group Button Value: $selectedSpecialSituation');
                }
              });
            },
            isRadio: false,
            buttons: specialSituations,
          ),
        ],
      ),
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
            const SizedBox(width: 10),
            DropdownButton<String>(
              value: memberGender,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  memberGender = newValue!;
                });
              },
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
                      gender: memberGender,
                    ));
                    newMemberNameController.clear();
                    newMemberAgeController.clear();
                    memberGender = 'Male'; // Reset to default gender
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
          buildTableRow(
              ['Members', 'Age', 'Gender', 'Special Situation', 'Actions'],
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
              ? Text(cell,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 10))
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
          child: Text(member.gender),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(member.specialSituation),
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            setState(() {
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

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return;
      }
    }

    // Get user’s position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Convert coordinates to address
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      String address = "${place.street}, ${place.locality}, ${place.country}";

      setState(() {
        locationController.text = address;
      });
    }
  }
}

class Member {
  final String name;
  final String age;
  final String specialSituation;
  final String gender;

  Member({
    required this.name,
    required this.age,
    required this.specialSituation,
    required this.gender,
  });
}
