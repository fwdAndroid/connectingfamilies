import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectingfamilies/uitls/colors.dart';
import 'package:connectingfamilies/widget/save_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';

class EditFamily extends StatefulWidget {
  const EditFamily({super.key});

  @override
  State<EditFamily> createState() => _EditFamilyState();
}

class _EditFamilyState extends State<EditFamily> {
  final TextEditingController othersController = TextEditingController();

  String selectedSpecialSituation = '';
  bool showOthersField = false;
  Future<List<Map<String, dynamic>>> getFamilyMembers() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    List familyMembers = userDoc['familyMembers'];

    // Convert each map item to a format you need for the table.
    return familyMembers.map<Map<String, dynamic>>((member) {
      return {
        'name': member['name'],
        'age': member['age'],
        'specialSituation': member['specialSituation'],
        'gender': member['gender'],
      };
    }).toList();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildSpecialSituationsSection(),
            if (showOthersField) buildOthersField(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: getFamilyMembers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No family members found.'));
                  }

                  List<Map<String, dynamic>> familyMembers = snapshot.data!;

                  return SingleChildScrollView(
                    child: Table(
                      border: TableBorder.all(),
                      children: [
                        TableRow(
                          children: [
                            TableCell(
                                child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Name'))),
                            TableCell(
                                child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Age'))),
                            TableCell(
                                child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Special Situation'))),
                            TableCell(
                                child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Gender'))),
                          ],
                        ),
                        for (var member in familyMembers)
                          TableRow(
                            children: [
                              TableCell(
                                  child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(member['name']))),
                              TableCell(
                                  child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(member['age'].toString()))),
                              TableCell(
                                  child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(member['specialSituation'] ??
                                          'N/A'))),
                              TableCell(
                                  child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(member['gender']))),
                            ],
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SaveButton(title: "Update Profile", onTap: () {}),
            )
          ],
        ),
      ),
    );
  }
}
