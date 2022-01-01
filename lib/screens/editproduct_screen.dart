import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';

import 'package:donationapp/Services/s_provider.dart';

import 'package:donationapp/Utils/image_helper.dart';
import 'package:donationapp/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';

class EditProductScreen extends StatefulWidget {
  final String name;
  final String mobile;
  final String address;
  final String landmark;
  final String categories;
  final String description;
  final String time;
  final String docId;
  final String productImage;
  const EditProductScreen({
    Key? key,
    required this.name,
    required this.mobile,
    required this.landmark,
    required this.categories,
    required this.description,
    required this.address,
    required this.time,
    required this.docId,
    required this.productImage,
  }) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _landMarkController = TextEditingController();
  final TextEditingController _catagoriesController = TextEditingController();
  final TextEditingController _productDescriptionController =
      TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  File? selectedFile;
  @override
  void initState() {
    super.initState();
    _itemNameController.text = widget.name;
    _mobileNumberController.text = widget.mobile;
    _addressController.text = widget.address;
    _landMarkController.text = widget.landmark;
    _catagoriesController.text = widget.categories;
    _productDescriptionController.text = widget.description;
    _timeController.text = widget.time;
    _getDetails();
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _mobileNumberController.dispose();
    _addressController.dispose();
    _landMarkController.dispose();
    _catagoriesController.dispose();
    _productDescriptionController.dispose();
    _timeController.dispose();
    super.dispose();
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

        print("NAME: $name");
        print("NAME: $email");
      });
    });
  }

  bool isLoading = false;
  Stream<QuerySnapshot> _getCount() {
    final CollectionReference _mainCollection =
        FirebaseFirestore.instance.collection('PRODUCTS');

    return _mainCollection.snapshots();
  }

  Future<void> _sendData() async {
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
          .doc(widget.docId)
          .set({
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
      });
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userdoc)
          .collection('PRODUCTS')
          .doc(widget.docId)
          .update({
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
      await FirebaseFirestore.instance
          .collection("PRODUCTS")
          .doc(widget.docId)
          .set({
        "itemName": _itemNameController.text.trim(),
        "mobileNumber": _mobileNumberController.text.trim(),
        "address": _addressController.text.trim(),
        "landmark": _landMarkController.text.trim(),
        "categories": _catagoriesController.text.trim(),
        "description": _productDescriptionController.text.trim(),
        "disAppearTime": _timeController.text,
        "name": name,
        "isAvailable": "True",
        "isAccepted": "False",
        "isCompleted": "False",
      });
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userdoc)
          .collection('PRODUCTS')
          .doc(widget.docId)
          .update({
        "itemName": _itemNameController.text.trim(),
        "mobileNumber": _mobileNumberController.text.trim(),
        "address": _addressController.text.trim(),
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
      // await FirebaseFirestore.instance.collection("Users").doc(userdoc).set({
      //   "itemName": _itemNameController.text.trim(),
      //   "mobileNumber": _mobileNumberController.text.trim(),
      //   "productUrl":
      //       widget.productImage,
      //   "address": _addressController.text.trim(),
      //   "landmark": _landMarkController.text.trim(),
      //   "categories": _catagoriesController.text.trim(),
      //   "description": _productDescriptionController.text.trim(),
      //   "disAppearTime": "",
      // });
    }

    print("Name: ${_itemNameController.text}");
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
          "Edit",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  color: const Color.fromRGBO(5, 25, 55, 1),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
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
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        // color: Colors.grey,
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                widget.productImage))),
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
                Container(
                  margin: const EdgeInsets.only(top: 120),
                  width: width,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: width * 0.12),
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
                                  controller: _addressController,
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
                                print(val);
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
                            setState(() {
                              isLoading = true;
                              _sendData();
                            });

                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) => const HomeScreen()));
                          },
                          child: isLoading == true
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'SAVE',
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
}
