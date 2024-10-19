import 'package:connectingfamilies/screen/profile_setup/profile_setup_two.dart';
import 'package:connectingfamilies/uitls/colors.dart';
import 'package:connectingfamilies/widget/save_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';
import 'package:intl/intl.dart';

class ProfileSetupOne extends StatefulWidget {
  const ProfileSetupOne({super.key});

  @override
  State<ProfileSetupOne> createState() => _ProfileSetupOneState();
}

class _ProfileSetupOneState extends State<ProfileSetupOne> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController othersController =
      TextEditingController(); // Controller for Others text field
  String dropdownvalue = 'Woman';
  bool showSpecialSituations = false; // Boolean to control visibility
  bool showOthersField = false; // Boolean to control visibility of Others field

  // List of items in our dropdown menu
  var items = [
    'Woman',
    'Man',
    'Boy',
    'Girl',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Family Description
              buildDescriptionSection(),

              // Location
              buildLocationSection(),

              // Family Type Dropdown
              buildFamilyTypeSection(),

              // Special Situations Section
              if (showSpecialSituations) buildSpecialSituationsSection(),

              // Others Text Field (conditional)
              if (showOthersField) buildOthersField(),

              // Table
              buildMembersTable(),

              // Save Button
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SaveButton(
                  title: " Next",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => ProfileSetupTwo(),
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 16),
          child: Align(
            alignment: AlignmentDirectional.topStart,
            child: Text(
              'Family description*',
              style: GoogleFonts.poppins(
                color: black,
                fontWeight: FontWeight.w500,
                fontSize: 17,
              ),
            ),
          ),
        ),
        Container(
          height: 155,
          width: 322,
          margin: const EdgeInsets.only(left: 10, right: 10),
          padding: const EdgeInsets.all(8),
          child: TextFormField(
            maxLines: 10,
            controller: descriptionController,
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
              hintText:
                  "Enter a brief description of your family and what are you looking for",
              hintStyle: GoogleFonts.poppins(color: black, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLocationSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 16),
          child: Align(
            alignment: AlignmentDirectional.topStart,
            child: Text(
              'Location*',
              style: GoogleFonts.poppins(
                color: black,
                fontWeight: FontWeight.w500,
                fontSize: 17,
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          padding: const EdgeInsets.all(8),
          child: TextFormField(
            controller: locationController,
            style: GoogleFonts.poppins(color: black),
            decoration: InputDecoration(
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
              hintText: "Enter Your Address",
              hintStyle: GoogleFonts.poppins(color: black, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildFamilyTypeSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 16),
          child: Align(
            alignment: AlignmentDirectional.topStart,
            child: Text(
              'Family Type*',
              style: GoogleFonts.poppins(
                color: black,
                fontWeight: FontWeight.w500,
                fontSize: 17,
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: DropdownButton(
                  isExpanded: true,
                  // Initial Value
                  value: dropdownvalue,
                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),
                  // Array list of items
                  items: items.map((String item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  // After selecting the desired option
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownvalue = newValue!;
                      // Show special situations based on selected value
                      showSpecialSituations = (newValue == 'Man' ||
                          newValue == 'Woman' ||
                          newValue == 'Boy' ||
                          newValue == 'Girl'); // Adjust logic as needed
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(
                            2000), //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2101));

                    if (pickedDate != null) {
                      print(
                          pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      print(
                          formattedDate); //formatted date output using intl package =>  2021-03-16
                      //you can implement different kind of Date Format here according to your requirement

                      setState(() {
                        locationController.text =
                            formattedDate; //set output date to TextField value.
                      });
                    } else {
                      print("Date is not selected");
                    }
                  },
                  controller: locationController,
                  style: GoogleFonts.poppins(color: black),
                  decoration: InputDecoration(
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
                    hintText: "Date of Birth",
                    hintStyle: GoogleFonts.poppins(color: black, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildSpecialSituationsSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 16),
          child: Align(
            alignment: AlignmentDirectional.topStart,
            child: Text(
              'Special Situations*',
              style: GoogleFonts.poppins(
                color: black,
                fontWeight: FontWeight.w500,
                fontSize: 17,
              ),
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
                showOthersField = (value == "Others");
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
    );
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
              hintText: "Specify the situation",
              hintStyle: GoogleFonts.poppins(color: black, fontSize: 12),
            ),
          ),
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
          TableRow(
            children: [
              headerCell('Members'),
              headerCell('Age'),
              headerCell('Special Situation'),
              headerCell('Remove'),
            ],
          ),
          TableRow(
            children: [
              editableCell('Man'),
              editableCell('10'),
              editableCell('No'),
              removeCell(),
            ],
          ),
          TableRow(
            children: [
              editableCell('Boy'),
              editableCell('12'),
              editableCell('Yes'),
              removeCell(),
            ],
          ),
        ],
      ),
    );
  }

  Widget headerCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget editableCell(String initialValue) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget removeCell() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
        onPressed: () {},
        icon: Icon(Icons.delete),
      ),
    );
  }
}
