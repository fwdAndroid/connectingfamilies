import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectingfamilies/service/storage.dart';
import 'package:connectingfamilies/uitls/colors.dart';
import 'package:connectingfamilies/uitls/image_picker.dart';
import 'package:connectingfamilies/widget/save_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../provider/language_provider.dart';

class ReportAccount extends StatefulWidget {
  const ReportAccount({super.key});

  @override
  State<ReportAccount> createState() => _ReportAccountState();
}

class _ReportAccountState extends State<ReportAccount> {
  var uuid = Uuid().v4();

  TextEditingController _messageController = TextEditingController();
  Uint8List? image;
  bool isloading = false; // This will control the loading spinner

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
        title: Text(languageProvider.localizedStrings['Report Account'] ??
            'Report Account'),
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
              languageProvider.localizedStrings[
                      'Report account with inappropriate behavior'] ??
                  'Report account with inappropriate behavior',
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
                hintText:
                    languageProvider.localizedStrings['Type your message'] ??
                        'Type your message',
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
                : isloading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton.icon(
                        onPressed: () {
                          selectImage();
                        },
                        icon: Icon(Icons.add_photo_alternate_outlined),
                        label: Text(languageProvider.localizedStrings[
                                'Add a Screenshot (optional)'] ??
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
            SizedBox(height: 16),
            // Show loading spinner when selecting or uploading the image

            Spacer(), // Push the send button to the bottom
            // Send button
            SizedBox(
              width: double.infinity,
              height: size.height * 0.08, // Responsive button height
              child: SaveButton(
                onTap: () async {
                  if (_messageController.text.isEmpty) {
                    showMessageBar("Text is Required", context);
                  } else {
                    setState(() {
                      isloading =
                          true; // Show the spinner when starting the upload
                    });

                    // Attempt to upload image only if it's selected
                    String photo = image != null
                        ? await StorageMethods()
                            .uploadImageToStorage("childName", image!)
                        : "";

                    // Attempt Firestore upload
                    try {
                      await FirebaseFirestore.instance
                          .collection("report")
                          .doc(uuid)
                          .set({
                        "uuid": uuid,
                        "message": _messageController.text,
                        "image": photo,
                      });

                      // Ensure the widget is still mounted before showing the dialog
                      if (!mounted) return;

                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Complaint Sent"),
                            content: Text("Your complaint has been sent."),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close dialog
                                  Navigator.pop(
                                      context); // Return to previous screen
                                },
                                child: Text("OK"),
                              ),
                            ],
                          );
                        },
                      );
                    } catch (e) {
                      showMessageBar(
                          "Error sending complaint. Please try again.",
                          context);
                    } finally {
                      setState(() {
                        isloading = false; // Hide the spinner after completion
                      });
                    }
                  }
                },
                title: languageProvider.localizedStrings['Send Report'] ??
                    "Send Report",
              ),
            ),
          ],
        ),
      ),
    );
  }

  selectImage() async {
    setState(() {
      isloading = true; // Show spinner while selecting the image
    });
    Uint8List ui = await pickImage(ImageSource.gallery);
    setState(() {
      image = ui;
      isloading = false; // Hide spinner after the image is selected
    });
  }
}
