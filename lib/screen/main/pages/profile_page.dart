import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectingfamilies/screen/auth/forgot/forgot_password.dart';
import 'package:connectingfamilies/screen/main/pages/favourite_page.dart';
import 'package:connectingfamilies/screen/main/pages/webpage.dart';
import 'package:connectingfamilies/screen/profile/change_langage.dart';
import 'package:connectingfamilies/screen/profile/edit_profile.dart';
import 'package:connectingfamilies/screen/profile/help&support.dart';
import 'package:connectingfamilies/screen/profile/legal_terms.dart';
import 'package:connectingfamilies/screen/profile/notifcation.dart';
import 'package:connectingfamilies/uitls/colors.dart';
import 'package:connectingfamilies/widget/logout_widget.dart';
import 'package:connectingfamilies/widget/save_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../provider/language_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Column(
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data == null) {
                    return Center(child: Text('No data available'));
                  }
                  var snap = snapshot.data;

                  return Column(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              snap['photo'] != null && snap['photo'].isNotEmpty
                                  ? CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        snap['photo'],
                                      ),
                                      radius: 40,
                                    )
                                  : CircleAvatar(
                                      radius: 40,
                                      child: Icon(Icons.person, size: 60),
                                    ),
                        ),
                      ),
                      Text(
                        snap['fullName'],
                        style: GoogleFonts.poppins(
                            color: black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  );
                }),
            const SizedBox(
              height: 40,
            ),
            ListTile(
              leading: Image.asset(
                "assets/hearts.png",
                width: 40,
                height: 40,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => FavouritePage()));
              },
              trailing: Icon(
                Icons.keyboard_arrow_right,
                color: textColor,
                size: 40,
              ),
              title: Text(
                languageProvider.localizedStrings['Favorite'] ?? "Favorite",
                style: GoogleFonts.poppins(
                  color: black,
                  fontSize: 16,
                ),
              ),
            ),
            ListTile(
              leading: Image.asset(
                "assets/notifications.png",
                width: 40,
                height: 40,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => NotifcationPage()));
              },
              trailing: Icon(
                Icons.keyboard_arrow_right,
                color: textColor,
                size: 40,
              ),
              title: Text(
                languageProvider.localizedStrings['Notifications'] ??
                    "Notifications",
                style: GoogleFonts.poppins(
                  color: black,
                  fontSize: 16,
                ),
              ),
            ),
            ListTile(
              leading: Image.asset(
                "assets/done.png",
                width: 40,
                height: 40,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => ForgotPassword()));
              },
              trailing: Icon(
                Icons.keyboard_arrow_right,
                color: textColor,
                size: 40,
              ),
              title: Text(
                languageProvider.localizedStrings['Forgot Password'] ??
                    "Forgot Password",
                style: GoogleFonts.poppins(
                  color: black,
                  fontSize: 16,
                ),
              ),
            ),
            ListTile(
              leading: Image.asset(
                "assets/chine.png",
                width: 40,
                height: 40,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => ChangeLangage()));
              },
              trailing: Icon(
                Icons.keyboard_arrow_right,
                color: textColor,
                size: 40,
              ),
              title: Text(
                languageProvider.localizedStrings['Language'] ?? "Language",
                style: GoogleFonts.poppins(
                  color: black,
                  fontSize: 16,
                ),
              ),
            ),
            ListTile(
              leading: Image.asset(
                "assets/chine.png",
                width: 40,
                height: 40,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => HelpSupport()));
              },
              trailing: Icon(
                Icons.keyboard_arrow_right,
                color: textColor,
                size: 40,
              ),
              title: Text(
                languageProvider.localizedStrings['Help & Support'] ??
                    "Help & Support",
                style: GoogleFonts.poppins(
                  color: black,
                  fontSize: 16,
                ),
              ),
            ),
            ListTile(
              leading: Image.asset(
                "assets/questions.png",
                width: 40,
                height: 40,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => EditProfile()));
              },
              trailing: Icon(
                Icons.keyboard_arrow_right,
                color: textColor,
                size: 40,
              ),
              title: Text(
                languageProvider.localizedStrings['Edit Profile'] ??
                    "Edit Profile",
                style: GoogleFonts.poppins(
                  color: black,
                  fontSize: 16,
                ),
              ),
            ),
            ListTile(
              leading: Image.asset(
                "assets/person.png",
                width: 40,
                height: 40,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => LegalTermsScreen()));
              },
              trailing: Icon(
                Icons.keyboard_arrow_right,
                color: textColor,
                size: 40,
              ),
              title: Text(
                languageProvider.localizedStrings['Legal Terms'] ??
                    "Legal Terms",
                style: GoogleFonts.poppins(
                  color: black,
                  fontSize: 16,
                ),
              ),
            ),
            ListTile(
              leading: Image.asset(
                "assets/person.png",
                width: 40,
                height: 40,
              ),
              onTap: () {
                shareInviteLink(context);
              },
              trailing: Icon(
                Icons.keyboard_arrow_right,
                color: textColor,
                size: 40,
              ),
              title: Text(
                languageProvider.localizedStrings['Invite Friends'] ??
                    "Invite Friends",
                style: GoogleFonts.poppins(
                  color: black,
                  fontSize: 16,
                ),
              ),
            ),
            ListTile(
              leading: Image.asset(
                "assets/product.png",
                width: 40,
                height: 40,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => Webpage()));
              },
              trailing: Icon(
                Icons.keyboard_arrow_right,
                color: textColor,
                size: 40,
              ),
              title: Text(
                languageProvider.localizedStrings['Parenting Help'] ??
                    "Parenting Help",
                style: GoogleFonts.poppins(
                  color: black,
                  fontSize: 16,
                ),
              ),
            ),
            ListTile(
              leading: Image.asset(
                "assets/person.png",
                width: 40,
                height: 40,
              ),
              onTap: () {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (builder) => FavouritePage()));
              },
              trailing: Icon(
                Icons.keyboard_arrow_right,
                color: textColor,
                size: 40,
              ),
              title: Text(
                languageProvider.localizedStrings['Follow Us On Instagram'] ??
                    "Follow Us On Instagram",
                style: GoogleFonts.poppins(
                  color: black,
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SaveButton(
                  title:
                      languageProvider.localizedStrings['Log out'] ?? "Log out",
                  onTap: () {
                    showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return LogoutWidget();
                      },
                    );
                  }),
            )
          ],
        )),
      ),
    );
  }

  void shareInviteLink(BuildContext context) {
    // Replace 'YOUR_INVITE_LINK' with your actual invite link
    final String inviteLink = 'https://yourapp.com/invite?ref=friend123';

    Share.share(
      'Join our app using my invite link: $inviteLink',
      subject: 'Join us on the app!',
    );
  }
}
