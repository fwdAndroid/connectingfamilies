import 'package:connectingfamilies/provider/language_provider.dart';
import 'package:connectingfamilies/screen/auth/forgot/confrim_password.dart';
import 'package:connectingfamilies/screen/main/pages/webpage.dart';
import 'package:connectingfamilies/uitls/colors.dart';
import 'package:connectingfamilies/widget/save_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool isChecked = false;
  bool passwordVisible = false;
  bool isLoading = false;
  bool isGoogle = false;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(
              height: 30,
            ),
            Image.asset(
              "assets/logo.png",
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
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textColor),
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
                      style: GoogleFonts.plusJakartaSans(
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
                    style: GoogleFonts.plusJakartaSans(color: black),
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock,
                          color: iconColor,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(
                              () {
                                passwordVisible = !passwordVisible;
                              },
                            );
                          },
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
                        hintStyle: GoogleFonts.plusJakartaSans(
                            color: black, fontSize: 12)),
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
                      style: GoogleFonts.plusJakartaSans(
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
                    controller: _emailController,
                    style: GoogleFonts.plusJakartaSans(color: black),
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock,
                          color: iconColor,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(
                              () {
                                passwordVisible = !passwordVisible;
                              },
                            );
                          },
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
                        hintStyle: GoogleFonts.plusJakartaSans(
                            color: black, fontSize: 12)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SaveButton(
                  title: languageProvider.localizedStrings['Create Password'] ??
                      "Create Password",
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => ConfrimPassword()));
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
      ),
    );
  }
}
