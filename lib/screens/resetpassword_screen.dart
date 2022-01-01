import 'package:donationapp/screens/resetpasswordsuccess_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "RESET PASSWORD",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          top: 30,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                          child: Text('Enter new password and confirm.',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                              )),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  // height: height,
                  margin: EdgeInsets.only(top: 50),
                  width: width,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: width * 0.12),
                      Form(
                        //    key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              height: width * 0.15,
                              child: Card(
                                elevation: 0,
                                shadowColor: Colors.white,
                                child: TextFormField(
                                  obscureText: true,
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w300,
                                      fontSize: width * 0.05,
                                      color:
                                          const Color.fromRGBO(5, 25, 55, 1)),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    prefixIcon: Container(
                                      height: height,
                                      decoration: const BoxDecoration(
                                          color: Color.fromRGBO(5, 25, 55, 1),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(5),
                                              bottomLeft: Radius.circular(5))),
                                      margin:
                                          EdgeInsets.only(right: width * 0.01),
                                      width: width * 0.1,
                                      child: const Icon(
                                        Icons.lock,
                                        color: Colors.white,
                                      ),
                                    ),
                                    hintText: '  New Password',
                                    hintStyle: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w300,
                                      fontSize: width * 0.05,
                                      color: Colors.black45,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 0, color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    // focusColor: purple,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.transparent, width: 2),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 0, color: Colors.white),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    suffixIcon: GestureDetector(
                                      child: Icon(Icons.remove_red_eye),
                                    ),
                                  ),
                                ),
                              ),
                              decoration: const BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    spreadRadius: 0.01,
                                    color: Color.fromRGBO(0, 0, 0, 0.12),
                                    blurRadius: 12.0,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: width * 0.15,
                              child: Card(
                                elevation: 0,
                                shadowColor: Colors.white,
                                child: TextFormField(
                                  obscureText: true,
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w300,
                                      fontSize: width * 0.05,
                                      color:
                                          const Color.fromRGBO(5, 25, 55, 1)),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    prefixIcon: Container(
                                      height: height,
                                      decoration: const BoxDecoration(
                                          color: Color.fromRGBO(5, 25, 55, 1),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(5),
                                              bottomLeft: Radius.circular(5))),
                                      margin:
                                          EdgeInsets.only(right: width * 0.01),
                                      width: width * 0.1,
                                      child: const Icon(
                                        Icons.lock_outline,
                                        color: Colors.white,
                                      ),
                                    ),

                                    hintText: '  Confirm Password',
                                    hintStyle: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w300,
                                      fontSize: width * 0.05,
                                      color: Colors.black45,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 0, color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    // focusColor: purple,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.transparent, width: 2),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 0, color: Colors.white),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    suffixIcon: GestureDetector(
                                      child: Icon(Icons.remove_red_eye),
                                    ),
                                  ),
                                ),
                              ),
                              decoration: const BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    spreadRadius: 0.01,
                                    color: Color.fromRGBO(0, 0, 0, 0.12),
                                    blurRadius: 12.0,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: width * 0.08),
                      SizedBox(
                        height: width * 0.12,
                        width: width,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: const Color.fromRGBO(
                                5, 25, 55, 1), // background
                            onPrimary: Colors.white,
                            minimumSize: Size(width, height * 0.06),
                            maximumSize: Size(width, height * 0.06),
                            // foreground
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const ResetPasswordSuccess()));
                          },
                          child: const Text(
                            'CHANGE PASSWORD',
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
