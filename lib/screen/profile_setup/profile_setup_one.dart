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
  String selectedSpecialSituation = '';
  bool showOthersField = false;

  // Controllers for new member input
  final TextEditingController newMemberNameController = TextEditingController();
  final TextEditingController newMemberAgeController = TextEditingController();

  // Gender list for members
  String memberGender = 'Woman'; // Default gender when adding a new member

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

  DateTime? _selectedDate;

  void _selectDate(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    DateTime initialDate =
        currentDate.subtract(Duration(days: 365 * 40)); // 100 years ago
    DateTime firstDate =
        currentDate.subtract(Duration(days: 365 * 120)); // 120 years ago
    DateTime lastDate = currentDate.subtract(Duration(days: 365)); // 1 year ago

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  String _calculateAge() {
    if (_selectedDate == null) return 'Age not selected';

    DateTime now = DateTime.now();
    int age = now.year - _selectedDate!.year;

    if (now.month < _selectedDate!.month ||
        (now.month == _selectedDate!.month && now.day < _selectedDate!.day)) {
      age--;
    }

    return age.toString();
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Select Birth Date',
                      border: OutlineInputBorder(),
                    ),
                    child: Text(
                      _selectedDate == null
                          ? 'Select a Date'
                          : '${_selectedDate!.toLocal()}'.split(' ')[0],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Age: ${_calculateAge()}'),
              ),
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
                      String address = countryValue +
                          " " +
                          stateValue +
                          " " +
                          cityValue +
                          " " +
                          locationController.text;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (builder) => ProfileSetupTwo(
                            email: widget.email,
                            location: address,
                            password: widget.password,
                            phoneNumber: widget.phoneNumber,
                            specialSituation:
                                selectedSpecialSituation ?? "Wheel Chair",
                            image: widget.image,
                            familyDescription:
                                descriptionController.text.trim(),
                            confirmPassword: widget.confirmPassword,
                            fullName: widget.fullName,
                            dob: _calculateAge(),
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
            isRadio: true,
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
                    memberGender = 'Woman'; // Reset to default gender
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
