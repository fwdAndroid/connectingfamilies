import 'package:connectingfamilies/screen/chat/chat_message.dart';
import 'package:connectingfamilies/uitls/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        backgroundColor: colorWhite,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("Chat"),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Card(
                elevation: 1,
                color: colorWhite,
                child: ListTile(
                  trailing: Text("11:30",
                      style: GoogleFonts.roboto(
                          color: black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => ChatMessages()));
                  },
                  leading: CircleAvatar(
                    backgroundImage: AssetImage("assets/chatimage.png"),
                  ),
                  title: Text(
                    "Silva",
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: black,
                        fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text("I’m not a hoarder but I really...",
                      style: GoogleFonts.roboto(
                          color: favouriteColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
