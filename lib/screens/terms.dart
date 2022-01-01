import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Color blue = const Color.fromRGBO(5, 25, 55, 1);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Color.fromRGBO(5, 25, 55, 1),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Help",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: width * 0.2),
            Text(
              "Email :",
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: width * 0.045, color: Colors.black),
            ),
            SizedBox(height: width * 0.02),
            Linkify(
              onOpen: (link) async {
                print(link.url);
                if (await canLaunch(link.url)) {
                  await launch(link.url);
                } else {
                  throw 'Could not launch $link';
                }
              },
              text: "ifoodrescue@gmail.com",
              style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: width * 0.045, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
