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
  bool isloading = false; // This will control the loading spinner

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
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
                fontSize: size.width * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
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
            image != null
                ? Center(
                    child: GestureDetector(
                      onTap: () {
                        selectImage();
                      },
                      child: CircleAvatar(
                        radius: 59,
                        backgroundImage: MemoryImage(image!),
                      ),
                    ),
                  )
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
                          minimumSize:
                              Size(double.infinity, size.height * 0.06),
                        ),
                      ),
            SizedBox(height: 16),
            // Show a loading spinner when uploading or selecting an image
            Spacer(),
            SizedBox(
              width: double.infinity,
              height: size.height * 0.08,
              child: SaveButton(
                onTap: () async {
                  if (_messageController.text.isEmpty) {
                    showMessageBar("Text is Required", context);
                  } else {
                    setState(() {
                      isloading =
                          true; // Show the spinner when starting the upload
                    });

                    String photo = image != null
                        ? await StorageMethods()
                            .uploadImageToStorage("childName", image!)
                        : "";

                    await FirebaseFirestore.instance
                        .collection("help")
                        .doc(uuid)
                        .set({
                      "uuid": uuid,
                      "message": _messageController.text,
                      "image": photo,
                    });

                    setState(() {
                      isloading = false; // Hide the spinner after completion
                    });

                    // Show the dialog box
                    if (!mounted)
                      return; // Ensure the widget is still in the tree
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Help & Support"),
                          content: Text("Your query has been sent."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Close dialog
                                Navigator.pop(
                                    context); // Return to the previous screen
                              },
                              child: Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
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
    setState(() {
      isloading = true; // Show spinner while selecting the image
    });
    Uint8List ui = await pickImage(ImageSource.gallery);
    setState(() {
      image = ui;
      isloading = false; // Hide spinner after selecting the image
    });
  }
}
