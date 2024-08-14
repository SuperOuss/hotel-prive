// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hotel_prive/constant/constant.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final notificationList = [
    {
      'type': 'booking',
      'title': 'Booking Success',
      'desc': 'Your have successfully booked hotel. OrderId: OID1256789.'
    },
    {
      'type': 'offer',
      'title': '25% Off use code TravelPro25',
      'desc':
          'Use code TravelPro25 for your booking between 20th sept to 25th sept and get 25% off.'
    },
    {
      'type': 'offer',
      'title': 'Flat \$10 Off',
      'desc': 'Use code Travel10 and get \$10 off on your booking.'
    }
  ];
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 1.0,
        titleSpacing: 0.0,
        title: Text(
          'Notifications',
          style: appBarTextStyle,
        ),
      ),
      body: (notificationList.isEmpty)
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    FontAwesomeIcons.bellSlash,
                    color: Colors.grey,
                    size: 60.0,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'No Notifications',
                    style: greyNormalTextStyle,
                  )
                ],
              ),
            )
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: notificationList.length,
              itemBuilder: (context, index) {
                final item = notificationList[index];
                return Dismissible(
                  key: Key('$item'),
                  onDismissed: (direction) {
                    setState(() {
                      notificationList.removeAt(index);
                    });

                    // Then show a snackbar.
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${item['title']} dismissed")));
                  },
                  // Show a red background as the item is swiped away.
                  background: Container(color: Colors.red),
                  child: Center(
                    child: Container(
                      width: width - 20.0,
                      margin: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                      child: Card(
                        elevation: 2.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topLeft,
                              padding: const EdgeInsets.all(10.0),
                              child: CircleAvatar(
                                radius: 40.0,
                                child: Icon(
                                  (item['type'] == 'booking')
                                      ? Icons.hotel
                                      : Icons.local_offer,
                                  size: 30.0,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: width - 130.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, right: 8.0, left: 8.0),
                                    child: Text(
                                      '${item['title']}',
                                      style: blackBigBoldTextStyle,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '${item['desc']}',
                                      style: greySmallTextStyle,
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
              },
            ),
    );
  }
}
