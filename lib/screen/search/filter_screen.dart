import 'package:connectingfamilies/uitls/colors.dart';
import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    double _currentAge = 25; // Default age

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Search Filters',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                fit: BoxFit.cover,
                "assets/Group 8195.png",
                width: MediaQuery.of(context).size.width,
              ),
              // Distance from Location
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Distance from Location',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Slider(
                value: 50,
                min: 0,
                max: 100,
                activeColor: firstMainColor,
                onChanged: (value) {},
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
              // Recents
              SizedBox(height: screenHeight * 0.02),
              Text(
                'By Type',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildChip('Interest'),
                  _buildChip('Family Type'),
                  _buildChip('Nutrition'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildChip('Family Situation'),
                  _buildChip('Parenting Style'),
                ],
              ),

              Text(
                'Recents',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: screenHeight * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Alina Service'),
                  Icon(Icons.close, color: Colors.grey),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Qasim Suri'),
                  Icon(Icons.close, color: Colors.grey),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Alina Watch'),
                  Icon(Icons.close, color: Colors.grey),
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child:
                      Text('Clear all', style: TextStyle(color: Colors.teal)),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              // Popular Search
              Text(
                'Popular Search',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: screenHeight * 0.01),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  _buildChip('Interest'),
                  _buildChip('Family Situation'),
                  _buildChip('Family Type'),
                  _buildChip('Parenting Style'),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              // Latest View Profile
              Text(
                'Latest View Profile',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: screenHeight * 0.01),
              _buildProfileCard(context, screenHeight),
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

  Widget _buildProfileCard(BuildContext context, double screenHeight) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Image.asset('assets/pic.png' // Replace with your asset path
            ),
        title: Text('Andrew Fries'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Quetta'),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'View Profile',
                  style: TextStyle(color: firstMainColor),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  'Chat Now',
                  style: TextStyle(color: firstMainColor),
                ),
              ],
            )
          ],
        ),
        trailing: Icon(
          Icons.favorite,
          color: red,
        ),
      ),
    );
  }
}
