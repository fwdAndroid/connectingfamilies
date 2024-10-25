import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectingfamilies/screen/auth/other/other_user_profile.dart';
import 'package:connectingfamilies/screen/main/pages/profile.dart';
import 'package:connectingfamilies/screen/search/filter_screen.dart';
import 'package:connectingfamilies/uitls/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../../../provider/language_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _emailController = TextEditingController();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      setState(() {
        _searchText = _emailController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return Center(
                      child: Text(languageProvider
                              .localizedStrings['No data available'] ??
                          'No data available'));
                }
                var snap = snapshot.data;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => UserProfilePage(
                                  interest: snap['interest'] ??
                                      ['Others', 'Others', 'Others'],
                                  email: snap['email'] ?? "",
                                  familyType: snap['familyType'] ?? "",
                                  location: snap['location'] ?? "",
                                  dateofBirth: snap['dateofBirth'] ?? "",
                                  specialSituation:
                                      snap['specialSituation'] ?? "",
                                  parentingStyle: snap['parentingStyle'] ?? "",
                                  nutritions: snap['nutritions'] ?? "",
                                  phoneNumber: snap['phoneNumber'] ?? "",
                                  uuid: snap['uuid'] ?? "",
                                  fullName: snap['fullName'] ?? "",
                                  photo: snap['photo'] ?? "",
                                  familyDescription:
                                      snap['familyDescription'] ?? "",
                                )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(snap['photo']),
                    ),
                  ),
                );
              })
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
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: iconColor,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      // Handle filter action
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => FilterScreen()));
                    },
                    icon: Icon(Icons.filter_list, color: Colors.teal),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: borderColor)),
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: borderColor)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: borderColor)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: borderColor)),
                  hintText:
                      languageProvider.localizedStrings['Search'] ?? "Search",
                  hintStyle:
                      GoogleFonts.plusJakartaSans(color: black, fontSize: 12)),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .where("uuid",
                        isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        "No User Available",
                        style: TextStyle(color: black),
                      ),
                    );
                  }

                  // Filter the users based on search input
                  final filteredDocs = snapshot.data!.docs.where((doc) {
                    final fullName = (doc.data()
                        as Map<String, dynamic>)['fullName'] as String;
                    return fullName.toLowerCase().contains(
                        _searchText.toLowerCase()); // Convert both to lowercase
                  }).toList();

                  if (filteredDocs.isEmpty) {
                    return Center(
                      child: Text(
                        "No Results Found",
                        style: TextStyle(color: black),
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          MediaQuery.of(context).size.width > 600 ? 4 : 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: filteredDocs.length,
                    itemBuilder: (context, index) {
                      final Map<String, dynamic> data =
                          filteredDocs[index].data() as Map<String, dynamic>;
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => OtherUserProfile(
                                        interest: data['interest'] ??
                                            ['Others', 'Others', 'Others'],
                                        email: data['email'] ?? "",
                                        familyType: data['familyType'] ?? "",
                                        favorite: data['favorite'] ?? [],
                                        location: data['location'] ?? "",
                                        dateofBirth: data['dateofBirth'] ?? "",
                                        specialSituation:
                                            data['specialSituation'] ?? "",
                                        parentingStyle:
                                            data['parentingStyle'] ?? "",
                                        nutritions: data['nutritions'] ?? "",
                                        phoneNumber: data['phoneNumber'] ?? "",
                                        uuid: data['uuid'] ?? "",
                                        fullName: data['fullName'] ?? "",
                                        photo: data['photo'] ?? "",
                                        familyDescription:
                                            data['familyDescription'] ?? "",
                                      )));
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
                                      child: Image.network(
                                        data['photo'],
                                        height: 120,
                                        width: 120,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child:
                                        Icon(Icons.favorite, color: Colors.red),
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    right: 8,
                                    child: Image.asset(
                                      'assets/v.png',
                                      height: 30,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Icon(Icons.more_horiz),
                              SizedBox(height: 4),
                              Text(
                                data['fullName'],
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
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
