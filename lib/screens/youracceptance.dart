import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donationapp/screens/addproduct_screen.dart';
import 'package:donationapp/screens/editproduct_screen.dart';
import 'package:donationapp/screens/home_screen.dart';
import 'package:donationapp/screens/productdetails_screen.dart';
import 'package:donationapp/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

class YourAcceptanceScreen extends StatefulWidget {
  const YourAcceptanceScreen({Key? key}) : super(key: key);

  @override
  _YourAcceptanceScreenState createState() => _YourAcceptanceScreenState();
}

class _YourAcceptanceScreenState extends State<YourAcceptanceScreen> {
  static Stream<QuerySnapshot> _getProduct() {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    User? user = _firebaseAuth.currentUser;
    String userdoc = user!.uid;
    final CollectionReference _mainCollection = FirebaseFirestore.instance.collection('Users').doc(userdoc).collection("ACCEPTEDPRODUCTS");

    return _mainCollection.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false),
        ),
        title: const Text(
          "YOUR ACCEPTANCE",
          style: TextStyle(color: Colors.black),
        ),
        actions: [Padding(padding: const EdgeInsets.only(right: 8), child: Image.asset("assets/images/logo.png", height: 50, width: 50))],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: width * 0.04),
              StreamBuilder(
                  stream: _getProduct(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    } else if (snapshot.hasData && snapshot.data != null&& snapshot.data!.size>0) {
                      return Container(
                        height: height,
                        child: ListView.separated(
                            itemBuilder: (context, index) {
                              String docId = snapshot.data!.docs[index].id;

                              String itemName = snapshot.data!.docs[index]['itemName'];
                              String mobile = snapshot.data!.docs[index]['mobileNumber'];
                              String categories = snapshot.data!.docs[index]['categories'];
                              String productImage = snapshot.data!.docs[index]['productUrl'];
                              String donerName = snapshot.data!.docs[index]['name'];
                              String landmark = snapshot.data!.docs[index]['landmark'];
                              String address = snapshot.data!.docs[index]['address'];
                              String time = snapshot.data!.docs[index]['disAppearTime'];
                              String description = snapshot.data!.docs[index]['description'];
                              String isAvailable = snapshot.data!.docs[index]['isAvailable'];
                              String isAccepted = snapshot.data!.docs[index]['isAccepted'];

                              return InkWell(
                                onTap: (){
                                  Alert(
                                    context: context,
                                    type: AlertType.none,
                                    // title: "RFLUTTER ALERT",
                                    content: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Center(
                                        child: Container(
                                          height: width * 0.2,
                                          width: width * 0.2,
                                          child: Image.network(
                                            productImage,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: width * 0.02),
                                      Text.rich(TextSpan(text: "Product Name: ", style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: width * 0.035, color: Colors.black), children: [
                                        TextSpan(
                                          text: "$itemName ",
                                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: width * 0.035, color: Colors.black),
                                        )
                                      ])),
                                      SizedBox(height: width * 0.02),
                                      Text.rich(TextSpan(text: "Donner User Name: ", style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: width * 0.035, color: Colors.black), children: [
                                        TextSpan(
                                          text: "$donerName ",
                                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: width * 0.035, color: Colors.black),
                                        )
                                      ])),
                                      SizedBox(height: width * 0.02),
                                      Text.rich(TextSpan(text: "Address: ", style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: width * 0.035, color: Colors.black), children: [
                                        TextSpan(
                                          text: "$address, $landmark ",
                                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: width * 0.035, color: Colors.black),
                                        )
                                      ])),
                                    ]),

                                    // desc:
                                    //     "Do you want to make a phone call to our support?",
                                    buttons: [
                                      DialogButton(
                                        child: const Text(
                                          "Call Now",
                                          style: TextStyle(color: Colors.white, fontSize: 18),
                                        ),
                                        onPressed: () {
                                          _makePhoneCall(mobile, true);
                                        },
                                        color: Colors.green,
                                      ),
                                    ],
                                  ).show();
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Image.network(
                                        productImage,
                                        height: width * 0.2,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(width: width * 0.04),
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 4),
                                            child: Text(
                                              itemName,
                                              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: width * 0.045, color: Colors.black),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 4),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  categories,
                                                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: width * 0.04, color: Colors.grey),
                                                ),
                                                Text(
                                                  "",
                                                  style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: width * 0.035, color: Colors.green),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(Icons.phone_android, size: 16),
                                              SizedBox(width: width * 0.02),
                                              Text(
                                                mobile,
                                                style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: width * 0.035, color: Colors.black),
                                              ),
                                              SizedBox(width: width * 0.04),
                                              Text(
                                                donerName,
                                                style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: width * 0.035, color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(height: width * 0.02);
                            },
                            itemCount: snapshot.data!.docs.length),
                      );
                    } else if (snapshot.data != null && snapshot.data!.size == 0) {
                      return Padding(padding: EdgeInsets.only(top: height / 4), child: Center(child: Text('No acceptance available.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))));
                    }
                    return Center(child: const CircularProgressIndicator(color: Colors.black));
                  })
            ],
          ),
        ),
      ),
    );
  }


  Future<void> _makePhoneCall(String contact, bool direct) async {
    if (direct == true) {
      bool? res = await FlutterPhoneDirectCaller.callNumber(contact);
    } else {
      String telScheme = 'tel:$contact';

      if (await canLaunch(telScheme)) {
        await launch(telScheme);
      } else {
        throw 'Could not launch $telScheme';
      }
    }
  }
}
