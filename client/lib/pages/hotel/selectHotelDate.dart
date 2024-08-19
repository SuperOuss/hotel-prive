// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:hotel_prive/constant/constant.dart';
import 'package:hotel_prive/pages/payment/payment.dart';
import 'package:hotel_prive/widget/column_builder.dart';
import 'package:hotel_prive/widget/carousel_pro/lib/carousel_pro.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SelectHotelDate extends StatefulWidget {
  final Map<String, dynamic> hotelData;
  final String? email;
  SelectHotelDate({required this.hotelData, this.email});
  @override
  _SelectHotelDateState createState() => _SelectHotelDateState();
}

class _SelectHotelDateState extends State<SelectHotelDate> {
  final now = DateTime.now();
  DateTime selectedStartDate = DateTime.now().add(Duration(days: 30));
  DateTime selectedEndDate = DateTime.now().add(Duration(days: 31));
  List rates = [];
  bool isLoading = true;
  String selectedOfferId = '';
  int offerRetailRate = 0;

  final ruleList = [];
  void printHotelDataKeys(Map<String, dynamic> hotelData) {
    if (hotelData.containsKey('rooms')) {
      List<dynamic> rooms = hotelData['rooms'];
      rooms.forEach((room) {
        if (room.containsKey('id')) {
          print('Room ID: ${room['id']}');
        }
      });
    } else {
      print('No rooms found in hotelData.');
    }
  }

  @override
  void initState() {
    super.initState();
    selectedStartDate = DateTime.now()
        .add(Duration(days: 30)); // Ensure start date is one month from now
    selectedEndDate = selectedStartDate
        .add(Duration(days: 1)); // Ensure end date is after start date

    // Call getRates with the initialized dates and hotel ID
    fetchRates();
    print('email: ${widget.email}');
  }

  Future<void> fetchRates() async {
    setState(() {
      isLoading = true;
    });
    // Simulate a network call
    await Future.delayed(Duration(seconds: 2));

    await getRates(selectedStartDate, selectedEndDate, widget.hotelData['id']);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedStartDate,
      firstDate: DateTime.now().add(Duration(days: 30)), // One month from now
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedStartDate) {
      setState(() {
        selectedStartDate = picked;
        // Ensure end date is after the new start date
        if (selectedEndDate.isBefore(selectedStartDate)) {
          selectedEndDate = selectedStartDate.add(Duration(days: 1));
        }
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedEndDate.isAfter(selectedStartDate)
          ? selectedEndDate
          : selectedStartDate.add(Duration(days: 1)),
      firstDate: selectedStartDate
          .add(Duration(days: 1)), // Ensure end date is after start date
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedEndDate) {
      setState(() {
        selectedEndDate = picked;
      });
      await getRates(
          selectedStartDate, selectedEndDate, widget.hotelData['id']);
    }
  }

  Future<void> getRates(
      DateTime firstDate, DateTime lastDate, String hotelId) async {
    final url = Uri.parse('http://localhost:3000/v1/get-rate');

    // Print the arguments
    print('First Date: ${firstDate.toIso8601String()}');
    print('Last Date: ${lastDate.toIso8601String()}');
    print('Hotel ID: $hotelId');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'firstDate': firstDate.toIso8601String(),
        'lastDate': lastDate.toIso8601String(),
        'hotelId': hotelId,
      }),
    );

    if (response.statusCode == 200) {
      // Handle successful response
      final ratesData = jsonDecode(response.body);
      setState(() {
        rates = ratesData; // Update the rates state variable
      });
      //print('Rates: $rates');
      print('First rate object: ${rates[0]['offerRetailRate']['amount']}');
      // Populate room containers with rates
    } else {
      // Handle error response
      print('Failed to get rates: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0.0,
        titleSpacing: 0.0,
        title: Text('Select Date', style: appBarTextStyle),
      ),
      bottomNavigationBar: Material(
        elevation: 5.0,
        child: Container(
          color: Colors.white,
          width: width,
          height: 70.0,
          padding: EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
          alignment: Alignment.center,
          child: InkWell(
            borderRadius: BorderRadius.circular(15.0),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Payment(
                    selectedOfferId: selectedOfferId,
                    email: widget
                        .email, // Replace userEmail with the actual email variable
                    offerRetailRate:
                        offerRetailRate, // Replace offerRetailRate with the actual offer retail rate variable
                  ),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              height: 50.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: primaryColor,
              ),
              child: Text(
                'Book now',
                style: whiteColorButtonTextStyle,
              ),
            ),
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                      height:
                          16.0), // Add some space between the indicator and the text
                  Text('Please wait while we confirm your deals with the hotel'),
                ],
              ),
            )
          : ListView(
              children: [
                // Select Date Card Start
                selectDateCard(rates),
                // Select Date Card End
                ratesDisplay(rates, widget.hotelData),
                SizedBox(height: fixPadding * 2.0),
                additionalRules(widget.hotelData),
                // Rules Start
                rules(),
              ],
            ),
    );
  }

  Widget ratesDisplay(List rates, Map hotelData) {
    double width = MediaQuery.of(context).size.width;
    double fixPadding = 10.0;
    Color whiteColor = Colors.white;

    List<Map<String, dynamic>> ratesWithMappedRoomId = [];
    List<Map<String, dynamic>> ratesWithoutMappedRoomId = [];

    for (var rate in rates) {
      if (rate.containsKey('mappedRoomId')) {
        ratesWithMappedRoomId.add(rate);
      } else {
        ratesWithoutMappedRoomId.add(rate);
      }
    }

    List<Map<String, dynamic>> selectedRates = [];
    selectedRates.addAll(ratesWithMappedRoomId.take(3));

    if (selectedRates.length < 3) {
      selectedRates
          .addAll(ratesWithoutMappedRoomId.take(3 - selectedRates.length));
    }

    return Column(
      children: selectedRates.map((roomRate) {
        int suggestedSellingPrice = roomRate['suggestedSellingPrice']['amount'];
        offerRetailRate = roomRate['offerRetailRate']['amount'];
        double percentageDifference =
            ((suggestedSellingPrice - offerRetailRate) / offerRetailRate) * 100;
        String refundPolicy =
            roomRate['cancellationPolicy']['refundableTag'] == 'NRFN'
                ? 'Not Refundable'
                : 'Refundable';

        List<String> imageUrls = [];

        if (roomRate.containsKey('mappedRoomId')) {
          int mappedRoomId = roomRate['mappedRoomId'];
          var matchedRoom = hotelData['rooms'].firstWhere(
            (room) => room['id'] == mappedRoomId,
            orElse: () => null,
          );

          if (matchedRoom != null && matchedRoom.containsKey('photos')) {
            var photos = matchedRoom['photos'];

            if (photos is List) {
              for (var photo in photos) {
                if (photo is Map && photo.containsKey('url')) {
                  imageUrls.add(photo['url']);
                }
              }
            } else if (photos is Map && photos.containsKey('url')) {
              var images = photos['url'];
              if (images is String) {
                imageUrls.add(images);
              }
            }
          }
        }

        List<Widget> imageWidgets = imageUrls.map((url) {
          return Image.network(url, fit: BoxFit.cover);
        }).toList();

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedOfferId = roomRate['offerId'];
            });
            print('Selected Offer ID: $selectedOfferId');
          },
          child: Container(
            width: width - (fixPadding * 4.0),
            margin: EdgeInsets.symmetric(
                horizontal: fixPadding * 2.0, vertical: fixPadding),
            padding: EdgeInsets.all(fixPadding * 2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: selectedOfferId == roomRate['offerId']
                  ? primaryColor
                  : whiteColor,
              boxShadow: [
                BoxShadow(
                  blurRadius: 6.0,
                  spreadRadius: 1.0,
                  color: Colors.grey.withOpacity(0.3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imageWidgets.isNotEmpty)
                  SizedBox(
                    height: 200.0,
                    child: Carousel(
                      images: imageWidgets,
                      dotSize: 6.0,
                      dotSpacing: 18.0,
                      dotColor: Colors.blue,
                      indicatorBgPadding: 10.0,
                      dotBgColor: Colors.transparent,
                      borderRadius: false,
                      moveIndicatorFromBottom: 180.0,
                      noRadiusForIndicator: true,
                      overlayShadow: false,
                      overlayShadowColors: Colors.white,
                      overlayShadowSize: 0.7,
                      boxFit: BoxFit.cover,
                      autoplay: false,
                    ),
                  ),
                SizedBox(height: 10),
                Text(
                  roomRate['name'] ?? 'Unknown Room',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      '$refundPolicy',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    SizedBox(width: 10),
                    Text(
                      '${roomRate['boardName'] ?? 'Unknown Board'}',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '\$${suggestedSellingPrice.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.red,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '\$${offerRetailRate.toStringAsFixed(0)} Deal Price',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '-${percentageDifference.toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget selectDateCard(List rates) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.all(fixPadding * 2.0),
      padding: EdgeInsets.all(fixPadding * 2.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: whiteColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: 1.0,
            spreadRadius: 1.0,
            color: Colors.grey[300]!,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Select your dates',
                style: blackBigBoldTextStyle,
              ),
            ],
          ),
          heightSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.local_offer,
                color: greyColor,
                size: 16.0,
              ),
              const SizedBox(width: 3.0),
              SizedBox(
                width: width - (fixPadding * 8.0 + 20.0),
                child: Text(
                  'Pay with stripe, save 10% or more',
                  style: blackSmallTextStyle,
                ),
              ),
            ],
          ),
          heightSpace,
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: whiteColor,
              border: Border.all(width: 0.7, color: blackColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => _selectStartDate(context),
                  child: Container(
                    width: (width - (fixPadding * 8.0 + 1.4 + 0.7)) / 2.0,
                    padding: EdgeInsets.all(fixPadding * 2.0),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Start Date'.toUpperCase(),
                              style: blackExtraSmallBoldTextStyle,
                            ),
                            Icon(Icons.keyboard_arrow_down,
                                color: greyColor, size: 20.0),
                          ],
                        ),
                        const SizedBox(height: 5.0),
                        Text('${selectedStartDate.toLocal()}'.split(' ')[0],
                            style: blackSmallTextStyle),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 0.7,
                  color: blackColor,
                  height: 86.0,
                ),
                InkWell(
                  onTap: () => _selectEndDate(context),
                  child: Container(
                    width: (width - (fixPadding * 8.0 + 1.4 + 0.7)) / 2.0,
                    padding: EdgeInsets.all(fixPadding * 2.0),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'End Date'.toUpperCase(),
                              style: blackExtraSmallBoldTextStyle,
                            ),
                            Icon(Icons.keyboard_arrow_down,
                                color: greyColor, size: 20.0),
                          ],
                        ),
                        const SizedBox(height: 5.0),
                        Text('${selectedEndDate.toLocal()}'.split(' ')[0],
                            style: blackSmallTextStyle),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          heightSpace,
          heightSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  isLoading
                      ? Text(
                          'Loading...',
                          style: blackBigBoldTextStyle,
                        )
                      : Text(
                          rates.isNotEmpty
                              ? 'From \$${rates[0]['offerRetailRate']['amount']}'
                              : 'No rates available',
                          style: blackBigBoldTextStyle,
                        ),
                  Text(
                    ' / night',
                    style: blackSmallTextStyle,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${rates[0]['suggestedSellingPrice']['amount']}',
                    style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '-${rates[0]['percentageDifference']}%',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          heightSpace,
        ],
      ),
    );
  }

  rules() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
      padding: EdgeInsets.all(fixPadding * 2.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: whiteColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: 1.0,
            spreadRadius: 1.0,
            color: Colors.grey[300]!,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rules',
            style: blackBigBoldTextStyle,
          ),
          heightSpace,
          heightSpace,
          ruleRow(Icon(Icons.access_time, color: blackColor, size: 18.0),
              'Check-in: After 2:00 pm'),
          heightSpace,
          ruleRow(Icon(Icons.access_time, color: blackColor, size: 18.0),
              'Check out: 11:00 am'),
          heightSpace,
          ruleRow(Icon(Icons.smoke_free, color: blackColor, size: 18.0),
              'No smoking'),
          heightSpace,
          ruleRow(Icon(Icons.pets, color: blackColor, size: 18.0),
              'Pets are not allowed'),
        ],
      ),
    );
  }

  ruleRow(icon, title) {
    double width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        icon,
        widthSpace,
        SizedBox(
          width: width - (fixPadding * 8.0 + 18.0 + 10.0),
          child: Text(
            title,
            style: blackSmallTextStyle,
          ),
        ),
      ],
    );
  }

  additionalRules(Map hotelData) {
    List policies = hotelData['policies'] ?? [];

    return Container(
      margin: EdgeInsets.all(fixPadding * 2.0),
      padding: EdgeInsets.all(fixPadding * 2.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: whiteColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: 1.0,
            spreadRadius: 1.0,
            color: Colors.grey[300]!,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Additional information',
            style: blackBigBoldTextStyle,
          ),
          heightSpace,
          heightSpace,
          ColumnBuilder(
            itemCount: policies.length,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            itemBuilder: (context, index) {
              return Container(
                padding: (index != policies.length - 1)
                    ? EdgeInsets.only(bottom: fixPadding)
                    : const EdgeInsets.all(0.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ',
                      style: blackSmallTextStyle,
                    ),
                    Expanded(
                      child: Text(
                        policies[index]['description'] ?? '',
                        style: blackSmallTextStyle,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
