import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donationapp/Services/s_provider.dart';

import 'package:donationapp/Utils/image_helper.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _profileUrl = "";
  File? selectedFile;
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
        _nameController.text = event.get("name").toString();

        _emailController.text = event.get("email").toString();

        _profileUrl = event.get("profileUrl").toString();

        print("NAME: " + _nameController.text.toString());
        print("EMAIL: " + _emailController.text.toString());
      });
    });
  }

  Future<void> _sendData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    String userdoc = user!.uid;
    if (selectedFile != null) {
      StorageProvider _storageProvider =
          StorageProvider(firebaseStorage: FirebaseStorage.instance);
      String imageUrl =
          await _storageProvider.uploadUserProfile(image: selectedFile);
      await FirebaseFirestore.instance.collection("Users").doc(userdoc).set({
        "name": _nameController.text.trim(),
        "email": _emailController.text.trim(),
        "profileUrl": imageUrl,
      });
    } else {
      await FirebaseFirestore.instance.collection("Users").doc(userdoc).set({
        "name": _nameController.text.trim(),
        "email": _emailController.text.trim(),
        "profileUrl": _profileUrl,
      });
    }

    print("Name: ${_nameController.text}");
    print("Email: ${_emailController.text}");
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
  void initState() {
    super.initState();
    _getDetails();
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
          "EDIT PROFILE",
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
                  // height: height,
                  margin: const EdgeInsets.only(top: 50),
                  width: width,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            _showPicker(context);
                          },
                          child: selectedFile == null
                              ? Container(
                                  height: width * 0.3,
                                  width: width * 0.3,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey,
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image:
                                                  NetworkImage(_profileUrl))),
                                      child: null))
                              : Container(
                                  height: width * 0.3,
                                  width: width * 0.3,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: FileImage(selectedFile!,
                                              scale: 5))),
                                  child: null,
                                ),
                        ),
                      ),
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
                                  controller: _nameController,
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
                                    hintText: '  Email Id',
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
                            _sendData();

                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: const Text("Saved")));
                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) => const HomeScreen()));
                          },
                          child: const Text(
                            'CONTINUE',
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
