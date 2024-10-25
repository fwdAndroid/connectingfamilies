import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectingfamilies/screen/auth/other/other_user_profile.dart';
import 'package:connectingfamilies/uitls/colors.dart';
import 'package:connectingfamilies/widget/save_button.dart';
import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  double _currentAge = 25;
  double _location = 50; // Default value

  String selectedNutrition = 'No Preference'; // Default values
  String selectedparentingStyle = 'Avoid using electronic devices';
  String selectedSpecialSituation = 'Wheel chair';
  String selectedInterest = 'Camping';

  List<DocumentSnapshot> filteredUsers = []; // Store filtered results

  final List<String> nutritionOptions = [
    "No Preference",
    "Ultra-Processed Foods Free",
    "Vegan",
    "Vegetarian",
    "Gluten Free",
    "Sugar Free",
    "Pork free",
    "Others",
  ];

  final List<String> parentingStyleOptions = [
    "Avoid using electronic devices",
    "Free use of electronic devices",
    "Moderate use of electronic devices",
    "Respectful Parenting",
    "A Slap in Time",
    "Never Slap in Time",
    "My children have Phone",
    "Others",
  ];

  final List<String> specialSituationOptions = [
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

  final List<String> interestOptions = [
    "Camping",
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
    "Others",
  ];

  // Method to get filtered results from Firestore

  // Method to get filtered results from Firestore
  Future<void> getFilteredResults() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Construct the query with selected filters
    Query query = firestore.collection('users');

    // Apply filters only if a value is selected (changed from the default)
    if (selectedNutrition != 'No Preference') {
      query = query.where('nutrition', isEqualTo: selectedNutrition);
      print('Applied Nutrition Filter: $selectedNutrition');
    }

    if (selectedparentingStyle != 'Moderate use of electronic devices') {
      query = query.where('parentingStyle', isEqualTo: selectedparentingStyle);
      print('Applied Parenting Style Filter: $selectedparentingStyle');
    }

    if (selectedSpecialSituation != 'None') {
      query =
          query.where('specialSituation', isEqualTo: selectedSpecialSituation);
      print('Applied Special Situation Filter: $selectedSpecialSituation');
    }

    if (selectedInterest.isNotEmpty) {
      query = query.where('interest', arrayContains: selectedInterest);
      print('Applied Interest Filter: $selectedInterest');
    }

    // Execute the query and handle results
    try {
      QuerySnapshot results = await query.get();
      setState(() {
        filteredUsers = results.docs;
      });

      print('Filtered Users Count: ${filteredUsers.length}');
    } catch (e) {
      print('Error fetching filtered users: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Filters'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Distance from Location',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: screenHeight * 0.01),

              // Location Slider
              Slider(
                value: _location,
                min: 0,
                max: 100,
                divisions: 100,
                label: _location.round().toString(),
                activeColor: firstMainColor,
                onChanged: (double value) {
                  setState(() {
                    _location = value; // Update location value
                  });
                },
              ),
              Text(
                '${_location.round()} km', // Showing rounded value in km
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),

              // Recents
              SizedBox(height: screenHeight * 0.02),
              Text(
                'By Age',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Slider(
                value: _currentAge,
                min: 1,
                max: 100,
                divisions: 99, // Divides the slider into steps
                label: _currentAge.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _currentAge = value;
                  });
                },
              ),
              Text(
                '${_currentAge.round()} Years Old', // Showing rounded value in km
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),

              // Recents
              SizedBox(height: screenHeight * 0.02),
              Text(
                'By Type',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildChip('Interest'),
                  _buildChip('Nutrition'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildChip('Family Situation'),
                  _buildChip('Parenting Style'),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),

              Text(
                'Select Nutrition',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: selectedNutrition,
                items: nutritionOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedNutrition = newValue!;
                  });
                },
              ),
              Text(
                'Select Parenting Style',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: selectedparentingStyle,
                items: parentingStyleOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedparentingStyle = newValue!;
                  });
                },
              ),
              Text(
                'Select Special Situation',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: selectedSpecialSituation,
                items: specialSituationOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedSpecialSituation = newValue!;
                  });
                },
              ),
              Text(
                'Select Interest',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: selectedInterest,
                items: interestOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedInterest = newValue!;
                  });
                },
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: SaveButton(
                    onTap: () async {
                      await getFilteredResults();
                    },
                    title: 'Apply Filters',
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Display filtered results in Card format
              filteredUsers.isNotEmpty
                  ? SizedBox(
                      height: 300,
                      child: ListView.builder(
                        physics:
                            NeverScrollableScrollPhysics(), // Disable ListView scroll inside SingleChildScrollView
                        shrinkWrap:
                            true, // Make ListView take only required height
                        itemCount: filteredUsers.length,
                        itemBuilder: (context, index) {
                          var user = filteredUsers[index];
                          return Card(
                            elevation: 5,
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(user['photo']),
                                  ),
                                  title: Text(
                                    user['fullName'],
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Row(
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (builder) =>
                                                        OtherUserProfile(
                                                          photo: user['photo'],
                                                          favorite:
                                                              user['favorite'],
                                                          email: user['email'],
                                                          specialSituation: user[
                                                              'specialSituation'],
                                                          familyType: user[
                                                              'familyType'],
                                                          fullName:
                                                              user['fullName'],
                                                          location:
                                                              user['location'],
                                                          dateofBirth: user[
                                                              'dateofBirth'],
                                                          interest:
                                                              user['interest'],
                                                          familyDescription: user[
                                                              'familyDescription'],
                                                          nutritions: user[
                                                              'nutritions'],
                                                          parentingStyle: user[
                                                              'parentingStyle'],
                                                          phoneNumber: user[
                                                              'phoneNumber'],
                                                          uuid: user['uuid'],
                                                        )));
                                          },
                                          child: Text('View Profile'))
                                    ],
                                  ),
                                )),
                          );
                        },
                      ),
                    )
                  : Text('No results found based on selected filters'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String label) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(color: Colors.teal),
      ),
      backgroundColor: Color(0xFFE3F4FF),
    );
  }
}
