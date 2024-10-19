import 'package:connectingfamilies/uitls/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangeLangage extends StatefulWidget {
  const ChangeLangage({super.key});

  @override
  State<ChangeLangage> createState() => _ChangeLangageState();
}

class _ChangeLangageState extends State<ChangeLangage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        backgroundColor: colorWhite,
        centerTitle: true,
        title: const Text("Language"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 16),
              child: Align(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  'Select Language',
                  style: GoogleFonts.poppins(
                      color: black, fontWeight: FontWeight.w500, fontSize: 17),
                ),
              ),
            ),
            ListTile(
              onTap: () {},
              trailing: Icon(
                Icons.radio_button_checked,
                color: textColor,
                size: 20,
              ),
              title: Text(
                "Spanish",
                style: GoogleFonts.poppins(
                  color: black,
                  fontSize: 16,
                ),
              ),
            ),
            ListTile(
              onTap: () {},
              trailing: Icon(
                Icons.radio_button_checked,
                color: textColor,
                size: 20,
              ),
              title: Text(
                "English",
                style: GoogleFonts.poppins(
                  color: black,
                  fontSize: 16,
                ),
              ),
            ),
            ListTile(
              onTap: () {},
              trailing: Icon(
                Icons.radio_button_checked,
                color: textColor,
                size: 20,
              ),
              title: Text(
                "French",
                style: GoogleFonts.poppins(
                  color: black,
                  fontSize: 16,
                ),
              ),
            ),
            ListTile(
              onTap: () {},
              trailing: Icon(
                Icons.radio_button_checked,
                color: textColor,
                size: 20,
              ),
              title: Text(
                "Portuguese",
                style: GoogleFonts.poppins(
                  color: black,
                  fontSize: 16,
                ),
              ),
            ),
            ListTile(
              onTap: () {},
              trailing: Icon(
                Icons.radio_button_checked,
                color: textColor,
                size: 20,
              ),
              title: Text(
                "Catalan",
                style: GoogleFonts.poppins(
                  color: black,
                  fontSize: 16,
                ),
              ),
            ),
            ListTile(
              onTap: () {},
              trailing: Icon(
                Icons.radio_button_checked,
                color: textColor,
                size: 20,
              ),
              title: Text(
                "Valencian",
                style: GoogleFonts.poppins(
                  color: black,
                  fontSize: 16,
                ),
              ),
            ),
            ListTile(
              onTap: () {},
              trailing: Icon(
                Icons.radio_button_checked,
                color: textColor,
                size: 20,
              ),
              title: Text(
                "Galician",
                style: GoogleFonts.poppins(
                  color: black,
                  fontSize: 16,
                ),
              ),
            ),
            ListTile(
              onTap: () {},
              trailing: Icon(
                Icons.radio_button_checked,
                color: textColor,
                size: 20,
              ),
              title: Text(
                "Basque",
                style: GoogleFonts.poppins(
                  color: black,
                  fontSize: 16,
                ),
              ),
            ),
            ListTile(
              onTap: () {},
              trailing: Icon(
                Icons.radio_button_checked,
                color: textColor,
                size: 20,
              ),
              title: Text(
                "Bable",
                style: GoogleFonts.poppins(
                  color: black,
                  fontSize: 16,
                ),
              ),
            ),
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
