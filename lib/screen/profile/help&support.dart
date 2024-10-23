import 'package:connectingfamilies/provider/language_provider.dart';
import 'package:connectingfamilies/uitls/colors.dart';
import 'package:connectingfamilies/widget/save_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HelpSupport extends StatefulWidget {
  const HelpSupport({super.key});

  @override
  State<HelpSupport> createState() => _HelpSupportState();
}

class _HelpSupportState extends State<HelpSupport> {
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context); // Access
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(languageProvider.localizedStrings['Support'] ?? 'Support'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              languageProvider.localizedStrings['Report technical issues'] ??
                  'Report technical issues',
              style: TextStyle(
                fontSize: size.width * 0.045, // Responsive text size
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            // TextField for message input
            TextField(
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'Type your message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 16),
            // Button for adding a screenshot
            ElevatedButton.icon(
              onPressed: () {
                // Handle adding screenshot
              },
              icon: Icon(Icons.add_photo_alternate_outlined),
              label: Text(languageProvider
                      .localizedStrings['Add a Screenshot (optional)'] ??
                  'Add a Screenshot (optional)'),
              style: ElevatedButton.styleFrom(
                foregroundColor: colorWhite,
                backgroundColor: firstMainColor,
                side: BorderSide(color: firstMainColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                minimumSize: Size(double.infinity,
                    size.height * 0.06), // Responsive button size
              ),
            ),
            Spacer(), // Push the send button to the bottom
            // Send button
            SizedBox(
              width: double.infinity,
              height: size.height * 0.08, // Responsive button height
              child: SaveButton(
                onTap: () {
                  // Handle sending message
                },
                title: languageProvider.localizedStrings['Send'] ?? "Send",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
