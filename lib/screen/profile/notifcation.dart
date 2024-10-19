import 'package:connectingfamilies/uitls/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotifcationPage extends StatefulWidget {
  const NotifcationPage({super.key});

  @override
  State<NotifcationPage> createState() => _NotifcationPageState();
}

class _NotifcationPageState extends State<NotifcationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        backgroundColor: colorWhite,
        title: const Text("Notification"),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: ListTile(
                trailing: Text("02 Dec",
                    style: GoogleFonts.roboto(
                        color: noteColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500)),
                leading: CircleAvatar(
                  backgroundImage: AssetImage("assets/chatimage.png"),
                ),
                title: Text(
                  "Alene Wiza",
                  style: GoogleFonts.workSans(
                      fontSize: 18, color: black, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                    "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet. ",
                    style: GoogleFonts.workSans(
                        color: noteColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w300)),
              ),
            );
          },
        ),
      ),
    );
  }
}
