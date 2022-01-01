import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

class YourNotificationScreen extends StatefulWidget {
  const YourNotificationScreen({Key? key}) : super(key: key);

  @override
  _YourNotificationScreenState createState() => _YourNotificationScreenState();
}

class _YourNotificationScreenState extends State<YourNotificationScreen> {
  static Stream<QuerySnapshot> _getAcceptedProduct() {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    User? user = _firebaseAuth.currentUser;
    String userdoc = user!.uid;
    final CollectionReference _mainCollection = FirebaseFirestore.instance.collection('Users').doc(userdoc).collection("DONATEDPRODUCTS");

    return _mainCollection.snapshots();
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

  Future<void> _sendData(productId) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    String userdoc = user!.uid;

    await FirebaseFirestore.instance.collection("PRODUCTS").doc(productId).update({
      "isCompleted": "True",
    });
    await FirebaseFirestore.instance.collection("Users").doc(userdoc).collection('DONATEDPRODUCTS').doc(productId).update({
      "isCompleted": "True",
    });

    await FirebaseFirestore.instance.collection("Users").doc(userdoc).collection('PRODUCTS').doc(productId).update({
      "isCompleted": "True",
    }).whenComplete(() {
      Future.delayed(const Duration(seconds: 2), () {
        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(builder: (context) => const HomeScreen()),
        //     (route) => false);
      });
    });
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
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "NOTIFICATIONS",
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
                  stream: _getAcceptedProduct(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.size > 0) {
                      return Container(
                        height: height,
                        child: ListView.separated(
                            itemBuilder: (context, index) {
                              String docId = snapshot.data!.docs[index].id;
                              String itemName = "", mobile = "", acceptedUserName = "", productImage = "", landmark = "", address = "", isCompleted = "", acceptedUserCountry = "", acceptedUserEmail = "";
                              try {
                                itemName = snapshot.data!.docs[index]['itemName'];
                                mobile = snapshot.data!.docs[index]['mobileNumber'];
                                acceptedUserName = snapshot.data!.docs[index]['acceptedUserName'];
                                productImage = snapshot.data!.docs[index]['productUrl'];
                                landmark = snapshot.data!.docs[index]['landmark'];
                                address = snapshot.data!.docs[index]['address'];
                                isCompleted = snapshot.data!.docs[index]['isCompleted'];
                                acceptedUserCountry = snapshot.data!.docs[index]['acceptedUserCountry'] != null ? snapshot.data!.docs[index]['acceptedUserCountry'] : "";
                                acceptedUserEmail = snapshot.data!.docs[index]['acceptedUserEmail'] != null ? snapshot.data!.docs[index]['acceptedUserEmail'] : "";
                              } catch (e) {
                                print(e);
                              }

                              return GestureDetector(
                                onTap: () {
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
                                      Text.rich(TextSpan(text: "Accepted User Name: ", style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: width * 0.035, color: Colors.black), children: [
                                        TextSpan(
                                          text: "$acceptedUserName ",
                                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: width * 0.035, color: Colors.black),
                                        )
                                      ])),
                                      SizedBox(height: width * 0.02),
                                      Text.rich(TextSpan(text: "Email: ", style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: width * 0.035, color: Colors.black), children: [
                                        TextSpan(
                                          text: "$acceptedUserEmail",
                                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: width * 0.035, color: Colors.black),
                                        )
                                      ])),
                                      SizedBox(height: width * 0.02),
                                      Text.rich(TextSpan(text: "Country: ", style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: width * 0.035, color: Colors.black), children: [
                                        TextSpan(
                                          text: "$acceptedUserCountry",
                                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: width * 0.035, color: Colors.black),
                                        )
                                      ])),
                                    ]),

                                    // desc:
                                    //     "Do you want to make a phone call to our support?",
                                    buttons: [],
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
                                          Text(
                                            "$acceptedUserName has accepted your Donation.",
                                            style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: width * 0.030, color: Colors.black),
                                          ),
                                          SizedBox(height: width * 0.01),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  if (isCompleted == "False") {
                                                    _sendData(docId).whenComplete(() {
                                                      setState(() {});
                                                    });
                                                  } else {
                                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Donation is already Completed.")));
                                                  }
                                                },
                                                child: Text(
                                                  isCompleted == "True" ? 'COMPLETED' : 'COMPLETE',
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.green,
                                                ),
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
                      return Padding(padding: EdgeInsets.only(top: height / 4), child: Center(child: Text('No notification available', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))));
                    }
                    return Center(child: const CircularProgressIndicator(color: Colors.black));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Image.asset(
            "assets/images/notification.png",
            height: width * 0.2,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(width: width * 0.04),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. ",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: width * 0.030, color: Colors.black),
              ),
              SizedBox(height: width * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text(
                      'Compare',
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
