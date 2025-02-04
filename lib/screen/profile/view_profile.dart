import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectingfamilies/provider/language_provider.dart';
import 'package:connectingfamilies/screen/main/main_dashboard.dart';
import 'package:connectingfamilies/screen/profile/edit_profile.dart';
import 'package:connectingfamilies/uitls/colors.dart';
import 'package:connectingfamilies/widget/delete_widget.dart';
import 'package:connectingfamilies/widget/save_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ViewProfile extends StatefulWidget {
  const ViewProfile({super.key});

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Controllers for the profile fields
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _ageController =
      TextEditingController(); // Added for Age

  TextEditingController _otherSpecialController =
      TextEditingController(); // Added for 'Others' in Special Situation

  // Profile image
  File? _profileImage;
  String? profileImageUrl;

  List<String> interests = [];
  List<String> parenting = [];
  List<String> nutrition = [];
  List<Map<String, dynamic>> familyMembers = [];

  // Dropdown values
  String dropDownSpecial = "Wheel chair";

  bool isLoading = false;

  // Fetch current user ID
  String get userId => _auth.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    // Fetch existing profile details when the screen loads
    fetchUserProfile();
  }

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

  // Fetch user profile data from Firestore
  Future<void> fetchUserProfile() async {
    setState(() {
      isLoading = true;
    });

    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        var data = userDoc.data() as Map<String, dynamic>;
        _nameController.text = data['fullName'] ?? '';
        _descriptionController.text = data['familyDescription'] ?? '';
        _phoneController.text = data['phoneNumber'] ?? '';
        _locationController.text = data['location'] ?? '';
        _ageController.text = data['dateofBirth']?.toString() ?? ''; // Set Age
        dropDownSpecial = data['specialSituation'] ?? 'Wheel Chair';
        profileImageUrl = data['photo'] ?? null;

        // Ensure that interests is properly cast to List<String>
        var interestsData = data['interest'];
        if (interestsData is List) {
          interests = List<String>.from(interestsData);
        } else {
          interests = [];
        }
        // Ensure that Parenting Style is properly cast to List<String>

        var parentingStyle = data['parentingStyle'];
        if (parentingStyle is List) {
          parenting = List<String>.from(parentingStyle);
        } else {
          parenting = [];
        }

        // Ensure that Nutritions Style is properly cast to List<String>

        var bb = data['nutritions'];
        if (bb is List) {
          nutrition = List<String>.from(bb);
        } else {
          nutrition = [];
        }
        //Family Membes
        QuerySnapshot familyMembersSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('uuid',
                isEqualTo: userId) // Filter based on userId or other condition
            .get();

        List<Map<String, dynamic>> fetchedFamilyMembers =
            familyMembersSnapshot.docs.map((doc) {
          return {
            'name': doc['name'] ?? '',
            'specialSituation': doc['specialSituation'] ?? '',
            'age': doc['age'] ?? 0,
            'gender': doc['gender'] ?? '',
          };
        }).toList();

        setState(() {
          familyMembers = fetchedFamilyMembers;
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  // Update user profile in Firestore
  Future<void> updateUserProfile() async {
    setState(() {
      isLoading = true;
    });

    // Upload profile image if selected
    if (_profileImage != null) {
      try {
        String fileName = 'profile_images/$userId.jpg';
        Reference storageRef = _storage.ref().child(fileName);
        await storageRef.putFile(_profileImage!);
        profileImageUrl = await storageRef.getDownloadURL();
      } catch (e) {
        print("Error uploading profile image: $e");
      }
    }

    try {
      await _firestore.collection('users').doc(userId).update({
        'fullName': _nameController.text,
        'familyDescription': _descriptionController.text,
        'phoneNumber': _phoneController.text,
        'location': _locationController.text,
        'age': _ageController.text,
        'specialSituation': dropDownSpecial == 'Others'
            ? _otherSpecialController.text
            : dropDownSpecial,
        'photo': profileImageUrl,
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

    setState(() {
      isLoading = false;
    });
  }

  // Function to select a profile image
  Future<void> _pickProfileImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        _profileImage = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider =
        Provider.of<LanguageProvider>(context); // Access the provider

    return Scaffold(
      appBar: AppBar(
        title: Text(
          languageProvider.localizedStrings['Edit Profile'] ?? "Edit Profile",
          style: GoogleFonts.poppins(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Profile image section
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(
                      child: GestureDetector(
                        onTap: () => _pickProfileImage(ImageSource.gallery),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : (profileImageUrl != null
                                      ? NetworkImage(profileImageUrl!)
                                      : AssetImage(
                                          'assets/default_profile.png'))
                                  as ImageProvider,
                          child:
                              _profileImage == null && profileImageUrl == null
                                  ? Icon(Icons.camera_alt, size: 50)
                                  : null,
                        ),
                      ),
                    ),
                  ),
                  // Name field
                  buildTextField('Name', _nameController, 'Enter your name'),
                  // Phone Number field
                  buildTextField(
                      languageProvider.localizedStrings['Phone Number'] ??
                          'Phone Number',
                      _phoneController,
                      languageProvider
                              .localizedStrings['Enter your phone Number'] ??
                          'Enter your phone number'),
                  // Family description field
                  buildTextField(
                      languageProvider.localizedStrings['Family description'] ??
                          'Family description',
                      _descriptionController,
                      'Enter a brief description',
                      maxLines: 5),
                  // Location field
                  buildTextField(
                      'Location', _locationController, 'Enter your location'),
                  // Age field
                  buildTextField('Age', _ageController, 'Enter your age'),
                  // Gender field

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Interests",
                        style: TextStyle(
                            color: black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      Wrap(
                        children: interests
                            .map((item) => Chip(
                                  label: Text(
                                    item,
                                    style: TextStyle(color: colorWhite),
                                  ),
                                  backgroundColor: firstMainColor,
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Parenting Style",
                        style: TextStyle(
                            color: black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      Wrap(
                        children: parenting
                            .map((item) => Chip(
                                  label: Text(
                                    item,
                                    style: TextStyle(color: colorWhite),
                                  ),
                                  backgroundColor: firstMainColor,
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nutrition",
                        style: TextStyle(
                            color: black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      Wrap(
                        children: nutrition
                            .map((item) => Chip(
                                  label: Text(
                                    item,
                                    style: TextStyle(color: colorWhite),
                                  ),
                                  backgroundColor: firstMainColor,
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: getFamilyMembers(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(
                              child: Text('No family members found.'));
                        }

                        List<Map<String, dynamic>> familyMembers =
                            snapshot.data!;

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
                                            child: Text(
                                                member['age'].toString()))),
                                    TableCell(
                                        child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                                member['specialSituation'] ??
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

                  SizedBox(height: 20),
                  // Save Button
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SaveButton(
                      title: "Update Profile",
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => EditProfile()));
                      },
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        showDialog<void>(
                          context: context,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return DeleteWidget();
                          },
                        );
                      },
                      child: Text("Delete Account"))
                ],
              ),
            ),
    );
  }

  // Helper function to create text fields
  Padding buildTextField(
      String label, TextEditingController controller, String hintText,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: TextField(
        readOnly: true,
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
