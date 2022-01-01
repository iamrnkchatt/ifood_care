import 'package:donationapp/screens/home_screen.dart';
import 'package:donationapp/screens/resetpassword_screen.dart';
import 'package:donationapp/screens/signin_screen.dart';
import 'package:donationapp/screens/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();

  _resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      const snackBar = SnackBar(content: Text('Reset password link has been sent on your email.'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pop();
    }  catch (e) {
      const snackBar = SnackBar(content: Text('User not found..'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

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
          "FORGOT PASSWORD",
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
                          child: Text('Please enter your email address. You will receive a link to create a new password via email.',
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
                              decoration: const BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    spreadRadius: 0.01,
                                    color: Color.fromRGBO(0, 0, 0, 0.12),
                                    blurRadius: 12.0,
                                  ),
                                ],
                              ),
                              child: Card(
                                elevation: 0,
                                shadowColor: Colors.black38,
                                child: TextFormField(
                                  controller: emailController,
                                  style: GoogleFonts.montserrat(fontSize: width * 0.05, color: Colors.black),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    prefixIcon: Container(
                                      height: height,
                                      margin: EdgeInsets.only(right: width * 0.01),
                                      width: width * 0.1,
                                      decoration: const BoxDecoration(color: Color.fromRGBO(5, 25, 55, 1), borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5))),
                                      child: const Icon(
                                        Icons.mail_outline,
                                        color: Colors.white,
                                      ),
                                    ),
                                    hintText: '  Email Address',
                                    hintStyle: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w300,
                                      fontSize: width * 0.05,
                                      color: Colors.black45,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(width: 1, color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    // focusColor: purple,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.transparent, width: 2),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(width: 1, color: Colors.white),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
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
                            primary: const Color.fromRGBO(5, 25, 55, 1), // background
                            onPrimary: Colors.white,
                            minimumSize: Size(width, height * 0.06),
                            maximumSize: Size(width, height * 0.06),
                            // foreground
                          ),
                          onPressed: () {
                            if (emailController.text.isNotEmpty) {
                              _resetPassword(emailController.text.trim());
                            } else {
                              const snackBar = SnackBar(
                                content: Text('Enter Email...'),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                            /* Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const ResetPasswordScreen()));*/
                          },
                          child: const Text(
                            'SEND',
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
