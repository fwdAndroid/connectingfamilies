import 'dart:typed_data';

import 'package:connectingfamilies/functions.dart';
import 'package:connectingfamilies/screen/main/pages/webpage.dart';
import 'package:connectingfamilies/screen/profile_setup/profile_setup_one.dart';
import 'package:connectingfamilies/uitls/colors.dart';
import 'package:connectingfamilies/uitls/image_picker.dart';
import 'package:connectingfamilies/widget/save_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

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
  TextEditingController _fullNameController = TextEditingController();
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'US'); // Default country code

  final _formKey = GlobalKey<FormState>();

  bool passwordVisible = false;
  bool isLoading = false;
  bool passwordConfrimVisible = false;

  //Password Toggle Function
  void toggleShowPassword() {
    setState(() {
      passwordVisible = !passwordVisible; // Toggle the showPassword flag
    });
  }

  void toggleShowPasswordConfrim() {
    setState(() {
      passwordConfrimVisible =
          !passwordConfrimVisible; // Toggle the showPassword flag
    });
  }

  Uint8List? image;
  String? phoneNumber;

  String? selectedGender;
  String? normalizedGender;

  final List<String> genderOptions = ['Male', 'Boy', 'Woman', 'Girl'];

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
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
                        color: black,
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Full Name is required';
                        }
                        return null;
                      },
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
                      validator: RegisterFunctions().validateEmail,
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
                      validator: RegisterFunctions().validatePassword,
                      obscureText: !passwordVisible,
                      controller: _passwordController,
                      style: GoogleFonts.poppins(color: black),
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: toggleShowPassword,
                            icon: passwordVisible
                                ? Icon(Icons.visibility_off, color: iconColor)
                                : Icon(Icons.visibility, color: iconColor),
                          ),
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
                        languageProvider
                                .localizedStrings['Re-enter Password'] ??
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
                      validator: _validateConfirmPassword,
                      obscureText: !passwordConfrimVisible,
                      controller: _reenterController,
                      style: GoogleFonts.poppins(color: black),
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: toggleShowPasswordConfrim,
                            icon: passwordConfrimVisible
                                ? Icon(Icons.visibility_off, color: iconColor)
                                : Icon(Icons.visibility, color: iconColor),
                          ),
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
                    child: InternationalPhoneNumberInput(
                      onInputChanged: (PhoneNumber number) {
                        setState(() {
                          phoneNumber = number.phoneNumber;
                        });
                      },
                      onInputValidated: (bool isValid) {
                        if (!isValid) {
                          print("Invalid phone number");
                        }
                      },
                      selectorConfig: SelectorConfig(
                        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                      ),
                      ignoreBlank: false,
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      initialValue: _phoneNumber,
                      textFieldController: TextEditingController(),
                      inputDecoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone, color: iconColor),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: borderColor),
                        ),
                        hintText: "Enter Phone Number",
                        hintStyle:
                            GoogleFonts.poppins(color: black, fontSize: 12),
                      ),
                      inputBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: borderColor),
                      ),
                      selectorTextStyle: GoogleFonts.poppins(color: black),
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
                        languageProvider.localizedStrings['Gender'] ?? 'Gender',
                        style: GoogleFonts.poppins(
                            color: black,
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: borderColor),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        hint: Text(
                          'Select Gender',
                          style:
                              GoogleFonts.poppins(fontSize: 12, color: black),
                        ),
                        value: selectedGender,
                        isExpanded: true,
                        items: genderOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: GoogleFonts.poppins(
                                    fontSize: 14, color: black)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedGender = value;
                          });
                        },
                      ),
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
                            languageProvider.localizedStrings[
                                    'User Name is Required'] ??
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
                      } else {
                        setState(() {
                          isLoading = true;
                        });
                        String normalizedGender = (selectedGender == 'Women' ||
                                selectedGender == 'Girl')
                            ? 'Female'
                            : 'Male';
                        if (_formKey.currentState?.validate() ?? false) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => ProfileSetupOne(
                                        image: image!,
                                        phoneNumber: phoneNumber!,
                                        password:
                                            _passwordController.text.trim(),
                                        fullName:
                                            _fullNameController.text.trim(),
                                        email: _emailController.text.trim(),
                                        confirmPassword:
                                            _reenterController.text.trim(),
                                        genders: normalizedGender!,
                                        // Add this to your next screen constructor
                                      )));
                        }
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
      ),
    );
  }

  selectImage() async {
    Uint8List ui = await pickImage(ImageSource.gallery);
    setState(() {
      image = ui;
    });
  }

  // Confirm Password validation function
  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }
}
