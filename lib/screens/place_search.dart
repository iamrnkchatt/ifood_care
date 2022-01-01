import 'dart:convert';

import 'package:donationapp/Utils/place_result_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class PlaceSearch extends StatefulWidget {
  const PlaceSearch({Key? key}) : super(key: key);

  @override
  _PlaceSearchState createState() => _PlaceSearchState();
}

class _PlaceSearchState extends State<PlaceSearch> {
  final TextEditingController _searchController = TextEditingController();
  List<Predictions> predictions = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop()),
        backgroundColor: const Color.fromRGBO(5, 25, 55, 1),
        foregroundColor: Colors.white,
        elevation: 0,
        title:
            const Text("Search Place", style: TextStyle(color: Colors.white)),
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 4,
                shadowColor: Colors.black38,
                child: TextFormField(
                  controller: _searchController,
                  style: GoogleFonts.poppins(
                      fontSize: width * 0.05, color: Colors.black),
                  onChanged: doSearch,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    prefixIcon: Container(
                      margin: EdgeInsets.only(right: width * 0.01),
                      width: width * 0.1,
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(5, 25, 55, 1),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5))),
                      child: const Icon(Icons.search, color: Colors.white),
                    ),
                    hintText: 'Search',
                    hintStyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.w300,
                        fontSize: width * 0.05,
                        color: Colors.black45),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 1, color: Colors.transparent),
                        borderRadius: BorderRadius.circular(5)),
                    // focusColor: purple,
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.transparent, width: 2),
                        borderRadius: BorderRadius.circular(5)),
                    border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1, color: Colors.white),
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : predictions.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: predictions.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pop(predictions[index]);
                                    print("Onclick : ${predictions[index]}");
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(Icons.location_pin,
                                          color: Color.fromRGBO(5, 25, 55, 1),
                                          size: 28),
                                      const SizedBox(width: 12),
                                      Expanded(
                                          child: Text(
                                              predictions[index].description,
                                              style: GoogleFonts.poppins(
                                                  fontSize: width * 0.05,
                                                  color: Colors.black))),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : Center(
                          child: Text("No place found.",
                              style: GoogleFonts.poppins(
                                  fontSize: width * 0.05,
                                  color: Colors.black))),
            )
          ],
        ),
      ),
    );
  }

  void doSearch(String str) async {
    setState(() {
      isLoading == true;
    });
    try {
      String url =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$str&language=en&components=country:in&key=AIzaSyD8-u44ZVTyKNwE9l099FjzTiH9inDn5mE";
      var response = await http.get(Uri.parse(url));
      print(response.body);
      if (response.statusCode == 200) {
        PlaceResultModel placeResultModel =
            PlaceResultModel.fromJson(jsonDecode(response.body));
        predictions = placeResultModel.predictions;
        print("Length: ${predictions.length}");
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading == true;
    });
  }
}
