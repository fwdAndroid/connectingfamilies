import 'dart:io';

import 'package:connectingfamilies/provider/language_provider.dart';
import 'package:connectingfamilies/screen/main/main_dashboard.dart';
import 'package:connectingfamilies/screen/profile/edit_interest.dart';
import 'package:connectingfamilies/screen/profile/edit_nutrition.dart';
import 'package:connectingfamilies/widget/save_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  TextEditingController _ageController =
      TextEditingController(); // Added for Age

  // Profile image
  File? _profileImage;
  String? profileImageUrl;

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
        _ageController.text = data['dateofBirth']?.toString() ?? ''; // Set Age
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

                  SizedBox(height: 20),
                  // Save Button
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SaveButton(
                      title: "Edit Profile",
                      onTap: () {
                        updateUserProfile();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SaveButton(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => EditNutrition()));
                      },
                      title: "Edit Nutritions & Parenting Style",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SaveButton(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => EditInterest()));
                      },
                      title: "Edit Interest",
                    ),
                  )
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
}
