// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:hotel_prive/constant/constant.dart';
import 'package:hotel_prive/pages/payment/payment.dart';
import 'package:hotel_prive/widget/column_builder.dart';

class SelectHotelDate extends StatefulWidget {
  final String? price;
  const SelectHotelDate({Key? key, @required this.price}) : super(key: key);
  @override
  _SelectHotelDateState createState() => _SelectHotelDateState();
}

class _SelectHotelDateState extends State<SelectHotelDate> {
  final now = DateTime.now();
  DateTime selectedStartDate = DateTime.now();
  DateTime? selectedEndDate;

  final ruleList = [
    {
      'rule':
          'The apartment can be occupied on the day of the arrival from 2PM and should be vacated before 11AM on the day of departure. Wherever possible we are flexible with these times but please advise us of your requirements in advance! We reserve the right to charge an extra day payment if you stay later than 11 AM and it was not agreed with us formerly in email, in advance.'
    },
    {
      'rule':
          'We kindly ask all our guest to fill in our registration book upon arrival.'
    },
    {
      'rule':
          'Please leave all the keys received in the keybox, as agreed previously, at the handover.'
    },
    {
      'rule':
          'Please always lock the doors to your apartment, i.e. the street door, the apartment door and the security gate if available.'
    },
    {
      'rule':
          'In case any apartment key is lost you should inform us immediately; the necessary lock and key changes will be charged to you.'
    },
    {
      'rule': 'The apartment can be used by our checked-in guests only.',
    }
  ];

  @override
  void initState() {
    super.initState();
    selectedEndDate = DateTime(now.year, now.month, now.day + 1);
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedStartDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedStartDate) {
      setState(() {
        selectedStartDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedEndDate!,
        firstDate: DateTime(now.year, now.month, now.day + 1),
        lastDate: DateTime(2101));
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
          // Rules Start
          rules(),
          // Rules End
          // Additional Rules Start
          additionalRules(),
          // Additional Rules End
        ],
      ),
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
                'From \$${widget.price}',
                style: blackBigBoldTextStyle,
              ),
              Text(
                ' / night',
                style: blackSmallTextStyle,
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
                        Text('${selectedEndDate!.toLocal()}'.split(' ')[0],
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
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('${selectedStartDate.toLocal()}'.split(' ')[0],
                      style: blackNormalTextStyle),
                  Text(
                    'to',
                    style: greySmallTextStyle,
                  ),
                  Text('${selectedEndDate!.toLocal()}'.split(' ')[0],
                      style: blackNormalTextStyle),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('\$${widget.price}', style: blackBigBoldTextStyle),
                  Text('/night', style: blackBigTextStyle),
                ],
              ),
            ],
          ),
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
            'Additional rules',
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
              final item = ruleList[index];
              return Container(
                padding: (index != ruleList.length - 1)
                    ? EdgeInsets.only(bottom: fixPadding)
                    : const EdgeInsets.all(0.0),
                child: Text(
                  '${index + 1}. ${item['rule']}',
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
