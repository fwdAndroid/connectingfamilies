import 'dart:typed_data';

import 'package:connectingfamilies/screen/main/pages/webpage.dart';
import 'package:connectingfamilies/screen/profile_setup/profile_setup_one.dart';
import 'package:connectingfamilies/uitls/colors.dart';
import 'package:connectingfamilies/uitls/image_picker.dart';
import 'package:connectingfamilies/widget/save_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../provider/language_provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _reenterController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController _fullNameController = TextEditingController();
  bool passwordVisible = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  Uint8List? image;

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 16),
              child: Align(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  languageProvider.localizedStrings['Photo'] ?? 'Photo',
                  style: GoogleFonts.poppins(
                      color: black, fontWeight: FontWeight.w500, fontSize: 14),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => selectImage(),
              child: image != null
                  ? CircleAvatar(
                      radius: 59, backgroundImage: MemoryImage(image!))
                  : GestureDetector(
                      onTap: () => selectImage(),
                      child: Image.asset(
                        "assets/photo.png",
                        width: 226,
                        height: 195,
                      ),
                    ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, left: 16),
                  child: Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Text(
                      languageProvider.localizedStrings['Full Name'] ??
                          'Full Name',
                      style: GoogleFonts.poppins(
                          color: black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    controller: _fullNameController,
                    style: GoogleFonts.poppins(color: black),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person,
                          color: iconColor,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: borderColor)),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: borderColor)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: borderColor)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: borderColor)),
                        hintText: languageProvider
                                .localizedStrings['Enter Full Name'] ??
                            "Enter Full Name",
                        hintStyle:
                            GoogleFonts.poppins(color: black, fontSize: 12)),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, left: 16),
                  child: Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Text(
                      languageProvider.localizedStrings['Email'] ?? 'Email',
                      style: GoogleFonts.poppins(
                          color: black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    controller: _emailController,
                    style: GoogleFonts.poppins(color: black),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: iconColor,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: borderColor)),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: borderColor)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: borderColor)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: borderColor)),
                        hintText: languageProvider
                                .localizedStrings['Enter Email Address'] ??
                            "Enter Email Address",
                        hintStyle:
                            GoogleFonts.poppins(color: black, fontSize: 12)),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 16),
                  child: Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Text(
                      languageProvider.localizedStrings['Password'] ??
                          'Password',
                      style: GoogleFonts.poppins(
                          color: black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    obscureText: passwordVisible,
                    controller: _passwordController,
                    style: GoogleFonts.poppins(color: black),
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock,
                          color: iconColor,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: borderColor)),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: borderColor)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: borderColor)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: borderColor)),
                        hintText: languageProvider
                                .localizedStrings['Enter Password'] ??
                            "Enter Password",
                        hintStyle:
                            GoogleFonts.poppins(color: black, fontSize: 12)),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 16),
                  child: Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Text(
                      languageProvider.localizedStrings['Re-enter Password'] ??
                          'Re-enter Password',
                      style: GoogleFonts.poppins(
                          color: black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    obscureText: passwordVisible,
                    controller: _reenterController,
                    style: GoogleFonts.poppins(color: black),
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock,
                          color: iconColor,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: borderColor)),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: borderColor)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: borderColor)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: borderColor)),
                        hintText: languageProvider
                                .localizedStrings['Re-enter Password'] ??
                            "Re-enter Password",
                        hintStyle:
                            GoogleFonts.poppins(color: black, fontSize: 12)),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 16),
                  child: Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Text(
                      languageProvider.localizedStrings['Phone Number'] ??
                          'Phone Number',
                      style: GoogleFonts.poppins(
                          color: black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.poppins(color: black),
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.phone,
                          color: iconColor,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: borderColor)),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: borderColor)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: borderColor)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: borderColor)),
                        hintText:
                            languageProvider.localizedStrings['Phone Number'] ??
                                "Phone Number",
                        hintStyle:
                            GoogleFonts.poppins(color: black, fontSize: 12)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SaveButton(
                  title: "Next",
                  onTap: () async {
                    if (image == null) {
                      showMessageBar(
                          languageProvider
                                  .localizedStrings['Photo is Required'] ??
                              "Photo is Required",
                          context);
                    } else if (_fullNameController.text.isEmpty) {
                      showMessageBar(
                          languageProvider
                                  .localizedStrings['User Name is Required'] ??
                              "User Name is Required",
                          context);
                    } else if (_emailController.text.isEmpty) {
                      showMessageBar(
                          languageProvider
                                  .localizedStrings['Email is Required'] ??
                              "Email is Required",
                          context);
                    } else if (_passwordController.text.isEmpty) {
                      showMessageBar(
                          languageProvider
                                  .localizedStrings['Password is Required'] ??
                              "Password is Required",
                          context);
                    } else if (_reenterController.text.isEmpty) {
                      showMessageBar(
                          languageProvider.localizedStrings[
                                  'Confirm Password is Required'] ??
                              "Confirm Password is Required",
                          context);
                    } else if (phoneController.text.isEmpty) {
                      showMessageBar(
                          languageProvider.localizedStrings[
                                  'Contact Number is Required'] ??
                              "Contact Number is Required ",
                          context);
                    } else {
                      setState(() {
                        isLoading = true;
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => ProfileSetupOne(
                                    image: image!,
                                    phoneNumber: phoneController.text.trim(),
                                    password: _passwordController.text.trim(),
                                    fullName: _fullNameController.text.trim(),
                                    email: _emailController.text.trim(),
                                    confirmPassword:
                                        _reenterController.text.trim(),
                                  )));
                    }
                  }),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => SignupScreen()));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text.rich(TextSpan(
                    text: languageProvider
                            .localizedStrings['Already have an account? '] ??
                        'Already have an account? ',
                    children: <InlineSpan>[
                      TextSpan(
                        text: languageProvider.localizedStrings['Sign In'] ??
                            'Sign In',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: firstMainColor),
                      )
                    ])),
              ),
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
