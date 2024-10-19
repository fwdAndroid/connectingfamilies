import 'package:connectingfamilies/screen/auth/other/other_user_profile.dart';
import 'package:connectingfamilies/screen/main/pages/profile.dart';
import 'package:connectingfamilies/screen/search/filter_screen.dart';
import 'package:connectingfamilies/uitls/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (builder) => UserProfilePage()));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset("assets/chatimage.png"),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _emailController,
              style: GoogleFonts.plusJakartaSans(color: black),
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: iconColor,
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          // Handle filter action
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => FilterScreen()));
                        },
                        icon: Icon(Icons.filter_list,
                            color: Colors.teal), // Filter icon
                      ),
                      IconButton(
                        onPressed: () {
                          // Handle settings action
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => FilterScreen()));
                        },
                        icon: Icon(Icons.tune,
                            color: black), // Settings/adjust icon
                      ),
                    ],
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: borderColor)),
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: borderColor)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: borderColor)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: borderColor)),
                  hintText: "Search",
                  hintStyle:
                      GoogleFonts.plusJakartaSans(color: black, fontSize: 12)),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: 4, // You can dynamically update this count
              itemBuilder: (context, index) {
                return buildProfileCard();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProfileCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (builder) => OtherUserProfile()));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Color(0xffFFCAF4),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  height: 120,
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      'assets/pic.png', // Replace with your image link
                      height: 120,
                      width: 120,

                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(Icons.favorite, color: Colors.red),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Image.asset(
                    'assets/v.png',
                    height: 30, // Replace with your image link
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Icon(Icons.more_horiz),
            SizedBox(height: 4),
            Text(
              'Jessica Parker',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
