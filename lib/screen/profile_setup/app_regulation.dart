import 'package:connectingfamilies/screen/main/main_dashboard.dart';
import 'package:connectingfamilies/uitls/colors.dart';
import 'package:connectingfamilies/widget/save_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppRegulation extends StatefulWidget {
  const AppRegulation({super.key});

  @override
  State<AppRegulation> createState() => _AppRegulationState();
}

class _AppRegulationState extends State<AppRegulation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 10),
                  child: Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Text(
                      'App & Site Regulations',
                      style: GoogleFonts.poppins(
                          color: black,
                          fontWeight: FontWeight.bold,
                          fontSize: 24),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 600,
                    width: 327,
                    child: Text(
                        "Connecting Families respects your privacy.This Privacy Policy explains how Connecting Families collects, uses, and discloses information from and about users '(you' or 'your') of our platform ('Platform'). We are committed to protecting your privacy and ensuring the security of your information. By using the Platform, you agree to the collection, use, and disclosure of information in accordance with this Privacy Policy. We may collect information you provide directly (like account information), information collected automatically (like device data), and information from third parties (like social media logins). We use this information to operate the Platform, provide services, personalize your experience, communicate with you, and improve our offerings. We may share your information with service providers and as required by law. We implement security measures to protect your information, but no website or internet transmission is completely secure. You can access, update, or delete your information through your account settings"),
                  ),
                ),
                SaveButton(
                    title: "Finished",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => MainDashboard()));
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
