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

  // Track selected options
  List<String> selectedNutritions = [];
  List<String> selectedParentingStyles = [];
  List<String> selectedSpecialSituations = [];
  List<String> selectedInterests = [];

  // Method to get filtered results from Firestore
  Future<void> getFilteredResults() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Construct the query with selected filters
    Query query = firestore.collection('users');

    // Apply filters only if a value is selected
    if (selectedNutritions.isNotEmpty) {
      query = query.where('nutritions', whereIn: selectedNutritions);
      print('Applied Nutrition Filter: $selectedNutritions');
    }

    if (selectedParentingStyles.isNotEmpty) {
      query = query.where('parentingStyle', whereIn: selectedParentingStyles);
      print('Applied Parenting Style Filter: $selectedParentingStyles');
    }

    if (selectedSpecialSituations.isNotEmpty) {
      query =
          query.where('specialSituation', whereIn: selectedSpecialSituations);
      print('Applied Special Situation Filter: $selectedSpecialSituations');
    }

    if (selectedInterests.isNotEmpty) {
      query = query.where('interest', arrayContainsAny: selectedInterests);
      print('Applied Interest Filter: $selectedInterests');
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

              // Age Slider
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

              // Type selection
              SizedBox(height: screenHeight * 0.02),
              Text(
                'Select Nutrition',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8.0,
                children: nutritionOptions.map((option) {
                  return _buildSelectableContainer(option, selectedNutritions);
                }).toList(),
              ),

              Text(
                'Select Parenting Style',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8.0,
                children: parentingStyleOptions.map((option) {
                  return _buildSelectableContainer(
                      option, selectedParentingStyles);
                }).toList(),
              ),

              Text(
                'Select Special Situation',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8.0,
                children: specialSituationOptions.map((option) {
                  return _buildSelectableContainer(
                      option, selectedSpecialSituations);
                }).toList(),
              ),

              Text(
                'Select Interest',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8.0,
                children: interestOptions.map((option) {
                  return _buildSelectableContainer(option, selectedInterests);
                }).toList(),
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
                                                          phoneNumber: user[
                                                              'phoneNumber'],
                                                          parentingStyle: user[
                                                              'parentingStyle'],
                                                          nutritions: user[
                                                              'nutritions'],
                                                          interest:
                                                              user['interest'],
                                                          dateofBirth: user[
                                                              'dateofBirth'],
                                                          location:
                                                              user['location'],
                                                          specialSituation: user[
                                                              'specialSituation'],
                                                          email: user['email'],
                                                          favorite:
                                                              user['favorite'],
                                                          familyType: user[
                                                              'familyType'],
                                                          familyDescription: user[
                                                              'familyDescription'],
                                                          photo: user['photo'],
                                                          fullName:
                                                              user['fullName'],
                                                          uuid: user['uid'],
                                                        )));
                                          },
                                          child: Text('View Profile')),
                                    ],
                                  ),
                                )),
                          );
                        },
                      ),
                    )
                  : SizedBox(
                      height: 100), // Display empty space if no users found
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectableContainer(
      String option, List<String> selectedOptions) {
    bool isSelected =
        selectedOptions.contains(option); // Check if option is selected

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedOptions.remove(option); // Deselect if already selected
          } else {
            selectedOptions.clear(); // Clear previous selections
            selectedOptions.add(option); // Select the new option
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color:
                    isSelected ? Colors.blue : Colors.grey!), // Optional border
          ),
          child: Text(
            option,
            style: TextStyle(color: isSelected ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}
