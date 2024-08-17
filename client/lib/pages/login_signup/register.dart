import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:google_places_flutter/model/place_type.dart';
import 'package:page_transition/page_transition.dart';
import 'package:hotel_prive/pages/bottom_bar.dart';
import 'package:hotel_prive/constant/constant.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:hotel_prive/models/location.dart';
import 'package:hotel_prive/models/lat_lng.dart';
import 'package:hotel_prive/functions/autocomplete.dart';
import 'package:http/http.dart' as http;

const kGoogleApiKey = "AIzaSyB2aCM5jw8tP7zyRH6QjndhkfNmE4A0x0I";

List<LatLng> tempLatLngList = [];

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController controller = TextEditingController();
  List<Location> locations = [];
  String tempLat = '';
  String tempLng = '';
  List<LatLng> latLngList = [];
  final List<String> selectedCities = []; // List to store selected cities
  final FocusNode _placesFocusNode = FocusNode();
  final FocusNode _hotelsFocusNode = FocusNode();
  List<String> hotelIds = [];
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/bg.jpg'), fit: BoxFit.cover),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0.0,
            left: 0.0,
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.1, 0.3, 0.5, 0.7, 0.9],
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.55),
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.8),
                    Colors.black.withOpacity(1.0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              ),
              body: ListView(
                physics: const BouncingScrollPhysics(),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                    child: Text(
                      'Tell us about you',
                      style: loginBigTextStyle,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      'Your deal preferences',
                      style: whiteSmallLoginTextStyle,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: placesAutoCompleteTextField(),
                  ),
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200]!.withOpacity(0.3),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20.0)),
                      ),
                      child: AutocompleteField(
                        hotelsFocusNode: _hotelsFocusNode,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 20.0),
                          hintText: 'Hotel Name',
                          hintStyle: inputLoginTextStyle,
                          border: InputBorder.none,
                        ),
                        onHotelIdsChanged: _handleHotelIdsChanged,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200]!.withOpacity(0.3),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20.0)),
                      ),
                      child: TextField(
                        controller: _emailController,
                        style: inputLoginTextStyle,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 20.0),
                          hintText: 'Email',
                          hintStyle: inputLoginTextStyle,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    child: Text(
                      'We will use your location and hotel preferences to send you the best deals. You can change your preferences at any time in your profile.',
                      style: walkrhroughWhiteSmallTextStyle,
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30.0),
                      onTap: () async {
                        final email = _emailController
                            .text; // Get the email from the controller
                        await sendDataToBackend();
                        Navigator.push(
                          context,
                          PageTransition(
                            duration: const Duration(milliseconds: 600),
                            type: PageTransitionType.fade,
                            child:
                                BottomBar(email: email), // Pass the email here
                          ),
                        );
                      },
                      child: Container(
                        height: 50.0,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.bottomRight,
                            stops: const [0.1, 0.5, 0.9],
                            colors: [
                              Colors.teal[300]!.withOpacity(0.8),
                              Colors.teal[500]!.withOpacity(0.8),
                              Colors.teal[800]!.withOpacity(0.8),
                            ],
                          ),
                        ),
                        child: Text(
                          'Continue',
                          style: inputLoginTextStyle,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget placesAutoCompleteTextField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200]!.withOpacity(0.3),
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Column(
        children: [
          GooglePlaceAutoCompleteTextField(
            focusNode: _placesFocusNode,
            textEditingController: controller,
            googleAPIKey: kGoogleApiKey,
            inputDecoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 20.0),
              hintText: "Search your location",
              hintStyle: inputLoginTextStyle,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
            ),
            textStyle: inputLoginTextStyle,
            debounceTime: 400,
            placeType: PlaceType.cities, // Restrict results to cities
            isLatLngRequired: true,
            getPlaceDetailWithLatLng: (Prediction prediction) {
              print("placeDetails" + prediction.lat.toString());
              setState(() {
                tempLat = prediction.lat.toString();
                tempLng = prediction.lng.toString();
                // Print the temporary variables
              });
              _organizeLatLng();
            },
            itemClick: (Prediction prediction) {
              setState(() {
                // Assuming prediction.description contains both city and country
                final parts = (prediction.description ?? "").split(", ");
                final city = parts.isNotEmpty ? parts[0] : "";
                final country = parts.length > 1 ? parts[1] : "";
                final location = Location(city: city, country: country);
                locations.add(location);
                selectedCities.add(prediction.description ?? "");

                // Debug statement to print all stored locations
                print("All Stored Locations:");
                for (var loc in locations) {
                  print("City: ${loc.city}, Country: ${loc.country}");
                }
              });
              controller.clear();
            },
            containerHorizontalPadding: 10,
            itemBuilder: (context, index, Prediction prediction) {
              return Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Icon(Icons.location_on),
                    SizedBox(width: 7),
                    Expanded(child: Text("${prediction.description ?? ""}"))
                  ],
                ),
              );
            },
            isCrossBtnShown: true,
          ),
          SizedBox(height: 10),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: selectedCities.map((city) {
              return Chip(
                label: Text(city),
                onDeleted: () {
                  setState(() {
                    selectedCities.remove(city);
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _organizeLatLng() {
    if (tempLat.isNotEmpty && tempLng.isNotEmpty) {
      latLngList.add(LatLng(
        latitude: double.parse(tempLat),
        longitude: double.parse(tempLng),
      ));
    }
  }

  void _handleHotelIdsChanged(List<String> ids) {
    setState(() {
      hotelIds = ids;
    });
    print('Hotel IDs in RegisterPage: $hotelIds'); // Debug print
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  //send data to back end
  Future<void> sendDataToBackend() async {
    final url = Uri.parse(
        'http://localhost:3000/v1/create-user'); // Replace with your backend API URL

    final Map<String, dynamic> data = {
      'email': _emailController.text,
      'hotelIds': hotelIds,
      'latLngList': latLngList
          .map((latLng) => {
                'latitude': latLng.latitude,
                'longitude': latLng.longitude,
              })
          .toList(),
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      // Handle successful response
      print('Data sent successfully');
    } else {
      // Handle error response
      print('Failed to send data: ${response.statusCode}');
    }
  }
}
