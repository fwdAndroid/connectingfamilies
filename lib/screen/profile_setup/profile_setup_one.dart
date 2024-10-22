import 'dart:typed_data';

import 'package:connectingfamilies/screen/profile_setup/profile_setup_two.dart';
import 'package:connectingfamilies/service/location_service.dart';
import 'package:connectingfamilies/uitls/colors.dart';
import 'package:connectingfamilies/widget/save_button.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';
import 'package:intl/intl.dart';

class ProfileSetupOne extends StatefulWidget {
  Uint8List image;
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
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController othersController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  String dropdownValue = 'Woman';
  bool showSpecialSituations = false;
  bool showOthersField = false;
  String selectedSpecialSituation = '';

  final LocationService _locationService = LocationService();

  final List<String> items = ['Woman', 'Man', 'Boy', 'Girl'];

  @override
  void initState() {
    super.initState();
    _fetchLocationAndAddress();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildDescriptionSection(),
              buildLocationSection(),
              buildFamilyTypeSection(),
              if (showSpecialSituations) buildSpecialSituationsSection(),
              if (showOthersField) buildOthersField(),
              buildMembersTable(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SaveButton(
                  title: "Next",
                  onTap: () {
                    String finalSpecialSituation = showOthersField
                        ? othersController.text
                        : selectedSpecialSituation;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => ProfileSetupTwo(
                          email: widget.email,
                          location: locationController.text.trim(),
                          password: widget.password,
                          phoneNumber: widget.phoneNumber,
                          specialSituation: finalSpecialSituation,
                          image: widget.image,
                          familyDescription: descriptionController.text.trim(),
                          confirmPassword: widget.confirmPassword,
                          fullName: widget.fullName,
                          dob: dateOfBirthController.text.trim(),
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

  Widget buildDescriptionSection() {
    return buildSectionWithTextField(
      title: 'Family description*',
      hint:
          "Enter a brief description of your family and what you're looking for",
      controller: descriptionController,
      maxLines: 5,
    );
  }

  Widget buildLocationSection() {
    return buildSectionWithTextField(
      title: 'Location*',
      hint: 'Enter Your Address',
      controller: locationController,
    );
  }

  Widget buildFamilyTypeSection() {
    return Column(
      children: [
        buildSectionTitle('Family Type*'),
        Row(
          children: [
            Expanded(
              child: DropdownButton<String>(
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
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: dateOfBirthController,
                readOnly: true,
                onTap: _pickDate,
                style: GoogleFonts.poppins(color: black),
                decoration: InputDecoration(
                  hintText: "Date of Birth",
                  hintStyle: GoogleFonts.poppins(color: black, fontSize: 12),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildSpecialSituationsSection() {
    return Column(
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
          buttons: [
            "Wheel chair",
            "Rare Disease",
            "Mobility Problems",
            "Autism",
            "TDAH",
            "High Capacities",
            "Vision Problems",
            "Others",
            "Asperger",
          ],
        ),
      ],
    );
  }

  Widget buildOthersField() {
    return buildSectionWithTextField(
      title: 'Please specify*',
      hint: 'Specify the situation',
      controller: othersController,
    );
  }

  Widget buildMembersTable() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Table(
        border: TableBorder.all(),
        children: [
          buildTableRow(['Members', 'Age', 'Special Situation', 'Remove'],
              isHeader: true),
          buildTableRow(['Man', '10', 'No', '']),
          buildTableRow(['Boy', '12', 'Yes', '']),
        ],
      ),
    );
  }

  Future<void> _fetchLocationAndAddress() async {
    try {
      Position position = await _locationService.getCurrentLocation();
      String address =
          await _locationService.getAddressFromCoordinates(position);
      setState(() {
        locationController.text = address;
      });
    } catch (e) {
      print('Error fetching location: $e');
    }
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        dateOfBirthController.text =
            DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  TableRow buildTableRow(List<String> cells, {bool isHeader = false}) {
    return TableRow(
      children: cells.map((cell) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: isHeader
              ? Text(cell, style: const TextStyle(fontWeight: FontWeight.bold))
              : cell.isNotEmpty
                  ? TextFormField(
                      initialValue: cell,
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                    )
                  : IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {},
                    ),
        );
      }).toList(),
    );
  }

  Widget buildSectionWithTextField({
    required String title,
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Column(
      children: [
        buildSectionTitle(title),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.all(8),
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            style: GoogleFonts.poppins(color: black),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xffF7F8F9),
              hintText: hint,
              hintStyle: GoogleFonts.poppins(color: black, fontSize: 12),
              border: const OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 16),
      child: Align(
        alignment: AlignmentDirectional.topStart,
        child: Text(
          title,
          style: GoogleFonts.poppins(
            color: black,
            fontWeight: FontWeight.w500,
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}
