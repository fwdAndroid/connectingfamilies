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
  String selectedParentingStyle = 'Avoid using electronic devices';
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

  // Age range filter
  double _minAge = 0; // Set minimum age
  double _maxAge = 100; // Set maximum age

  // Method to get filtered results from Firestore
  Future<void> getFilteredResults() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Construct the query with selected filters
    Query query = firestore.collection('users');

    // Age range filter (Handling age as a string and comparing it as an integer)
    query = query
        .where('age', isGreaterThanOrEqualTo: _minAge.toString())
        .where('age', isLessThanOrEqualTo: _maxAge.toString());
    print('Applied Age Filter: $_minAge - $_maxAge');

    // Apply nutrition filter
    if (selectedNutritions.isNotEmpty) {
      query = query.where('nutritions', whereIn: selectedNutritions);
      print('Applied Nutrition Filter: $selectedNutritions');
    }

    // Apply parenting style filter
    if (selectedParentingStyles.isNotEmpty) {
      query = query.where('parentingStyle', whereIn: selectedParentingStyles);
      print('Applied Parenting Style Filter: $selectedParentingStyles');
    }

    // Apply special situation filter
    if (selectedSpecialSituations.isNotEmpty) {
      query =
          query.where('specialSituation', whereIn: selectedSpecialSituations);
      print('Applied Special Situation Filter: $selectedSpecialSituations');
    }

    // Apply interest filter
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
              // Location Slider
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Distance from Location',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Slider(
                value: _location,
                min: 0,
                max: 100,
                divisions: 100,
                label: _location.round().toString(),
                activeColor: firstMainColor,
                onChanged: (double value) {
                  setState(() {
                    _location = value;
                  });
                },
              ),
              Text(
                '${_location.round()} km',
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
                divisions: 99,
                label: _currentAge.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _currentAge = value;
                  });
                },
              ),
              Text(
                '${_currentAge.round()} Years Old',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),

              // Nutrition Filter
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

              // Parenting Style Filter
              SizedBox(height: screenHeight * 0.02),
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

              // Special Situation Filter
              SizedBox(height: screenHeight * 0.02),
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

              // Interest Filter
              SizedBox(height: screenHeight * 0.02),
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

              // Apply Button
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

              // Display filtered results
              SizedBox(height: 20),
              filteredUsers.isNotEmpty
                  ? SizedBox(
                      height: 300,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
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
                                  backgroundImage: NetworkImage(user['photo']),
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
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //       builder: (context) =>
                                        //           OtherUserProfile(
                                        //               userId: user['id']),
                                        //     ));
                                      },
                                      child: Text(
                                        'View Profile',
                                        style: TextStyle(color: firstMainColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Center(
                      child: Text(
                        'No results found.',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to handle selectable options
  Widget _buildSelectableContainer(String option, List<String> selectedList) {
    return ChoiceChip(
      label: Text(option),
      selected: selectedList.contains(option),
      onSelected: (selected) {
        setState(() {
          if (selected) {
            selectedList.add(option);
          } else {
            selectedList.remove(option);
          }
        });
      },
    );
  }
}
