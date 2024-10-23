import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectingfamilies/provider/language_provider.dart';
import 'package:connectingfamilies/service/storage.dart';
import 'package:connectingfamilies/uitls/colors.dart';
import 'package:connectingfamilies/uitls/image_picker.dart';
import 'package:connectingfamilies/widget/save_button.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class HelpSupport extends StatefulWidget {
  const HelpSupport({super.key});

  @override
  State<HelpSupport> createState() => _HelpSupportState();
}

class _HelpSupportState extends State<HelpSupport> {
  TextEditingController _messageController = TextEditingController();
  Uint8List? image;
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context); // Access
    final size = MediaQuery.of(context).size;
    var uuid = Uuid().v4();

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
              controller: _messageController,
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
            image != null
                ? Center(
                    child: GestureDetector(
                        onTap: () {
                          selectImage();
                        },
                        child: CircleAvatar(
                            radius: 59, backgroundImage: MemoryImage(image!))))
                : ElevatedButton.icon(
                    onPressed: () {
                      selectImage();
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
                onTap: () async {
                  // Handle sending message
                  if (_messageController.text.isEmpty) {
                    showMessageBar("Text is Required", context);
                  } else {
                    setState(() {
                      isloading = true;
                    });
                    String photo = await StorageMethods()
                        .uploadImageToStorage("childName", image!);
                    FirebaseFirestore.instance
                        .collection("help")
                        .doc(uuid)
                        .set({
                      "uuid": uuid,
                      "message": _messageController.text,
                      "image": photo ?? "",
                    });
                    setState(() {
                      isloading = false;
                    });
                    showMessageBar("Report is Send", context);
                  }
                },
                title: languageProvider.localizedStrings['Send'] ?? "Send",
              ),
            ),
          ],
        ),
      ),
    );
  }

  selectImage() async {
    Uint8List ui = await pickImage(ImageSource.gallery);
    setState(() {
      image = ui;
    });
  }
}
