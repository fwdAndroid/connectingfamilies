import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectingfamilies/screen/auth/login_screen.dart';
import 'package:connectingfamilies/uitls/colors.dart';
import 'package:connectingfamilies/uitls/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DeleteWidget extends StatelessWidget {
  const DeleteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SingleChildScrollView(
            child: ListBody(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "assets/m.png",
                    height: 104,
                    width: 104,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    "By @mamadepluton",
                    style: GoogleFonts.poppins(color: firstMainColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Oh No, You are Deleting The Account",
                      style: GoogleFonts.workSans(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: black,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Are you sure you want to delete?",
                      style: GoogleFonts.workSans(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      actions: <Widget>[
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "No",
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () async {
                // Sign out from Firebase

                try {
                  // Get the current user
                  User? user = FirebaseAuth.instance.currentUser;

                  // Check if user is signed in
                  if (user != null) {
                    // Step 1: Delete the user data from Firestore
                    final userId = user.uid;
                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(userId)
                        .delete();

                    // Step 2: Delete the user from Firebase Authentication
                    await user.delete();

                    // Optionally, navigate to a sign-in page or show a success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Account deleted successfully")),
                    );

                    // Navigate back to the sign-in page
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (builder) => LoginScreen()));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("No user is currently signed in")),
                    );
                  }
                } catch (e) {
                  // Handle errors (e.g., user not recently logged in, permissions, etc.)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error deleting account: $e")),
                  );
                }

                // Show snack bar message
              },
              child: Text(
                "Yes",
                style: TextStyle(color: colorWhite),
              ),
              style: ElevatedButton.styleFrom(
                fixedSize: Size(137, 50),
                backgroundColor: firstMainColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}