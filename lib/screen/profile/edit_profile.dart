import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectingfamilies/provider/language_provider.dart';
import 'package:connectingfamilies/screen/main/main_dashboard.dart';
import 'package:connectingfamilies/uitls/colors.dart';
import 'package:connectingfamilies/widget/delete_widget.dart';
import 'package:connectingfamilies/widget/save_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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

  String dropDownSpecial = "Wheel chair";

  bool isLoading = false;
  List<String> selectedNutritions = [];
  List<String> selectedParentingStyles = [];
  final List<String> availableNutritions = [
    "No Preference",
    "Ultra-Processed Foods Free",
    "Vegan",
    "Vegetarian",
    "Gluten Free",
    "Sugar Free",
    "Pork free",
    "Others"
  ];
  final List<String> availableParentingStyles = [
    "Avoid using electronic devices",
    "Free use of electronic devices",
    "Moderate use of electronic devices",
    "Respectful Parenting",
    "A Slap in Time",
    "Never Slap in Time",
    "My children have Phone",
    "Others"
  ];
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
        selectedNutritions = List<String>.from(data['nutritions'] ?? []);
        selectedParentingStyles =
            List<String>.from(data['parentingStyle'] ?? []);
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
        'familyDescription': _descriptionController.text,
        'phoneNumber': _phoneController.text,
        'location': _locationController.text,
        'interest': selectedInterests,
        'nutritions': selectedNutritions,
        'parentingStyle': selectedParentingStyles,
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
                  // Interest Multi-Select Button and display selected interests
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            languageProvider
                                    .localizedStrings['Interests (Min 3):'] ??
                                'Interests (Min 3):',
                            style: TextStyle(fontSize: 16)),
                        Wrap(
                          children: selectedInterests
                              .map((interest) => Chip(
                                    label: Text(interest),
                                  ))
                              .toList(),
                        ),
                        Wrap(
                          spacing: 8,
                          children: availableInterests.map((interest) {
                            final isSelected =
                                selectedInterests.contains(interest);
                            return ChoiceChip(
                              label: Text(interest),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    if (selectedInterests.length < 3) {
                                      selectedInterests.add(interest);
                                    }
                                  } else {
                                    selectedInterests.remove(interest);
                                  }
                                });
                              },
                              selectedColor: firstMainColor,
                              backgroundColor: Colors.grey.shade200,
                              labelStyle: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.black),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  // Nutrition dropdown in a Column
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nutrition:', style: TextStyle(fontSize: 16)),
                        Wrap(
                          children: selectedNutritions
                              .map((nutrition) => Chip(label: Text(nutrition)))
                              .toList(),
                        ),
                        Wrap(
                          spacing: 8,
                          children: availableNutritions.map((nutrition) {
                            final isSelected =
                                selectedNutritions.contains(nutrition);
                            return ChoiceChip(
                              label: Text(nutrition),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    selectedNutritions.add(nutrition);
                                  } else {
                                    selectedNutritions.remove(nutrition);
                                  }
                                });
                              },
                              selectedColor: firstMainColor,
                              backgroundColor: Colors.grey.shade200,
                              labelStyle: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.black),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
// Multi-select for Parenting Style
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Parenting Style:',
                            style: TextStyle(fontSize: 16)),
                        Wrap(
                          children: selectedParentingStyles
                              .map((style) => Chip(label: Text(style)))
                              .toList(),
                        ),
                        Wrap(
                          spacing: 8,
                          children: availableParentingStyles.map((style) {
                            final isSelected =
                                selectedParentingStyles.contains(style);
                            return ChoiceChip(
                              label: Text(style),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    selectedParentingStyles.add(style);
                                  } else {
                                    selectedParentingStyles.remove(style);
                                  }
                                });
                              },
                              selectedColor: firstMainColor,
                              backgroundColor: Colors.grey.shade200,
                              labelStyle: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.black),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

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
