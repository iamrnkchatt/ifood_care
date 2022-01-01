import 'package:donationapp/Services/auth_provider.dart';
import 'package:donationapp/screens/home_screen.dart';
import 'package:donationapp/screens/signin_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/Resource/Strings.dart';
import 'package:flutter_pw_validator/Utilities/ConditionsHelper.dart';
import 'package:flutter_pw_validator/Utilities/Validator.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  static final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cPasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  String uppercasetPattern = '^(.*?[A-Z]){1,}';
  String numericPattern = '^(.*?[0-9]){1,}';
  String specialPattern = r"^(.*?[$&+,\:;/=?@#|'<>.^*()_%!-]){1,}";
  bool _tickValue = true;
  bool isValidPassword = false;
  bool isLoading = false;

  @override
  void initState() {
    _countryController.text = "india";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                      margin: const EdgeInsets.only(
                        top: 80,
                      ),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 3.0, color: Color.fromRGBO(5, 25, 55, 1)),
                        ),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                        child: Text('SIGN - UP',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            )),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                // height: height,
                margin: const EdgeInsets.only(top: 100),
                width: width,
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: width * 0.12),
                    Form(
                      key: _formKey,
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
                                controller: _nameController,
                                style: GoogleFonts.poppins(fontSize: width * 0.05, color: Colors.black),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  prefixIcon: Container(
                                    height: height,
                                    margin: EdgeInsets.only(right: width * 0.01),
                                    width: width * 0.1,
                                    decoration: const BoxDecoration(color: Color.fromRGBO(5, 25, 55, 1), borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5))),
                                    child: const Icon(
                                      Icons.person_outline,
                                      color: Colors.white,
                                    ),
                                  ),
                                  hintText: '  Full Name',
                                  hintStyle: GoogleFonts.poppins(
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
                          SizedBox(height: width * 0.04),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            height: width * 0.13,
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 0.01,
                                  color: Color.fromRGBO(0, 0, 0, 0.12),
                                  blurRadius: 12.0,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    // margin: EdgeInsets.only(right: width * 0.01),
                                    height: width * 0.12,
                                    width: width * 0.12,
                                    decoration: const BoxDecoration(color: Color.fromRGBO(5, 25, 55, 1), borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5))),
                                    child: const Icon(Icons.access_alarm, color: Colors.white),
                                  ),
                                ),
                                Expanded(
                                  flex: 7,
                                  child: Container(
                                      decoration: const BoxDecoration(boxShadow: [
                                        BoxShadow(spreadRadius: 0.01, color: Color.fromRGBO(0, 0, 0, 0.12), blurRadius: 12.0),
                                      ], color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5))),
                                      alignment: Alignment.centerLeft,
                                      height: height * 0.08,
                                      width: width * 0.5,
                                      child: CountryListPick(
                                        appBar: AppBar(
                                          backgroundColor: Colors.grey.shade300,
                                          title: Text(
                                            'Select Country',
                                            style: GoogleFonts.nunito(color: Colors.black),
                                          ),
                                          iconTheme: const IconThemeData(color: Color.fromRGBO(5, 25, 55, 1)),
                                        ),
                                        pickerBuilder: (context, countryCode) {
                                          return Padding(
                                            padding: const EdgeInsets.only(left: 8, right: 16),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  countryCode!.name!,
                                                  style: GoogleFonts.poppins(fontSize: width * 0.05, color: Colors.black),
                                                ),
                                                Icon(Icons.keyboard_arrow_down, color: Colors.black,size: 28,)
                                              ],
                                            ),
                                          );
                                        },
                                        theme: CountryTheme(
                                            alphabetTextColor: Colors.black26,
                                            alphabetSelectedBackgroundColor: const Color.fromRGBO(5, 25, 55, 1),
                                            labelColor: const Color.fromRGBO(5, 25, 55, 1),
                                            alphabetSelectedTextColor: const Color.fromRGBO(5, 25, 55, 1),
                                            isShowTitle: true,
                                            isDownIcon: true,
                                            isShowCode: false,
                                            isShowFlag: false),
                                        initialSelection: 'in',
                                        onChanged: (CountryCode? code) {
                                          setState(() {
                                            _countryController.text = code!.name!;
                                          });
                                          // print(code.name);
                                        },
                                      )),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: width * 0.04),
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
                                controller: _emailController,
                                style: GoogleFonts.poppins(fontSize: width * 0.05, color: Colors.black),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  prefixIcon: Container(
                                    height: height,
                                    margin: EdgeInsets.only(right: width * 0.01),
                                    width: width * 0.1,
                                    decoration: const BoxDecoration(color: Color.fromRGBO(5, 25, 55, 1), borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5))),
                                    child: const Icon(
                                      Icons.email_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                  hintText: '  Email Id',
                                  hintStyle: GoogleFonts.poppins(
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
                          SizedBox(height: width * 0.04),
                          Container(
                            height: width * 0.15,
                            child: Card(
                              elevation: 0,
                              shadowColor: Colors.white,
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                style: GoogleFonts.poppins(fontWeight: FontWeight.w300, fontSize: width * 0.05, color: const Color.fromRGBO(5, 25, 55, 1)),
                                onChanged: (txt) {
                                  bool hasMinLength, hasMinUppercaseChar, hasMinNumericChar, hasMinSpecialChar;
                                  hasMinLength = _passwordController.text.trim().length >= 6;
                                  hasMinUppercaseChar = _passwordController.text.contains(RegExp(uppercasetPattern));
                                  hasMinNumericChar = _passwordController.text.contains(RegExp(numericPattern));
                                  hasMinSpecialChar = _passwordController.text.contains(RegExp(specialPattern));

                                  setState(() {
                                    isValidPassword = hasMinLength && hasMinUppercaseChar && hasMinNumericChar && hasMinSpecialChar;
                                  });
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  prefixIcon: Container(
                                    height: height,
                                    decoration: const BoxDecoration(color: Color.fromRGBO(5, 25, 55, 1), borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5))),
                                    margin: EdgeInsets.only(right: width * 0.01),
                                    width: width * 0.1,
                                    child: const Icon(
                                      Icons.lock,
                                      color: Colors.white,
                                    ),
                                  ),

                                  hintText: '  Password',
                                  hintStyle: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w300,
                                    fontSize: width * 0.05,
                                    color: Colors.black45,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(width: 0, color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  // focusColor: purple,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.transparent, width: 2),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(width: 0, color: Colors.white),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                            ),
                            decoration: const BoxDecoration(boxShadow: [BoxShadow(spreadRadius: 0.01, color: Color.fromRGBO(0, 0, 0, 0.12), blurRadius: 12.0)]),
                          ),
                          if (_passwordController.text.length > 0)
                            Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: isValidPassword
                                  ? Text(
                                      "Strong password",
                                      style: GoogleFonts.poppins(fontSize: width * 0.04, color: Colors.green),
                                    )
                                  : Text(
                                      "Weak password",
                                      style: GoogleFonts.poppins(fontSize: width * 0.04, color: Colors.red),
                                    ),
                            ),
                          SizedBox(height: width * 0.04),
                          Container(
                            height: width * 0.15,
                            child: Card(
                              elevation: 0,
                              shadowColor: Colors.white,
                              child: TextFormField(
                                controller: _cPasswordController,
                                obscureText: true,
                                style: GoogleFonts.poppins(fontWeight: FontWeight.w300, fontSize: width * 0.05, color: const Color.fromRGBO(5, 25, 55, 1)),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  prefixIcon: Container(
                                    height: height,
                                    decoration: const BoxDecoration(color: Color.fromRGBO(5, 25, 55, 1), borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5))),
                                    margin: EdgeInsets.only(right: width * 0.01),
                                    width: width * 0.1,
                                    child: const Icon(
                                      Icons.lock_open_outlined,
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
                                    borderSide: const BorderSide(width: 0, color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  // focusColor: purple,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.transparent, width: 2),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(width: 0, color: Colors.white),
                                    borderRadius: BorderRadius.circular(5),
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
                    CheckboxListTile(
                      activeColor: const Color.fromRGBO(5, 25, 55, 1),
                      title: const Text("I am 18+"),
                      value: _tickValue,
                      onChanged: (value) {
                        setState(() {
                          _tickValue = value!;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
                    ),
                    SizedBox(height: width * 0.04),
                    GestureDetector(
                      onTap: () {},
                      child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(text: 'By signing up, you agree to our  ', style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black), children: [
                            TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    const url = "https://www.envirocare.nz/terms";
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      throw 'Could not launch https://www.envirocare.nz/terms}';
                                    }
                                  },
                                text: ' term and condition',
                                style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12, color: Colors.blue)),
                            TextSpan(text: ' and', style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black)),
                            TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    const url = "https://www.envirocare.nz/privacy-policy";
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      throw 'Could not launch https://www.envirocare.nz/terms}';
                                    }
                                  },
                                text: ' privacy policy',
                                style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12, color: Colors.blue)),
                          ])),
                    ),
                    SizedBox(height: width * 0.08),
                    SizedBox(
                      height: width * 0.12,
                      width: width,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_tickValue) {
                            if (_emailController.text.isEmpty || _nameController.text.isEmpty || _passwordController.text.isEmpty || _countryController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Fill all the fields.")));
                            } else if (!isValidPassword) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter valid password.")));
                            } else if (_passwordController.text != _cPasswordController.text) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password & confirm password dose not match.")));
                            } else {
                              setState(() {
                                isLoading = true;
                              });
                              AuthClass()
                                  .createUser(
                                _emailController.text.trim(),
                                _passwordController.text.trim(),
                                _nameController.text.trim(),
                                _countryController.text.trim(),
                              )
                                  .then((value) {
                                if (value == "Created") {
                                  setState(() {
                                    isLoading = false;
                                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);
                                  });
                                } else {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
                                }
                              });
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: _tickValue ? Color.fromRGBO(5, 25, 55, 1) : Color.fromRGBO(5, 25, 55, 0.5), // background
                          onPrimary: Colors.white,
                          minimumSize: Size(width, height * 0.06),
                          maximumSize: Size(width, height * 0.06),
                          // foreground
                        ),
                        child: const Text(
                          'SIGN-UP',
                          style: TextStyle(
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: width * 0.05),
                    GestureDetector(
                      onTap: () {},
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignInScreen()));
                        },
                        child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(text: 'Already a Member?', style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black), children: [
                              TextSpan(
                                text: ' Login',
                                style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12, color: Colors.black),
                              ),
                            ])),
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
