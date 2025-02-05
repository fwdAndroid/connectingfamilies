import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectingfamilies/provider/language_provider.dart';
import 'package:connectingfamilies/screen/auth/other/other_user_profile.dart';
import 'package:connectingfamilies/uitls/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  // Method to remove a user from favorites
  Future<void> removeFromFavorites(String userId) async {
    final currentUserDoc =
        FirebaseFirestore.instance.collection("users").doc(currentUserId);

    await currentUserDoc.update({
      "favorite": FieldValue.arrayRemove([userId])
    });

    setState(() {}); // Trigger UI update after removing favorite
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        backgroundColor: colorWhite,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          languageProvider.localizedStrings['Favorite'] ?? "Favorite",
          style: TextStyle(color: black),
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(currentUserId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // Fetch favorite user IDs
            final List<dynamic> favoriteUserIds =
                snapshot.data!.data()?['favorite'] ?? [];

            if (favoriteUserIds.isEmpty) {
              return Center(
                child: Text(
                  "No Favorite Users Found",
                  style: TextStyle(color: black),
                ),
              );
            }

            // Get the users in the favorite list
            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .where(FieldPath.documentId, whereIn: favoriteUserIds)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> userSnapshot) {
                if (!userSnapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final users = userSnapshot.data!.docs;

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (BuildContext context, int index) {
                    final DocumentSnapshot document = users[index];
                    final Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;

                    // Skip current user's own profile from being shown in favorites
                    if (document.id == currentUserId) {
                      return const SizedBox.shrink();
                    }

                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Card(
                        color: colorWhite,
                        child: ListTile(
                          trailing: IconButton(
                            onPressed: () async {
                              await removeFromFavorites(document.id);
                            },
                            icon: Icon(
                              Icons.favorite,
                              color: red, // Red icon indicating it is favorited
                            ),
                          ),
                          onTap: () {
                            if (data['photo'] != null &&
                                data['fullName'] != null &&
                                data['email'] != null) {
                              // Navigate to OtherUserProfile screen with the user's details
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (builder) => OtherUserProfile(
                                    photo: data['photo'],
                                    fullName: data['fullName'],
                                    email: data['email'],

                                    location: data['location'] ??
                                        '', // Provide default value if null
                                    nutritions: data['nutritions'] ??
                                        [], // Provide default value if null
                                    parentingStyle: data['parentingStyle'] ??
                                        '', // Provide default value if null
                                    phoneNumber: data['phoneNumber'] ??
                                        '', // Provide default value if null
                                    familyDescription:
                                        data['familyDescription'] ??
                                            '', // Provide default value if null
                                    uuid: data['uuid'] ??
                                        '', // Provide default value if null
                                    familyType: data['familyType'] ??
                                        '', // Provide default value if null
                                    specialSituation:
                                        data['specialSituation'] ??
                                            '', // Provide default value if null
                                    favorite: data['favorite'] ?? [],
                                    interest: data['interest'] ??
                                        [], // Provide default value if null
                                  ),
                                ),
                              );
                            } else {
                              // Optionally show an error message or handle the null case
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text("User data is incomplete.")),
                              );
                            }
                          },
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(data['photo']),
                            radius: 30,
                          ),
                          title: Text(
                            data['fullName'],
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: black,
                                fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            data['location'],
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
