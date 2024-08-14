// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:hotel_prive/constant/constant.dart';
import 'package:hotel_prive/pages/hotel/hotel_room.dart';
import 'package:hotel_prive/widget/column_builder.dart';

class Recommended extends StatefulWidget {
  const Recommended({super.key});

  @override
  _RecommendedState createState() => _RecommendedState();
}

class _RecommendedState extends State<Recommended> {
  final recommendedList = [
    {
      'name': 'Hôtel Mercure Paris Centre Tour Eiffel',
      'image': 'assets/hotel/hotel_1.jpg',
      'price': '70',
      'location': 'Paris',
      'rating': 5
    },
    {
      'name': 'Novotel Tour Eiffel Hotel',
      'image': 'assets/hotel/hotel_2.jpg',
      'price': '50',
      'location': 'London',
      'rating': 4
    },
    {
      'name': 'Paris France Hôtel',
      'image': 'assets/hotel/hotel_3.jpg',
      'price': '60',
      'location': 'France',
      'rating': 5
    },
    {
      'name': 'Hotel My Home',
      'image': 'assets/hotel/hotel_4.jpg',
      'price': '55',
      'location': 'Vietnam',
      'rating': 4
    },
    {
      'name': 'Hôtel Darcet',
      'image': 'assets/hotel/hotel_5.jpg',
      'price': '35',
      'location': 'Paris',
      'rating': 3
    },
    {
      'name': 'Novotel Paris Les Halles',
      'image': 'assets/hotel/hotel_6.jpg',
      'price': '80',
      'location': 'Paris',
      'rating': 5
    }
  ];
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(fixPadding * 2.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recommended', style: blackHeadingTextStyle),
          heightSpace,
          heightSpace,
          ColumnBuilder(
            itemCount: recommendedList.length,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            itemBuilder: (context, index) {
              final item = recommendedList[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          duration: const Duration(milliseconds: 700),
                          type: PageTransitionType.fade,
                          child: HotelRoom(
                            title: '${item['name']}',
                            imgPath: '${item['image']}',
                            price: '${item['price']}',
                          )));
                },
                child: Container(
                  width: width - fixPadding * 4.0,
                  margin: EdgeInsets.only(
                    top: (index != 0) ? fixPadding * 2.0 : 0.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
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
                      Hero(
                        tag: '${item['name']}',
                        child: Container(
                          width: width - fixPadding * 4.0,
                          height: 200.0,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(10.0)),
                            image: DecorationImage(
                                image: AssetImage('${item['image']}'),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(fixPadding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${item['name']}',
                                    style: blackBigTextStyle,
                                  ),
                                  const SizedBox(height: 5.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ratingBar(item['rating']),
                                      const SizedBox(width: 5.0),
                                      Text('(${item['rating']}.0)',
                                          style: greySmallTextStyle),
                                    ],
                                  ),
                                  const SizedBox(height: 5.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: greyColor,
                                        size: 18.0,
                                      ),
                                      const SizedBox(width: 5.0),
                                      Text('${item['location']}',
                                          style: greySmallTextStyle),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '\$${item['price']}',
                                  style: bigPriceTextStyle,
                                ),
                                const SizedBox(height: 5.0),
                                Text('per night', style: greySmallTextStyle),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  ratingBar(number) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 1 Star
        Icon(
            (number == 1 ||
                    number == 2 ||
                    number == 3 ||
                    number == 4 ||
                    number == 5)
                ? Icons.star
                : Icons.star_border,
            color: Colors.lime[600]),

        // 2 Star
        Icon(
            (number == 2 || number == 3 || number == 4 || number == 5)
                ? Icons.star
                : Icons.star_border,
            color: Colors.lime[600]),

        // 3 Star
        Icon(
            (number == 3 || number == 4 || number == 5)
                ? Icons.star
                : Icons.star_border,
            color: Colors.lime[600]),

        // 4 Star
        Icon((number == 4 || number == 5) ? Icons.star : Icons.star_border,
            color: Colors.lime[600]),

        // 5 Star
        Icon((number == 5) ? Icons.star : Icons.star_border,
            color: Colors.lime[600]),
      ],
    );
  }
}
