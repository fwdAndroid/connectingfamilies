import 'package:connectingfamilies/provider/language_provider.dart';
import 'package:connectingfamilies/screen/auth/login_screen.dart';
import 'package:connectingfamilies/screen/main/pages/webpage.dart';
import 'package:connectingfamilies/uitls/colors.dart';
import 'package:connectingfamilies/uitls/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LogoutWidget extends StatelessWidget {
  const LogoutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SingleChildScrollView(
            child: ListBody(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => Webpage(
                                title: "",
                                url: "https://mamadepluton.com/mamadepluton")));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/m.png",
                      height: 104,
                      width: 104,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => Webpage(
                                  title: "",
                                  url:
                                      "https://mamadepluton.com/mamadepluton")));
                    },
                    child: Center(
                      child: Text(
                        languageProvider.localizedStrings['By @mamadepluton'] ??
                            "By @mamadepluton",
                        style: GoogleFonts.poppins(color: firstMainColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      languageProvider
                              .localizedStrings['Oh No, You are leaving'] ??
                          "Oh No, You are leaving",
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
                      languageProvider.localizedStrings[
                              'Are you sure you want to logout?'] ??
                          "Are you sure you want to logout?",
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
                languageProvider.localizedStrings['No'] ?? "No",
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () async {
                // Sign out from Firebase

                await FirebaseAuth.instance.signOut();

                // Sign out from Google

                // Navigate to login screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (builder) => LoginScreen()),
                );

                // Show snack bar message
                showMessageBar(
                    languageProvider.localizedStrings['Logout Successfully'] ??
                        "Logout Successfully",
                    context);

                // Show snack bar message
              },
              child: Text(
                languageProvider.localizedStrings['Yes'] ?? "Yes",
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
