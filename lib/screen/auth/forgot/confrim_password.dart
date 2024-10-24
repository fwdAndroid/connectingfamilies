import 'package:connectingfamilies/provider/language_provider.dart';
import 'package:connectingfamilies/screen/auth/login_screen.dart';
import 'package:connectingfamilies/screen/main/pages/webpage.dart';
import 'package:connectingfamilies/uitls/colors.dart';
import 'package:connectingfamilies/widget/save_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ConfrimPassword extends StatefulWidget {
  const ConfrimPassword({super.key});

  @override
  State<ConfrimPassword> createState() => _ConfrimPasswordState();
}

class _ConfrimPasswordState extends State<ConfrimPassword> {
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(
            height: 30,
          ),
          Image.asset(
            "assets/lock.png",
            height: 104,
            width: 104,
            fit: BoxFit.cover,
          ),
          Column(
            children: [
              Text(
                languageProvider.localizedStrings['Create Password'] ??
                    "Create Password",
                style: GoogleFonts.poppins(
                    fontSize: 24, fontWeight: FontWeight.w600, color: black),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    languageProvider.localizedStrings[
                            'A link is send in your email id so you easily recreate your password successfully'] ??
                        "A link is send in your email id so you easily recreate your password successfully",
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SaveButton(
                title: languageProvider.localizedStrings['Back To Login'] ??
                    "Back To Login",
                onTap: () async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (builder) => LoginScreen()));
                }),
          ),
          const SizedBox(
            height: 120,
          ),
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
                            url: "https://mamadepluton.com/mamadepluton")));
              },
              child: Text(
                languageProvider.localizedStrings['By @mamadepluton'] ??
                    "By @mamadepluton",
                style: GoogleFonts.poppins(color: firstMainColor),
              ),
            ),
          )
        ],
      ),
    );
  }
}
