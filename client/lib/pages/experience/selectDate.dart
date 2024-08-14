// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:hotel_prive/constant/constant.dart';
import 'package:hotel_prive/pages/payment/payment.dart';

class SelectDate extends StatefulWidget {
  const SelectDate({super.key});

  @override
  _SelectDateState createState() => _SelectDateState();
}

class _SelectDateState extends State<SelectDate> {
  DateTime selectedDate = DateTime.now();

  int? totalGuests;
  int adults = 1;
  int children = 0;
  int infants = 0;

  int? dialogAdults;
  int? dialogChildren;
  int? dialogInfants;

  @override
  void initState() {
    super.initState();
    totalGuests = adults + children + infants;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  countTotalGuests() {
    setState(() {
      totalGuests = adults + children + infants;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    guestsDialog() {
      dialogAdults = adults;
      dialogChildren = children;
      dialogInfants = infants;
      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              updateAdults(String action) {
                if (action == 'increament') {
                  setState(() {
                    dialogAdults = dialogAdults! + 1;
                  });
                } else if (action == 'decreament' && dialogAdults! > 1) {
                  setState(() {
                    dialogAdults = dialogAdults! - 1;
                  });
                }
              }

              updateChildren(String action) {
                if (action == 'increament') {
                  setState(() {
                    dialogChildren = dialogChildren! + 1;
                  });
                } else if (action == 'decreament' && dialogChildren! > 0) {
                  setState(() {
                    dialogChildren = dialogChildren! - 1;
                  });
                }
              }

              updateInfants(String action) {
                if (action == 'increament') {
                  setState(() {
                    dialogInfants = dialogInfants! + 1;
                  });
                } else if (action == 'decreament' && dialogInfants! > 0) {
                  setState(() {
                    dialogInfants = dialogInfants! - 1;
                  });
                }
              }

              save() {
                setState(() {
                  adults = dialogAdults!;
                  children = dialogChildren!;
                  infants = dialogInfants!;
                });
                countTotalGuests();
                Navigator.pop(context);
              }

              return Dialog(
                elevation: 1.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Container(
                  padding: EdgeInsets.all(fixPadding * 2.0),
                  child: Wrap(
                    children: [
                      Column(
                        children: [
                          // Adults Start
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Adults',
                                style: blackNormalTextStyle,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () => updateAdults('decreament'),
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: Container(
                                      width: 30.0,
                                      height: 30.0,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        border: Border.all(
                                            width: 0.7,
                                            color: (dialogAdults! > 1)
                                                ? blackColor
                                                : greyColor),
                                      ),
                                      child: Icon(Icons.remove,
                                          color: (dialogAdults! > 1)
                                              ? blackColor
                                              : greyColor,
                                          size: 16.0),
                                    ),
                                  ),
                                  widthSpace,
                                  Text(
                                    '$dialogAdults',
                                    style: blackNormalTextStyle,
                                  ),
                                  widthSpace,
                                  InkWell(
                                    onTap: () => updateAdults('increament'),
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: Container(
                                      width: 30.0,
                                      height: 30.0,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        border: Border.all(
                                            width: 0.7, color: blackColor),
                                      ),
                                      child: Icon(Icons.add,
                                          color: blackColor, size: 16.0),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // Adults End
                          heightSpace,
                          // Children Start
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Children',
                                    style: blackNormalTextStyle,
                                  ),
                                  Text('Ages 2–12', style: greySmallTextStyle),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () => updateChildren('decreament'),
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: Container(
                                      width: 30.0,
                                      height: 30.0,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        border: Border.all(
                                            width: 0.7,
                                            color: (dialogChildren! > 0)
                                                ? blackColor
                                                : greyColor),
                                      ),
                                      child: Icon(Icons.remove,
                                          color: (dialogChildren! > 0)
                                              ? blackColor
                                              : greyColor,
                                          size: 16.0),
                                    ),
                                  ),
                                  widthSpace,
                                  Text(
                                    '$dialogChildren',
                                    style: blackNormalTextStyle,
                                  ),
                                  widthSpace,
                                  InkWell(
                                    onTap: () => updateChildren('increament'),
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: Container(
                                      width: 30.0,
                                      height: 30.0,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        border: Border.all(
                                            width: 0.7, color: blackColor),
                                      ),
                                      child: Icon(Icons.add,
                                          color: blackColor, size: 16.0),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // Children End

                          heightSpace,
                          // Infants Start
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Infants',
                                    style: blackNormalTextStyle,
                                  ),
                                  Text('Ages 2–12', style: greySmallTextStyle),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () => updateInfants('decreament'),
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: Container(
                                      width: 30.0,
                                      height: 30.0,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        border: Border.all(
                                            width: 0.7,
                                            color: (dialogInfants! > 0)
                                                ? blackColor
                                                : greyColor),
                                      ),
                                      child: Icon(Icons.remove,
                                          color: (dialogInfants! > 0)
                                              ? blackColor
                                              : greyColor,
                                          size: 16.0),
                                    ),
                                  ),
                                  widthSpace,
                                  Text(
                                    '$dialogInfants',
                                    style: blackNormalTextStyle,
                                  ),
                                  widthSpace,
                                  InkWell(
                                    onTap: () => updateInfants('increament'),
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: Container(
                                      width: 30.0,
                                      height: 30.0,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        border: Border.all(
                                            width: 0.7, color: blackColor),
                                      ),
                                      child: Icon(Icons.add,
                                          color: blackColor, size: 16.0),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // Infants End
                          heightSpace,
                          heightSpace,
                          InkWell(
                            onTap: () => save(),
                            borderRadius: BorderRadius.circular(15.0),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(fixPadding * 1.2),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: primaryColor,
                              ),
                              child: Text(
                                'Save',
                                style: whiteColorButtonTextStyle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    }

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
          Container(
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
                      'From \$64',
                      style: blackBigBoldTextStyle,
                    ),
                    Text(
                      ' / person',
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
                    Text(
                      'Book for 2 guests, save 10% or more',
                      style: blackSmallTextStyle,
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
                        onTap: () => _selectDate(context),
                        child: Container(
                          width: (width - (fixPadding * 8.0 + 1.4 + 0.7)) / 2.0,
                          padding: EdgeInsets.all(fixPadding * 2.0),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Date'.toUpperCase(),
                                    style: blackExtraSmallBoldTextStyle,
                                  ),
                                  Icon(Icons.keyboard_arrow_down,
                                      color: greyColor, size: 20.0),
                                ],
                              ),
                              const SizedBox(height: 5.0),
                              Text('${selectedDate.toLocal()}'.split(' ')[0],
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
                        onTap: () => guestsDialog(),
                        child: Container(
                          width: (width - (fixPadding * 8.0 + 1.4 + 0.7)) / 2.0,
                          padding: EdgeInsets.all(fixPadding * 2.0),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Guests'.toUpperCase(),
                                    style: blackExtraSmallBoldTextStyle,
                                  ),
                                  Icon(Icons.keyboard_arrow_down,
                                      color: greyColor, size: 20.0),
                                ],
                              ),
                              const SizedBox(height: 5.0),
                              Text('$totalGuests guest',
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${selectedDate.toLocal()}'.split(' ')[0],
                            style: blackNormalTextStyle),
                        Text('7:00 AM - 8:30 AM', style: greySmallTextStyle),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('\$64', style: blackBigBoldTextStyle),
                        Text('/person', style: blackBigTextStyle),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
