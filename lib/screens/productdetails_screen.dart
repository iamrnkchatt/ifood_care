import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_count_down/date_count_down.dart';
import 'package:donationapp/screens/editproduct_screen.dart';
import 'package:donationapp/screens/home_screen.dart';
import 'package:donationapp/screens/youracceptance.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

class ProductDetailsScreen extends StatefulWidget {
  final String productImage;
  final String productName;
  final String time;
  final String donerName;
  final String address;
  final String landmark;
  final String productId;
  final String decription;
  final String mobileNumber;
  final String categories;
  final bool myFood;
  final String userId;
  final String donatedUserName;
  final String donatedUserEmail;
  final String donatedUserCountry;
  final double latitude;
  final double longitude;
  final DateTime dateTime;

  const ProductDetailsScreen(
      {Key? key,
      required this.productImage,
      required this.productName,
      required this.dateTime,
      required this.time,
      required this.donerName,
      required this.landmark,
      required this.productId,
      required this.decription,
      required this.categories,
      required this.mobileNumber,
      required this.donatedUserName,
      required this.donatedUserEmail,
      required this.donatedUserCountry,
      required this.myFood,
      required this.userId,
      required this.latitude,
      required this.longitude,
      required this.address})
      : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  Completer<GoogleMapController> _controller = Completer();
  final double long = 0;
  final double lati = 0;

  @override
  void initState() {
    super.initState();
  }

  static const CameraPosition _kLake = CameraPosition(bearing: 192.8334901395799, target: LatLng(37.43296265331129, -122.08832357078792), tilt: 59.440717697143555, zoom: 19.151926040649414);

  bool isLoading = false;

  Future<void> _sendData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    String userdoc = user!.uid;
    print(widget.productId);
    setState(() {
      isLoading == true;
    });
    await FirebaseFirestore.instance.collection("Users").doc(widget.userId).collection('PRODUCTS').doc(widget.productId).set({
      "acceptedUser": userdoc,
      "acceptedUserName": widget.donatedUserName,
      "userId": widget.userId,
      "itemName": widget.productName,
      "mobileNumber": widget.mobileNumber,
      "productUrl": widget.productImage,
      "address": widget.address,
      "landmark": widget.landmark,
      "categories": widget.categories,
      "description": widget.decription,
      "disAppearTime": widget.time,
      "name": widget.donerName,
      "isAvailable": "False",
      "isAccepted": "True",
      "isCompleted": "False",
    });
    await FirebaseFirestore.instance.collection('PRODUCTS').doc(widget.productId).set({
      "userId": widget.userId,
      "acceptedUserName": widget.donatedUserName,
      "acceptedUser": userdoc,
      "itemName": widget.productName,
      "mobileNumber": widget.mobileNumber,
      "productUrl": widget.productImage,
      "address": widget.address,
      "landmark": widget.landmark,
      "categories": widget.categories,
      "description": widget.decription,
      "disAppearTime": widget.time,
      "name": widget.donerName,
      "isAvailable": "False",
      "isAccepted": "True",
      "isCompleted": "False",
    });
    await FirebaseFirestore.instance.collection("Users").doc(widget.userId).collection('DONATEDPRODUCTS').doc(widget.productId).set({
      "userId": widget.userId,
      "acceptedUserName": widget.donatedUserName,
      "acceptedUserEmail": widget.donatedUserEmail,
      "acceptedUserCountry": widget.donatedUserCountry,
      "donatedUserId": userdoc,
      "itemName": widget.productName,
      "mobileNumber": widget.mobileNumber,
      "productUrl": widget.productImage,
      "address": widget.address,
      "landmark": widget.landmark,
      "categories": widget.categories,
      "description": widget.decription,
      "disAppearTime": widget.time,
      "name": widget.donerName,
      "isAvailable": "False",
      "isAccepted": "True",
      "isCompleted": "False",
    });

    await FirebaseFirestore.instance.collection("Users").doc(userdoc).collection('ACCEPTEDPRODUCTS').doc(widget.productId).set({
      "donerUserId": widget.userId,
      "acceptedUserName": widget.donatedUserName,
      "userId": userdoc,
      "itemName": widget.productName,
      "mobileNumber": widget.mobileNumber,
      "productUrl": widget.productImage,
      "address": widget.address,
      "landmark": widget.landmark,
      "categories": widget.categories,
      "description": widget.decription,
      "disAppearTime": widget.time,
      "name": widget.donerName,
      "isAvailable": "False",
      "isAccepted": "True",
      "isCompleted": "False",
    }).whenComplete(() {
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const YourAcceptanceScreen()), (route) => false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: const Icon(Icons.arrow_back, color: Colors.white),
          onTap: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Color.fromRGBO(5, 25, 55, 1),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "PRODUCT DETAILS",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          InkWell(
            child: Padding(
              padding: const EdgeInsets.only(right: 16,left: 16),
              child: Icon(
                Icons.share,
              ),
            ),
            onTap: urlFileShare,
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: const Color.fromRGBO(5, 25, 55, 1),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                    child: Center(
                      child: Container(
                        height: width * 0.2,
                        width: width * 0.2,
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(5, 25, 55, 1),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(widget.productImage),
                              fit: BoxFit.cover,
                            )),
                        child: null,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: width,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Card(
                        child: Container(
                          width: width,
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                  text: widget.productName,
                                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 20, color: Colors.black),
                                  children: [
                                    TextSpan(
                                      text: '\n Donated By ${widget.donerName}',
                                      style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    textAlign: TextAlign.right,
                                    text: TextSpan(
                                      text: '\n\nTime Remaining',
                                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 2),
                                    child: CountDownText(
                                      due: widget.dateTime,
                                      finishedText: "Expired",
                                      showLabel: false,
                                      longDateName: true,
                                      style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: width * 0.03, color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        child: Container(
                          width: width,
                          padding: EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                width: double.infinity,
                                child: SizedBox(
                                    width: MediaQuery.of(context).size.width, // or use fixed size like 200
                                    height: MediaQuery.of(context).size.height * 0.2,
                                    child: GoogleMap(
                                      mapType: MapType.normal,
                                      markers: {Marker(markerId: const MarkerId("myMarker"), position: LatLng(widget.latitude, widget.longitude))},
                                      initialCameraPosition: CameraPosition(target: LatLng(widget.latitude, widget.longitude), zoom: 14.4746),
                                    )),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  RichText(
                                    textAlign: TextAlign.left,
                                    text: TextSpan(
                                      text: '\nProduct Address',
                                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black),
                                      children: [],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: width * 0.02),
                              Text(
                                'Location: ${widget.address}',
                                textAlign: TextAlign.start,
                                maxLines: 3,
                                style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black),
                              ),
                              Text(
                                '\nlandmark : ${widget.landmark}',
                                style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: width * 0.08),
                      widget.myFood == true
                          ? SizedBox(
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
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => EditProductScreen(
                                            address: widget.address,
                                            categories: widget.categories,
                                            description: widget.decription,
                                            docId: widget.productId,
                                            landmark: widget.landmark,
                                            mobile: widget.mobileNumber,
                                            name: widget.productName,
                                            productImage: widget.productImage,
                                            time: widget.time,
                                          )));
                                },
                                child: isLoading == true
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : Text(
                                        'EDIT',
                                        style: TextStyle(
                                          fontSize: 17,
                                        ),
                                      ),
                              ),
                            )
                          : SizedBox(
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
                                  _sendData();
                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //     builder: (context) =>
                                  //         const HomeScreen()));
                                },
                                child: isLoading == true
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : Text(
                                        'ACCEPT',
                                        style: TextStyle(
                                          fontSize: 17,
                                        ),
                                      ),
                              ),
                            ),
                      SizedBox(height: width * 0.08),
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

  Future<void> urlFileShare() async {
    final RenderBox box = context.findRenderObject() as RenderBox;
    if (Platform.isAndroid) {
      var url = Uri.parse(widget.productImage);

      var response = await get(url);
      final documentDirectory = (await getExternalStorageDirectory())!.path;
      File imgFile = File('$documentDirectory/flutter.png');
      imgFile.writeAsBytesSync(response.bodyBytes);

      Share.shareFiles(['$documentDirectory/flutter.png'], subject: widget.productName, text: widget.decription, sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    } else {
      Share.share('Hello, check your share files!', subject: 'URL File Share', sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }
  }
}
