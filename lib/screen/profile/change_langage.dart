import 'package:connectingfamilies/provider/language_provider.dart';
import 'package:connectingfamilies/uitls/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChangeLangage extends StatefulWidget {
  const ChangeLangage({super.key});

  @override
  State<ChangeLangage> createState() => _ChangeLangageState();
}

class _ChangeLangageState extends State<ChangeLangage> {
  @override
  Widget build(BuildContext context) {
    final languageProvider =
        Provider.of<LanguageProvider>(context); // Access the provider

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
            // ListTile for Spanish
            ListTile(
              onTap: () {
                languageProvider.changeLanguage('es'); // Change to Spanish
                Navigator.pop(context); // Optionally close the language screen
              },
              trailing: Icon(
                languageProvider.currentLanguage == 'es'
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: textColor,
                size: 20,
              ),
              title: Text(
                "Spanish",
                style: GoogleFonts.poppins(color: black, fontSize: 16),
              ),
            ),
            // ListTile for English
            ListTile(
              onTap: () {
                languageProvider.changeLanguage('en'); // Change to English
                Navigator.pop(context);
              },
              trailing: Icon(
                languageProvider.currentLanguage == 'en'
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: textColor,
                size: 20,
              ),
              title: Text(
                "English",
                style: GoogleFonts.poppins(color: black, fontSize: 16),
              ),
            ),
            // ListTile for French
            ListTile(
              onTap: () {
                languageProvider.changeLanguage('fr'); // Change to French
                Navigator.pop(context);
              },
              trailing: Icon(
                languageProvider.currentLanguage == 'fr'
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: textColor,
                size: 20,
              ),
              title: Text(
                "French",
                style: GoogleFonts.poppins(color: black, fontSize: 16),
              ),
            ),
            // ListTile for Portuguese
            ListTile(
              onTap: () {
                languageProvider.changeLanguage('pt'); // Change to Portuguese
                Navigator.pop(context);
              },
              trailing: Icon(
                languageProvider.currentLanguage == 'pt'
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: textColor,
                size: 20,
              ),
              title: Text(
                "Portuguese",
                style: GoogleFonts.poppins(color: black, fontSize: 16),
              ),
            ),
            // ListTile for Catalan
            ListTile(
              onTap: () {
                languageProvider.changeLanguage('ca'); // Change to Catalan
                Navigator.pop(context);
              },
              trailing: Icon(
                languageProvider.currentLanguage == 'ca'
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: textColor,
                size: 20,
              ),
              title: Text(
                "Catalan",
                style: GoogleFonts.poppins(color: black, fontSize: 16),
              ),
            ),
            // ListTile for Valencian
            ListTile(
              onTap: () {
                languageProvider.changeLanguage('val'); // Change to Valencian
                Navigator.pop(context);
              },
              trailing: Icon(
                languageProvider.currentLanguage == 'val'
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: textColor,
                size: 20,
              ),
              title: Text(
                "Valencian",
                style: GoogleFonts.poppins(color: black, fontSize: 16),
              ),
            ),
            // ListTile for Galician
            ListTile(
              onTap: () {
                languageProvider.changeLanguage('gl'); // Change to Galician
                Navigator.pop(context);
              },
              trailing: Icon(
                languageProvider.currentLanguage == 'gl'
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: textColor,
                size: 20,
              ),
              title: Text(
                "Galician",
                style: GoogleFonts.poppins(color: black, fontSize: 16),
              ),
            ),
            // ListTile for Basque
            ListTile(
              onTap: () {
                languageProvider.changeLanguage('eu'); // Change to Basque
                Navigator.pop(context);
              },
              trailing: Icon(
                languageProvider.currentLanguage == 'eu'
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: textColor,
                size: 20,
              ),
              title: Text(
                "Basque",
                style: GoogleFonts.poppins(color: black, fontSize: 16),
              ),
            ),
            // ListTile for Bable
            ListTile(
              onTap: () {
                languageProvider.changeLanguage('ast'); // Change to Bable
                Navigator.pop(context);
              },
              trailing: Icon(
                languageProvider.currentLanguage == 'ast'
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: textColor,
                size: 20,
              ),
              title: Text(
                "Bable",
                style: GoogleFonts.poppins(color: black, fontSize: 16),
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
