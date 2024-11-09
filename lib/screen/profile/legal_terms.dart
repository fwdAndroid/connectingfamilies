import 'package:connectingfamilies/provider/language_provider.dart';
import 'package:connectingfamilies/widget/save_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LegalTermsScreen extends StatefulWidget {
  @override
  _LegalTermsScreenState createState() => _LegalTermsScreenState();
}

class _LegalTermsScreenState extends State<LegalTermsScreen> {
  bool isAccepted = false;

  @override
  void initState() {
    super.initState();
    _checkAcceptance();
  }

  // Check if terms are accepted when the screen loads
  Future<void> _checkAcceptance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? accepted = prefs.getBool('termsAccepted');
    if (accepted != null && accepted) {
      // If terms are accepted, allow access
      setState(() {
        isAccepted = true;
      });
    } else {
      // Otherwise, force the user to accept
      setState(() {
        isAccepted = false;
      });
    }
  }

  // Handle acceptance of terms
  Future<void> _handleAccept() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('termsAccepted', true); // Store acceptance
    setState(() {
      isAccepted = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('You have accepted the terms.')),
    );
  }

  // Handle denial of terms
  Future<void> _handleDeny() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('termsAccepted', false); // Store denial
    setState(() {
      isAccepted = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('You have denied the terms. Logging out...')),
    );

    // Perform logout action (for example, Firebase auth logout)
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final size = MediaQuery.of(context).size;

    if (!isAccepted) {
      // If terms are not accepted, prevent the user from interacting further
      return Scaffold(
        appBar: AppBar(
          title: Text(languageProvider.localizedStrings['Legal Terms'] ??
              'Legal Terms'),
          centerTitle: true,
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
            languageProvider.localizedStrings['Legal Terms'] ?? 'Legal Terms'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  '''Lorem ipsum dolor sit amet, consectetur adipiscing elit...''', // Your legal terms
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Do you accept the terms?',
              style: TextStyle(
                fontSize: size.width * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Deny button
                SizedBox(
                  width: 140,
                  child: SaveButton(
                    onTap: _handleDeny,
                    title: 'Deny',
                  ),
                ),
                // Accept button
                SizedBox(
                  width: 140,
                  child: SaveButton(
                    onTap: _handleAccept,
                    title: 'Accept',
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Show a message if terms are accepted or denied
            Center(
              child: Text(
                isAccepted
                    ? 'Thank you for accepting the terms.'
                    : 'Please accept the terms to continue.',
                style: TextStyle(
                  color: isAccepted ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
