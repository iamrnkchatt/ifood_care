import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donationapp/screens/addproduct_screen.dart';
import 'package:donationapp/screens/editproduct_screen.dart';
import 'package:donationapp/screens/productdetails_screen.dart';
import 'package:donationapp/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class YourDonationScreen extends StatefulWidget {
  const YourDonationScreen({Key? key}) : super(key: key);

  @override
  _YourDonationScreenState createState() => _YourDonationScreenState();
}

class _YourDonationScreenState extends State<YourDonationScreen> {
  static Stream<QuerySnapshot> _getProduct() {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    User? user = _firebaseAuth.currentUser;
    String userdoc = user!.uid;
    final CollectionReference _mainCollection = FirebaseFirestore.instance.collection('Users').doc(userdoc).collection("PRODUCTS");

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
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "YOUR DONATION",
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
                    } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.size > 0) {
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

                              return Row(
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
                                              isAccepted == "True"
                                                  ? Text(
                                                      "Donated",
                                                      style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: width * 0.035, color: Colors.red),
                                                    )
                                                  : Text(
                                                      "Live",
                                                      style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: width * 0.035, color: Colors.green),
                                                    ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.location_on_outlined, size: width * 0.04),
                                            SizedBox(width: width * 0.02),
                                            Expanded(
                                              child: Text(
                                                address,
                                                maxLines:1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: width * 0.035, color: Colors.black),
                                              ),
                                            ),
                                            SizedBox(width: width * 0.04),
                                            GestureDetector(
                                              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                                return EditProductScreen(productImage: productImage, docId: docId, name: itemName, mobile: mobile, landmark: landmark, categories: categories, description: description, address: address, time: time);
                                                // ProductDetailsScreen(
                                                //     productImage: productImage,
                                                //     productName: itemName,
                                                //     time: time,
                                                //     donerName: donerName,
                                                //     landmark: landmark,
                                                //     address: address);
                                              })),
                                              child: Text(
                                                isAccepted == "True" ? "" : "Edit",
                                                style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: width * 0.035, color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(height: width * 0.02);
                            },
                            itemCount: snapshot.data!.docs.length),
                      );
                    } else if (snapshot.data != null && snapshot.data!.size == 0) {
                      return Padding(padding: EdgeInsets.only(top: height / 4), child: Center(child: Text('No donation availble', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))));
                    }
                    return Center(child: CircularProgressIndicator(color: Colors.black));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
