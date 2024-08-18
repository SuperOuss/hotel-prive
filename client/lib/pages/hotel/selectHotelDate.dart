// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:hotel_prive/constant/constant.dart';
import 'package:hotel_prive/pages/payment/payment.dart';
import 'package:hotel_prive/widget/column_builder.dart';
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
    getRates(selectedStartDate, selectedEndDate, widget.hotelData['id']);
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
      await getRates(
          selectedStartDate, selectedEndDate, widget.hotelData['id']);
    }
  }

  Future<void> getRates(
      DateTime firstDate, DateTime lastDate, String hotelId) async {
    final url = Uri.parse('http://localhost:3000/v1/get-rate');

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
      final rates = jsonDecode(response.body);
      print('Rates: $rates');
      // Populate room containers with rates
    } else {
      // Handle error response
      print('Failed to get rates: ${response.statusCode}');
    }
  }

  List<Map<String, String>> roomRates = [
    {'room': 'Standard Room', 'rate': '\$100'},
    {'room': 'Deluxe Room', 'rate': '\$150'},
    {'room': 'Suite', 'rate': '\$200'},
  ];
  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedEndDate,
      firstDate: selectedStartDate
          .add(Duration(days: 1)), // Ensure end date is after start date
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedEndDate) {
      setState(() {
        selectedEndDate = picked;
      });
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
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: const Payment()));
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
      body: ListView(
        children: [
          // Select Date Card Start
          selectDateCard(),
          // Select Date Card End
          rates(),
          SizedBox(height: fixPadding * 2.0),
          additionalRules(),
          // Rules Start
          rules(),
          // Rules End
          // Additional Rules Start

          // Additional Rules End
          //rates start
        ],
      ),
    );
  }

  Widget rates() {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: roomRates.map((roomRate) {
        return Container(
          width: width -
              (fixPadding * 4.0), // Adjust width to be similar to others
          margin: EdgeInsets.symmetric(
              horizontal: fixPadding * 2.0, vertical: fixPadding),
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
                roomRate['room'] ?? 'Unknown Room',
                style: blackBigBoldTextStyle,
              ),
              heightSpace,
              Text(
                roomRate['rate'] ?? 'Unknown Rate',
                style: blackSmallTextStyle,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  selectDateCard() {
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
              ]),
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
                    Text(
                      'From \$${widget.hotelData['offerRetailRate']}',
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
                      '\$${widget.hotelData['suggestedSellingPrice']}',
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
                        '-${widget.hotelData['percentageDifference']}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ]),
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
          ruleRow(
              Icon(FontAwesomeIcons.doorOpen, color: blackColor, size: 18.0),
              'Self check-in with lockbox'),
          heightSpace,
          ruleRow(Icon(Icons.smoke_free, color: blackColor, size: 18.0),
              'No smoking'),
          heightSpace,
          ruleRow(Icon(Icons.pets, color: blackColor, size: 18.0),
              'Pets are allowed'),
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

  additionalRules() {
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
            itemCount: ruleList.length,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            itemBuilder: (context, index) {
              return Container(
                padding: (index != ruleList.length - 1)
                    ? EdgeInsets.only(bottom: fixPadding)
                    : const EdgeInsets.all(0.0),
                child: Text(
                  'test',
                  style: blackSmallTextStyle,
                  textAlign: TextAlign.justify,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
