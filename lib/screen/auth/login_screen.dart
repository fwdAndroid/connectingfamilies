import 'package:connectingfamilies/provider/language_provider.dart';
import 'package:connectingfamilies/screen/auth/forgot/forgot_password.dart';
import 'package:connectingfamilies/screen/auth/signup_screen.dart';
import 'package:connectingfamilies/screen/main/main_dashboard.dart';
import 'package:connectingfamilies/screen/main/pages/webpage.dart';
import 'package:connectingfamilies/service/database.dart';
import 'package:connectingfamilies/uitls/colors.dart';
import 'package:connectingfamilies/uitls/image_picker.dart';
import 'package:connectingfamilies/widget/save_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool isChecked = false;
  bool showPassword = false;
  //Password Functions
  void toggleShowPassword() {
    setState(() {
      showPassword = !showPassword; // Toggle the showPassword flag
    });
  }

  bool isLoading = false;
  bool isGoogle = false;

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
                  languageProvider.localizedStrings['language'] ??
                      "Educating emotions with love",
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
                  padding: const EdgeInsets.only(top: 16.0, left: 16),
                  child: Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Text(
                      languageProvider.localizedStrings['Email'] ?? 'Email',
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
                    controller: _emailController,
                    style: GoogleFonts.plusJakartaSans(color: black),
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
                    obscureText: !showPassword,
                    controller: _passwordController,
                    style: GoogleFonts.plusJakartaSans(color: black),
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock,
                          color: iconColor,
                        ),
                        suffixIcon: IconButton(
                          onPressed: toggleShowPassword,
                          icon: showPassword
                              ? Icon(
                                  Icons.visibility_off,
                                  color: iconColor,
                                )
                              : Icon(
                                  Icons.visibility,
                                  color: iconColor,
                                ),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                      ),
                      Text(
                        languageProvider.localizedStrings['Remember Me'] ??
                            'Remember Me',
                        style: GoogleFonts.plusJakartaSans(
                            color: black,
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),
                    ],
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => ForgotPassword()));
                      },
                      child: Text(languageProvider
                              .localizedStrings['Forgot Password'] ??
                          "Forgot Password"))
                ],
              ),
            ),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SaveButton(
                        title: languageProvider.localizedStrings['Login'] ??
                            "Login",
                        onTap: () async {
                          if (_emailController.text.isEmpty ||
                              _passwordController.text.isEmpty) {
                            showMessageBar(
                                languageProvider.localizedStrings[
                                        'Email & Password is Required'] ??
                                    "Email & Password is Required",
                                context);
                          } else {
                            setState(() {
                              isLoading = true;
                            });
                            String result = await DatabaseMethods().loginUpUser(
                              email: _emailController.text.trim(),
                              pass: _passwordController.text.trim(),
                            );
                            if (result == 'success') {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => MainDashboard()),
                              );
                            } else {
                              showMessageBar(result, context);
                            }
                            setState(() {
                              isLoading = false;
                            });
                          }
                        }),
                  ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: SocialLoginButton(
            //     height: 55,
            //     width: 327,
            //     buttonType: SocialLoginButtonType.facebook,
            //     onPressed: () {
            //       Navigator.push(context,
            //           MaterialPageRoute(builder: (builder) => MainDashboard()));
            //     },
            //     borderRadius: 15,
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SocialLoginButton(
                height: 55,
                width: 327,
                buttonType: SocialLoginButtonType.google,
                borderRadius: 15,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (builder) => MainDashboard()));
                },
              ),
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
                            .localizedStrings['Don’t have an account? '] ??
                        'Don’t have an account? ',
                    children: <InlineSpan>[
                      TextSpan(
                        text: 'Sign Up',
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
}
