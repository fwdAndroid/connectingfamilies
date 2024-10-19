import 'package:connectingfamilies/screen/auth/login_screen.dart';
import 'package:connectingfamilies/uitls/colors.dart';
import 'package:connectingfamilies/widget/save_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfrimPassword extends StatefulWidget {
  const ConfrimPassword({super.key});

  @override
  State<ConfrimPassword> createState() => _ConfrimPasswordState();
}

class _ConfrimPasswordState extends State<ConfrimPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(
            height: 30,
          ),
          Image.asset(
            "assets/lock.png",
            height: 104,
            width: 104,
            fit: BoxFit.cover,
          ),
          Column(
            children: [
              Text(
                "Password Created",
                style: GoogleFonts.poppins(
                    fontSize: 24, fontWeight: FontWeight.w600, color: black),
              ),
              Text(
                "Your password is created Successfully",
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColor),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SaveButton(
                title: "Create Password",
                onTap: () async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (builder) => LoginScreen()));
                }),
          ),
          const SizedBox(
            height: 120,
          ),
          Image.asset(
            "assets/m.png",
            height: 104,
            width: 104,
          ),
          Text(
            "By @mamadepluton",
            style: GoogleFonts.poppins(color: firstMainColor),
          )
        ],
      ),
    );
  }
}
