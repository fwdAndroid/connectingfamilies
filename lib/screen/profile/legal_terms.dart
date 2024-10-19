import 'package:connectingfamilies/widget/save_button.dart';
import 'package:flutter/material.dart';

class LegalTermsScreen extends StatefulWidget {
  @override
  _LegalTermsScreenState createState() => _LegalTermsScreenState();
}

class _LegalTermsScreenState extends State<LegalTermsScreen> {
  bool isAccepted = false;

  void _handleAccept() {
    setState(() {
      isAccepted = true;
    });
    // Perform action when terms are accepted
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('You have accepted the terms.')),
    );
  }

  void _handleDeny() {
    setState(() {
      isAccepted = false;
    });
    // Perform action when terms are denied
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('You have denied the terms.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Legal Terms'),
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
                  // Legal terms text
                  '''Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

                  Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

                  These are the legal terms that you must accept or deny before using our messaging application. Please read carefully, as acceptance implies that you agree to abide by these terms.
                  
                  Note: These terms are subject to change, and it is your responsibility to keep updated. Any modifications will be communicated through our application.''',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Do you accept the terms?',
              style: TextStyle(
                fontSize: size.width * 0.045, // Responsive text size
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
