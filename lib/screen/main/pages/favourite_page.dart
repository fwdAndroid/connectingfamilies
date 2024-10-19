import 'package:connectingfamilies/screen/auth/other/other_user_profile.dart';
import 'package:connectingfamilies/uitls/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        backgroundColor: colorWhite,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("Favorite "),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Card(
                color: colorWhite,
                child: ListTile(
                  trailing: IconButton(
                    onPressed: () async {},
                    icon: Icon(
                      Icons.favorite,
                      color: red,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => OtherUserProfile()));
                  },
                  leading: Image.asset("assets/logo.png"),
                  title: Text(
                    "Akash basak",
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: black,
                        fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text("London",
                      style: GoogleFonts.poppins(
                        color: favouriteColor,
                        fontSize: 14,
                      )),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
