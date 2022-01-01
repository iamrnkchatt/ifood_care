import 'dart:io' as io;
import 'dart:async';

import 'package:donationapp/Utils/flutter_google_places.dart';
import 'package:donationapp/Utils/place_result_model.dart';

import 'package:donationapp/screens/place_search.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_webservice/places.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';

import 'package:donationapp/Services/s_provider.dart';

import 'package:donationapp/Utils/image_helper.dart';
import 'package:donationapp/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';

class AddProductScreen extends StatefulWidget {
  final double latitude;
  final double longitude;

  const AddProductScreen({
    Key? key,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _landMarkController = TextEditingController();
  final TextEditingController _catagoriesController = TextEditingController();
  final TextEditingController _productDescriptionController =
      TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final DateTime selectedTime = DateTime.now();
  io.File? selectedFile;
  String kGoogleApiKey = "AIzaSyD8-u44ZVTyKNwE9l099FjzTiH9inDn5mE";
  late double latitude = 0;
  late double longitude = 0;

  @override
  void initState() {
    _addressController.text = "Address";
    super.initState();
    _getDetails();
  }

  String name = "";
  String email = "";

  Future<void> _getDetails() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    User? user = _firebaseAuth.currentUser;
    String userdoc = user!.uid;

    FirebaseFirestore.instance
        .collection("Users")
        .doc(userdoc)
        .snapshots()
        .listen((event) {
      setState(() {
        name = event.get("name").toString();
        email = event.get("email").toString();
      });
    });
  }

  bool isLoading = false;

  Stream<QuerySnapshot> _getCount() {
    final CollectionReference _mainCollection =
        FirebaseFirestore.instance.collection('PRODUCTS');

    return _mainCollection.snapshots();
  }

  Future<void> _sendData(productId) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    String userdoc = user!.uid;
    if (selectedFile != null) {
      StorageProvider _storageProvider =
          StorageProvider(firebaseStorage: FirebaseStorage.instance);
      String imageUrl =
          await _storageProvider.uploadProductImage(image: selectedFile);
      await FirebaseFirestore.instance
          .collection("PRODUCTS")
          .doc(productId)
          .set({
        "productId": productId,
        "userId": userdoc,
        "itemName": _itemNameController.text.trim(),
        "mobileNumber": _mobileNumberController.text.trim(),
        "productUrl": imageUrl,
        "address": _addressController.text.trim(),
        "landmark": _landMarkController.text.trim(),
        "categories": _catagoriesController.text.trim(),
        "description": _productDescriptionController.text.trim(),
        "disAppearTime": _timeController.text,
        "name": name,
        "isAvailable": "True",
        "isAccepted": "False",
        "isCompleted": "False",
        "latitude": latitude,
        "longitude": longitude,
      });
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userdoc)
          .collection('PRODUCTS')
          .doc(productId)
          .set({
        "productId": productId,
        "userId": userdoc,
        "itemName": _itemNameController.text.trim(),
        "mobileNumber": _mobileNumberController.text.trim(),
        "productUrl": imageUrl,
        "address": _addressController.text,
        "landmark": _landMarkController.text.trim(),
        "categories": _catagoriesController.text.trim(),
        "description": _productDescriptionController.text.trim(),
        "disAppearTime": _timeController.text,
        "name": name,
        "isAvailable": "True",
        "isAccepted": "False",
        "isCompleted": "False",
      }).whenComplete(() {
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            isLoading = false;
          });
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false);
        });
      });
    } else {
      await FirebaseFirestore.instance.collection("Users").doc(userdoc).set({
        "productId": productId,
        "userId": userdoc,
        "itemName": _itemNameController.text.trim(),
        "mobileNumber": _mobileNumberController.text.trim(),
        "productUrl":
            "https://png.pngitem.com/pimgs/s/18-186729_food-beverage-food-and-beverage-icon-hd-png.png",
        "address": _addressController.text.trim(),
        "landmark": _landMarkController.text.trim(),
        "categories": _catagoriesController.text.trim(),
        "description": _productDescriptionController.text.trim(),
        "disAppearTime": "",
        "isCompleted": "False",
      });
    }
  }

  void _selectImageFromGallery(BuildContext context) async {
    final pickedFile = await ImageHelper.pickImageFromGallery(
        context: context,
        cropStyle: CropStyle.rectangle,
        title: 'Product Image');
    if (pickedFile != null) {
      setState(() {
        selectedFile = pickedFile;
      });
    } else {}
  }

  void _selectImageFromCamera(BuildContext context) async {
    final pickedFile = await ImageHelper.pickImageFromCamera(
        context: context,
        cropStyle: CropStyle.rectangle,
        title: 'Product Image');
    if (pickedFile != null) {
      setState(() {
        selectedFile = pickedFile;
      });
    } else {}
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Photo Library'),
                      onTap: () {
                        _selectImageFromGallery(context);
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('Camera'),
                    onTap: () {
                      _selectImageFromCamera(context);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
          "ADD PRODUCT",
          style: TextStyle(color: Colors.white),
        ),
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
                      child: GestureDetector(
                        onTap: () {
                          _showPicker(context);
                        },
                        child: selectedFile == null
                            ? Container(
                                height: width * 0.3,
                                width: width * 0.3,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.grey),
                                child: Container(
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        // color: Colors.grey,
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                                "assets/images/uploaduserdp.png"))),
                                    child: Icon(Icons.camera_alt)))
                            : Container(
                                height: width * 0.3,
                                width: width * 0.3,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    // color: Colors.grey,
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: FileImage(selectedFile!,
                                            scale: 5))),
                                child: null),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Container(
                  width: width,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Form(
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
                                  controller: _itemNameController,
                                  style: GoogleFonts.poppins(
                                      fontSize: width * 0.05,
                                      color: Colors.black),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    prefixIcon: Container(
                                      height: height,
                                      margin:
                                          EdgeInsets.only(right: width * 0.01),
                                      width: width * 0.1,
                                      decoration: const BoxDecoration(
                                          color: Color.fromRGBO(5, 25, 55, 1),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(5),
                                              bottomLeft: Radius.circular(5))),
                                      child: const Icon(
                                        Icons.food_bank,
                                        color: Colors.white,
                                      ),
                                    ),
                                    hintText: '  Item Name',
                                    hintStyle: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w300,
                                      fontSize: width * 0.05,
                                      color: Colors.black45,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 1, color: Colors.transparent),
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
                                          width: 1, color: Colors.white),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                              ),
                            ),
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
                                  controller: _mobileNumberController,
                                  keyboardType: TextInputType.number,
                                  style: GoogleFonts.poppins(
                                      fontSize: width * 0.05,
                                      color: Colors.black),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    prefixIcon: Container(
                                      height: height,
                                      margin:
                                          EdgeInsets.only(right: width * 0.01),
                                      width: width * 0.1,
                                      decoration: const BoxDecoration(
                                          color: Color.fromRGBO(5, 25, 55, 1),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(5),
                                              bottomLeft: Radius.circular(5))),
                                      child: const Icon(
                                        Icons.email_outlined,
                                        color: Colors.white,
                                      ),
                                    ),
                                    hintText: '  Mobile Number',
                                    hintStyle: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w300,
                                      fontSize: width * 0.05,
                                      color: Colors.black45,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 1, color: Colors.transparent),
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
                                          width: 1, color: Colors.white),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Container(
                            //   height: width * 0.15,
                            //   decoration: const BoxDecoration(
                            //     boxShadow: [
                            //       BoxShadow(
                            //         spreadRadius: 0.01,
                            //         color: Color.fromRGBO(0, 0, 0, 0.12),
                            //         blurRadius: 12.0,
                            //       ),
                            //     ],
                            //   ),
                            //   child: Card(
                            //     elevation: 0,
                            //     shadowColor: Colors.black38,
                            //     child: Row(
                            //       children: [
                            //         Container(
                            //           height: height,
                            //           margin:
                            //               EdgeInsets.only(right: width * 0.01),
                            //           width: width * 0.1,
                            //           decoration: const BoxDecoration(
                            //               color: Color.fromRGBO(5, 25, 55, 1),
                            //               borderRadius: BorderRadius.only(
                            //                   topLeft: Radius.circular(5),
                            //                   bottomLeft: Radius.circular(5))),
                            //           child: const Icon(
                            //             Icons.location_on,
                            //             color: Colors.white,
                            //           ),
                            //         ),
                            //         GestureDetector(
                            //           onTap: () async {
                            //             FocusScope.of(context)
                            //                 .requestFocus(FocusNode());
                            //             try {
                            //               Predictions p =
                            //                   await Navigator.of(context).push(
                            //                       MaterialPageRoute(
                            //                           builder: (context) =>
                            //                               const PlaceSearch()));
                            //               GoogleMapsPlaces _places =
                            //                   GoogleMapsPlaces(
                            //                       apiKey: kGoogleApiKey,
                            //                       apiHeaders:
                            //                           await const GoogleApiHeaders()
                            //                               .getHeaders());
                            //               PlacesDetailsResponse detail =
                            //                   await _places.getDetailsByPlaceId(
                            //                       p.placeId);

                            //               latitude = detail.result.geometry
                            //                       ?.location.lat ??
                            //                   0;
                            //               longitude = detail.result.geometry
                            //                       ?.location.lng ??
                            //                   0;
                            //               _addressController.text =
                            //                   p.description.toString();
                            //             } catch (e) {
                            //               print(e);
                            //             }
                            //           },
                            //           child: Container(
                            //             child: Text(_addressController.text),
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
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
                                  onTap: () async {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    try {
                                      Predictions p =
                                          await Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PlaceSearch()));
                                      GoogleMapsPlaces _places =
                                          GoogleMapsPlaces(
                                              apiKey: kGoogleApiKey,
                                              apiHeaders:
                                                  await const GoogleApiHeaders()
                                                      .getHeaders());
                                      PlacesDetailsResponse detail =
                                          await _places
                                              .getDetailsByPlaceId(p.placeId);

                                      latitude = detail
                                              .result.geometry?.location.lat ??
                                          0;
                                      longitude = detail
                                              .result.geometry?.location.lng ??
                                          0;
                                      _addressController.text = p.description;
                                      setState(() {});
                                    } catch (e) {
                                      print(e);
                                    }
                                  },
                                  controller: _addressController,
                                  readOnly: true,
                                  focusNode: FocusNode(),
                                  style: GoogleFonts.poppins(
                                      fontSize: width * 0.05,
                                      color: Colors.black),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    prefixIcon: Container(
                                      height: height,
                                      margin:
                                          EdgeInsets.only(right: width * 0.01),
                                      width: width * 0.1,
                                      decoration: const BoxDecoration(
                                          color: Color.fromRGBO(5, 25, 55, 1),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(5),
                                              bottomLeft: Radius.circular(5))),
                                      child: const Icon(
                                        Icons.location_on,
                                        color: Colors.white,
                                      ),
                                    ),
                                    hintText: '  Address',
                                    hintStyle: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w300,
                                      fontSize: width * 0.05,
                                      color: Colors.black45,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 1, color: Colors.transparent),
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
                                          width: 1, color: Colors.white),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                              ),
                            ),
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
                                  controller: _landMarkController,
                                  style: GoogleFonts.poppins(
                                      fontSize: width * 0.05,
                                      color: Colors.black),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    prefixIcon: Container(
                                      height: height,
                                      margin:
                                          EdgeInsets.only(right: width * 0.01),
                                      width: width * 0.1,
                                      decoration: const BoxDecoration(
                                          color: Color.fromRGBO(5, 25, 55, 1),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(5),
                                              bottomLeft: Radius.circular(5))),
                                      child: const Icon(
                                        Icons.map,
                                        color: Colors.white,
                                      ),
                                    ),
                                    hintText: '  Landmark',
                                    hintStyle: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w300,
                                      fontSize: width * 0.05,
                                      color: Colors.black45,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 1, color: Colors.transparent),
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
                                          width: 1, color: Colors.white),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                              ),
                            ),
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
                                  controller: _catagoriesController,
                                  style: GoogleFonts.poppins(
                                      fontSize: width * 0.05,
                                      color: Colors.black),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    prefixIcon: Container(
                                      height: height,
                                      margin:
                                          EdgeInsets.only(right: width * 0.01),
                                      width: width * 0.1,
                                      decoration: const BoxDecoration(
                                          color: Color.fromRGBO(5, 25, 55, 1),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(5),
                                              bottomLeft: Radius.circular(5))),
                                      child: const Icon(
                                        Icons.add_box,
                                        color: Colors.white,
                                      ),
                                    ),
                                    hintText: '  Categories',
                                    hintStyle: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w300,
                                      fontSize: width * 0.05,
                                      color: Colors.black45,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 1, color: Colors.transparent),
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
                                          width: 1, color: Colors.white),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
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
                                  controller: _productDescriptionController,
                                  maxLines: 2,
                                  maxLength: 200,
                                  style: GoogleFonts.poppins(
                                      fontSize: width * 0.05,
                                      color: Colors.black),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,

                                    hintText: '  Product Description',
                                    hintStyle: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w300,
                                      fontSize: width * 0.05,
                                      color: Colors.black45,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 1, color: Colors.transparent),
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
                                          width: 1, color: Colors.white),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            DateTimePicker(
                              type: DateTimePickerType.dateTimeSeparate,
                              dateMask: 'd MMM, yyyy',
                              initialValue: DateTime.now().toString(),
                              firstDate: DateTime(2021),
                              lastDate: DateTime(2100),
                              icon: Icon(Icons.timelapse),
                              dateLabelText: 'Date',
                              timeLabelText: "Hour",
                              onChanged: (val) {
                                _timeController.text = val.toString();
                              },
                              validator: (val) {
                                return null;
                              },
                              onSaved: (val) => print(val),
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
                            if (selectedFile == null) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                  content: Text('Please Upload')));
                            } else if (_itemNameController
                                .text.isEmpty ||
                                _mobileNumberController.text.isEmpty ||
                                _addressController.text.isEmpty ||
                                _landMarkController.text.isEmpty ||
                                _catagoriesController.text.isEmpty ||
                                _productDescriptionController
                                    .text.isEmpty ||
                                _timeController.text.isEmpty) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                  content: Text(
                                      "Field can't be empty!!")));
                            } else {
                              DateTime now = DateTime.now();
                              String g = ('${now.year}${now.month}${now.day}');
                              String formattedDate = DateFormat('kkmmss').format(now);
                              String productId = g + formattedDate;
                              setState(() {
                                isLoading = true;
                                _sendData("Product_$productId");
                              });
                            }

                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) => const HomeScreen()));
                          },
                          child: isLoading == true
                              ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                              : const Text(
                            'ADD FOOD',
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: width * 0.08),
                      /*StreamBuilder(
                          stream: _getCount(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text('Something went wrong');
                            } else if (snapshot.hasData ||
                                snapshot.data != null) {
                              var itemCount = snapshot.data!.docs.length;
                              return SizedBox(
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
                                    if (selectedFile == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text('Please Upload')));
                                    } else if (_itemNameController
                                            .text.isEmpty ||
                                        _mobileNumberController.text.isEmpty ||
                                        _addressController.text.isEmpty ||
                                        _landMarkController.text.isEmpty ||
                                        _catagoriesController.text.isEmpty ||
                                        _productDescriptionController
                                            .text.isEmpty ||
                                        _timeController.text.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Field can't be empty!!")));
                                    } else {
                                      var item = itemCount + 1;
                                      setState(() {
                                        isLoading = true;
                                        _sendData("Product_$item");
                                      });
                                    }

                                    // Navigator.of(context).push(MaterialPageRoute(
                                    //     builder: (context) => const HomeScreen()));
                                  },
                                  child: isLoading == true
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : const Text(
                                          'ADD FOOD',
                                          style: TextStyle(
                                            fontSize: 17,
                                          ),
                                        ),
                                ),
                              );
                            }
                            return Container(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          }),*/
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
