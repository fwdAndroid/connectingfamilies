import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectingfamilies/screen/main/main_dashboard.dart';
import 'package:connectingfamilies/widget/save_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Controllers for the profile fields
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _otherInterestsController =
      TextEditingController(); // Added for 'Others' in Interests
  TextEditingController _otherNutritionController =
      TextEditingController(); // Added for 'Others' in Nutrition
  TextEditingController _otherParentingController =
      TextEditingController(); // Added for 'Others' in Parenting Style
  TextEditingController _otherSpecialController =
      TextEditingController(); // Added for 'Others' in Special Situation

  // Multi-Select for Interests
  List<String> selectedInterests = [];
  final List<String> availableInterests = [
    'Camping',
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
    "Others", // 'Others' option added here
  ];

  // Profile image
  File? _profileImage;
  String? profileImageUrl;

  // Dropdown values
  String dropDownNutrition = "No Preference";
  String dropDownParenting = "Avoid using electronic devices";
  String dropDownSpecial = "Wheel Chair";

  bool isLoading = false;

  // Fetch current user ID
  String get userId => _auth.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    // Fetch existing profile details when the screen loads
    fetchUserProfile();
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
        selectedInterests = List<String>.from(data['interest'] ?? []);
        dropDownNutrition = data['nutritions'] ?? 'No Preference';
        dropDownParenting =
            data['parentingStyle'] ?? 'Avoid using electronic devices';
        dropDownSpecial = data['specialSituation'] ?? 'Wheel Chair';
        profileImageUrl = data['photo'] ?? null;
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
    if (selectedInterests.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select at least 3 interests')),
      );
      return;
    }

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
        'description': _descriptionController.text,
        'phoneNumber': _phoneController.text,
        'location': _locationController.text,
        'interest': selectedInterests,
        'nutrition': dropDownNutrition == 'Others'
            ? _otherNutritionController.text
            : dropDownNutrition,
        'parentingStyle': dropDownParenting == 'Others'
            ? _otherParentingController.text
            : dropDownParenting,
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

  // Function to show the multi-select dialog
  void _showInterestMultiSelect() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Select Interests (Max 3)'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: availableInterests.map((String interest) {
                    return CheckboxListTile(
                      title: Text(interest),
                      value: selectedInterests.contains(interest),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            // Check if the selection limit (3) is reached
                            if (selectedInterests.length < 3) {
                              selectedInterests.add(interest);
                            } else {
                              selectedInterests[selectedInterests.length - 1] =
                                  interest;
                            }
                          } else {
                            selectedInterests.remove(interest);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profile",
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
                  buildTextField('Phone Number', _phoneController,
                      'Enter your phone number'),
                  // Family description field
                  buildTextField('Family description', _descriptionController,
                      'Enter a brief description',
                      maxLines: 5),
                  // Location field
                  buildTextField(
                      'Location', _locationController, 'Enter your location'),
                  // Interest Multi-Select Button and display selected interests
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Interests (Min 3):',
                            style: TextStyle(fontSize: 16)),
                        Wrap(
                          children: selectedInterests
                              .map((interest) => Chip(
                                    label: Text(interest),
                                  ))
                              .toList(),
                        ),
                        ElevatedButton(
                          onPressed: _showInterestMultiSelect,
                          child: Text('Select Interests'),
                        ),
                      ],
                    ),
                  ),
                  // Nutrition dropdown in a Column
                  buildDropdownColumn('Nutrition', dropDownNutrition, [
                    "No Preference",
                    "Ultra-Processed Foods Free",
                    "Vegan",
                    "Vegetarian",
                    "Gluten Free",
                    "Sugar Free",
                    "Pork free",
                    "Others",
                  ], (String? newValue) {
                    setState(() {
                      dropDownNutrition = newValue!;
                    });
                  }),
                  if (dropDownNutrition == 'Others')
                    buildTextField('Other Nutrition Preference',
                        _otherNutritionController, 'Specify your nutrition'),
                  // Parenting Style dropdown in a Column
                  buildDropdownColumn('Parenting Style', dropDownParenting, [
                    "Avoid using electronic devices",
                    "Free use of electronic devices",
                    "Moderate use of electronic devices",
                    "Respectful Parenting",
                    "A Slap in Time",
                    "Never Slap in Time",
                    "My children have Phone",
                    "Others",
                  ], (String? newValue) {
                    setState(() {
                      dropDownParenting = newValue!;
                    });
                  }),
                  if (dropDownParenting == 'Others')
                    buildTextField(
                        'Other Parenting Style',
                        _otherParentingController,
                        'Specify your parenting style'),
                  // Special Situation dropdown in a Column
                  buildDropdownColumn('Special Situation', dropDownSpecial, [
                    "Wheel chair",
                    "Rare Disease",
                    "Mobility Problems",
                    "Autism",
                    "TDAH",
                    "High Capacities",
                    "Vision Problems",
                    "Others",
                    "Asperger",
                  ], (String? newValue) {
                    setState(() {
                      dropDownSpecial = newValue!;
                    });
                  }),
                  if (dropDownSpecial == 'Others')
                    buildTextField(
                        'Other Special Situation',
                        _otherSpecialController,
                        'Specify your special situation'),
                  SizedBox(height: 20),
                  // Save Button
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SaveButton(
                      title: "Update Profile",
                      onTap: updateUserProfile,
                    ),
                  ),
                  TextButton(onPressed: () {}, child: Text("Delete Account"))
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

  // Helper function to create dropdowns in a column
  Padding buildDropdownColumn(
      String label, String currentValue, List<String> items, onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label:', style: TextStyle(fontSize: 16)),
          DropdownButton<String>(
            isExpanded: true,
            value: currentValue,
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
