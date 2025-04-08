import 'dart:io';

import 'package:connectingfamilies/provider/language_provider.dart';
import 'package:connectingfamilies/screen/main/main_dashboard.dart';
import 'package:connectingfamilies/uitls/colors.dart';
import 'package:connectingfamilies/widget/save_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:group_button/group_button.dart';
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
  int? editingIndex;
  TextEditingController _editName = TextEditingController();
  TextEditingController _editAge = TextEditingController();
  TextEditingController _editGender = TextEditingController();
  TextEditingController _editSpecial = TextEditingController();

  // Profile image
  File? _profileImage;
  String? profileImageUrl;

  bool isLoading = false;

  // Fetch current user ID
  String get userId => _auth.currentUser!.uid;

  //Nutritiions
  List<String> selectedNutritionSituations = [];
  TextEditingController _nuController = TextEditingController();
  bool showOthersFieldNu = false;
  List<String> nutrition = [];
  List<String> nutritionsList = [
    "Cycling",
    "Gluten Free",
    "Non Vegan",
    "NSFA",
    "Others",
    "Pork Free",
    "Sugar Free",
    "Ultra-Processed Foods Free",
    "Vegan",
    "Vegetarian"
  ];
  //Parenting Style
  List<String> selectedParentingStyle = [];
  TextEditingController _controller = TextEditingController();
  bool showOthersField = false;
  List<String> parentingStyle = [];
  List<String> parentingList = [
    "A Slap in Time",
    "Avoid using electronic devices",
    "Free use of electronic devices",
    "My children have Phone",
    "Moderate use of electronic devices",
    "Never slap",
    "Others",
    "Respectful Parenting",
  ];

  //Interest
  List<String> selectedInterest = [];
  TextEditingController _ImController = TextEditingController();
  bool showOthersFieldIn = false;
  List<String> interest = [];
  final List<String> interestsList = [
    "Ball Park",
    "Basket",
    "Beach",
    "Board Games",
    "Camping",
    "City Family",
    "Country Side Family",
    "Cultural Activities",
    "Cycling",
    "Going to the Park",
    "Hiking",
    "Laser Games",
    "Others",
    "Outdoor Activities",
    "Peaceful Activities",
    "Pet Walks",
    "Reading (Books)",
    "Scape Rooms",
    "Skating",
    "Soccer",
    "Sports",
    "Take a Walk",
    "Traveling",
  ];
  List<Map<String, dynamic>> familyMembers = [];

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
        var userNutritions = userDoc['nutritions'];
        nutrition =
            userNutritions is List ? List<String>.from(userNutritions) : [];

        selectedNutritionSituations = List.from(nutrition);
        var userParentingStyles = userDoc['parentingStyle'];
        parentingStyle = userParentingStyles is List
            ? List<String>.from(userParentingStyles)
            : [];
        selectedParentingStyle = List.from(parentingStyle);
        var userinterests = userDoc['interest'];
        interest =
            userinterests is List ? List<String>.from(userinterests) : [];
        selectedInterest = List.from(interest);

        var family = userDoc['familyMembers'];
        if (family is List) {
          familyMembers = List<Map<String, dynamic>>.from(family);
        }
        _nameController.text = data['fullName'] ?? '';
        _descriptionController.text = data['familyDescription'] ?? '';
        _phoneController.text = data['phoneNumber'] ?? '';
        _locationController.text = data['location'] ?? '';
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
        'photo': profileImageUrl,
        'nutritions': selectedNutritionSituations,
        'parentingStyle': selectedParentingStyle,
        'interest': selectedInterest,
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
                  sectionHeader("Nutrition"),
                  selectedChips(selectedNutritionSituations),
                  sectionHeader("New Nutrition Values"),
                  groupButtonSelection(nutritionsList,
                      selectedNutritionSituations, showOthersFieldNu, (value) {
                    setState(() {
                      if (value == "Others")
                        showOthersFieldNu = true;
                      else {
                        if (selectedNutritionSituations.contains(value)) {
                          selectedNutritionSituations.remove(value);
                        } else {
                          selectedNutritionSituations.add(value);
                        }
                        showOthersFieldNu = false;
                      }
                    });
                  }),
                  if (showOthersFieldNu)
                    buildOthersField(_nuController, selectedNutritionSituations,
                        () {
                      setState(() => showOthersFieldNu = false);
                    }),
                  sectionHeader("Parenting Style"),
                  selectedChips(selectedParentingStyle),
                  sectionHeader("New Parenting Values"),
                  groupButtonSelection(
                      parentingList, selectedParentingStyle, showOthersField,
                      (value) {
                    setState(() {
                      if (value == "Others")
                        showOthersField = true;
                      else {
                        if (selectedParentingStyle.contains(value)) {
                          selectedParentingStyle.remove(value);
                        } else {
                          selectedParentingStyle.add(value);
                        }
                        showOthersField = false;
                      }
                    });
                  }),
                  if (showOthersField)
                    buildOthersField(_controller, selectedParentingStyle, () {
                      setState(() => showOthersField = false);
                    }),
                  //Interest
                  sectionHeader("interest"),
                  selectedChips(selectedInterest),
                  sectionHeader("New interest Values"),
                  groupButtonSelection(
                      interestsList, selectedInterest, showOthersFieldIn,
                      (value) {
                    setState(() {
                      if (value == "Others")
                        showOthersFieldIn = true;
                      else {
                        if (selectedInterest.contains(value)) {
                          selectedInterest.remove(value);
                        } else {
                          selectedInterest.add(value);
                        }
                        showOthersFieldIn = false;
                      }
                    });
                  }),
                  if (showOthersFieldIn)
                    buildOthersField(_ImController, selectedInterest, () {
                      setState(() => showOthersFieldIn = false);
                    }),
                  if (familyMembers.isNotEmpty) ...[
                    sectionHeader(
                      languageProvider.localizedStrings['Edit Family Member'] ??
                          "Edit Family Member",
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  minWidth: constraints.maxWidth),
                              child: DataTable(
                                border: TableBorder.all(),
                                columnSpacing: 10,
                                headingRowColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.grey[200]!),
                                columns: const [
                                  DataColumn(label: Text("Name")),
                                  DataColumn(label: Text("Age")),
                                  DataColumn(label: Text("Gender")),
                                  DataColumn(
                                      label: Text(
                                    "Special \n Situation",
                                    textAlign: TextAlign.center,
                                  )),
                                  DataColumn(
                                      label: Text("Action")), // NEW COLUMN
                                ],
                                rows: List.generate(familyMembers.length,
                                    (index) {
                                  final member = familyMembers[index];
                                  final isEditing = editingIndex == index;

                                  if (isEditing) {
                                    _editName.text = member['name'] ?? '';
                                    _editAge.text =
                                        member['age']?.toString() ?? '';
                                    _editGender.text = member['gender'] ?? '';
                                    _editSpecial.text =
                                        member['specialSituation'] ?? '';
                                  }

                                  return DataRow(cells: [
                                    DataCell(isEditing
                                        ? TextField(controller: _editName)
                                        : Text(member['name'] ?? '')),
                                    DataCell(isEditing
                                        ? TextField(
                                            controller: _editAge,
                                            keyboardType: TextInputType.number)
                                        : Text(
                                            member['age']?.toString() ?? '')),
                                    DataCell(isEditing
                                        ? TextField(controller: _editGender)
                                        : Text(member['gender'] ?? '')),
                                    DataCell(isEditing
                                        ? TextField(controller: _editSpecial)
                                        : Text(
                                            member['specialSituation'] ?? '')),
                                    DataCell(
                                      IconButton(
                                        icon: Icon(isEditing
                                            ? Icons.check
                                            : Icons.edit),
                                        onPressed: () async {
                                          if (isEditing) {
                                            // Save changes
                                            setState(() {
                                              familyMembers[index] = {
                                                'name': _editName.text,
                                                'age': _editAge.text,
                                                'gender': _editGender.text,
                                                'specialSituation':
                                                    _editSpecial.text,
                                              };
                                              editingIndex = null;
                                            });

                                            // Update in Firestore
                                            await _firestore
                                                .collection('users')
                                                .doc(userId)
                                                .update({
                                              'familyMembers': familyMembers,
                                            });
                                          } else {
                                            setState(() {
                                              editingIndex = index;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ]);
                                }),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],

                  SizedBox(height: 20),

                  // Save Button
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SaveButton(
                      title:
                          languageProvider.localizedStrings['Save Changess'] ??
                              "Save Changes",
                      onTap: () {
                        updateUserProfile();
                      },
                    ),
                  ),
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

  Widget sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 16),
      child: Align(
        alignment: AlignmentDirectional.topStart,
        child: Text(
          title,
          style: GoogleFonts.poppins(
              color: black, fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
    );
  }

  Widget selectedChips(List<String> items) {
    return Wrap(
      children: items
          .map((item) => Chip(
                label: Text(item, style: TextStyle(color: colorWhite)),
                backgroundColor: firstMainColor,
                deleteIcon: Icon(Icons.cancel, color: Colors.white, size: 18),
                onDeleted: () {
                  setState(() {
                    items.remove(item);
                  });
                },
              ))
          .toList(),
    );
  }

  Widget groupButtonSelection(List<String> buttons, List<String> selectedList,
      bool showOthers, Function(String) onSelected) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: GroupButton(
        options: GroupButtonOptions(
          buttonWidth: 100,
          unselectedTextStyle: GoogleFonts.poppins(color: black, fontSize: 10),
          selectedTextStyle:
              GoogleFonts.poppins(color: colorWhite, fontSize: 10),
          textAlign: TextAlign.center,
          selectedBorderColor: firstMainColor,
          borderRadius: BorderRadius.circular(20),
        ),
        onSelected: (value, index, isSelected) => onSelected(value),
        isRadio: false,
        buttons: buttons,
      ),
    );
  }

  Widget buildOthersField(TextEditingController controller,
      List<String> selectedList, VoidCallback onAdded) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 16),
          child: Align(
            alignment: AlignmentDirectional.topStart,
            child: Text(
              'Please specify*',
              style: GoogleFonts.poppins(
                  color: black, fontWeight: FontWeight.w500, fontSize: 17),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
          padding: const EdgeInsets.all(8),
          child: TextFormField(
            onFieldSubmitted: (value) {
              setState(() {
                if (value.isNotEmpty) {
                  selectedList.add(value);
                  onAdded();
                  controller.clear();
                }
              });
            },
            controller: controller,
            style: GoogleFonts.poppins(color: black),
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xffF7F8F9),
              border: OutlineInputBorder(),
              hintText: "Specify your choice",
            ),
          ),
        ),
      ],
    );
  }
}
