import 'package:donationapp/screens/home_screen.dart';
import 'package:donationapp/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetPasswordSuccess extends StatefulWidget {
  const ResetPasswordSuccess({Key? key}) : super(key: key);

  @override
  _ResetPasswordSuccessState createState() => _ResetPasswordSuccessState();
}

class _ResetPasswordSuccessState extends State<ResetPasswordSuccess> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Center(
                  child: Image.asset("assets/images/resetsuccess.png"),
                ),
              ),
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                        margin: const EdgeInsets.only(
                          top: 320,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                          child: Text('Your password has been reset!',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              )),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                          child: Text(
                            'Qui ex aute ipsum duis. Incididunt adipisicing voluptate laborum',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                // height: height,
                margin: EdgeInsets.only(top: 340),
                width: width,
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: width * 0.12),
                    SizedBox(height: width * 0.08),
                    SizedBox(
                      height: width * 0.12,
                      width: width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary:
                              const Color.fromRGBO(5, 25, 55, 1), // background
                          onPrimary: Colors.white,
                          minimumSize: Size(width, height * 0.06),
                          maximumSize: Size(width, height * 0.06),
                          // foreground
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const SignInScreen()));
                        },
                        child: const Text(
                          'DONE',
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
    );
  }
}
