// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:travel_pro/constant/constant.dart';
import 'package:travel_pro/pages/places/place.dart';
import 'package:travel_pro/pages/places/recommended.dart';
import 'package:travel_pro/pages/trip/must_visit_place.dart';
import 'package:travel_pro/widget/carousel_pro/lib/carousel_pro.dart';

class TripMain extends StatefulWidget {
  const TripMain({super.key});

  @override
  _TripMainState createState() => _TripMainState();
}

class _TripMainState extends State<TripMain> {
  final mustVisitList = [
    {
      'name': 'Swiss Alps',
      'image': 'assets/trips/swiss-alps.jpg',
      'location': 'Switzerland',
      'offer': '15% Off',
      'rating': '5.0'
    },
    {
      'name': 'Mount Logan',
      'image': 'assets/trips/mount-logan.jpg',
      'location': 'Canada',
      'offer': '18% Off',
      'rating': '4.7'
    },
    {
      'name': 'Mount Fuji',
      'image': 'assets/trips/mount-fuji.jpg',
      'location': 'Japan',
      'offer': '10% Off',
      'rating': '4.4'
    },
    {
      'name': 'Mauna Kea',
      'image': 'assets/trips/mouna-kia.jpg',
      'location': 'United States',
      'offer': '10% Off',
      'rating': '4.0'
    },
    {
      'name': 'Grand Teton',
      'image': 'assets/trips/grand-teton.jpg',
      'location': 'Wyoming',
      'offer': '15% Off',
      'rating': '4.8'
    }
  ];

  final popularDestinationList = [
    {'image': 'assets/country/us.jpg', 'name': 'America'},
    {'image': 'assets/country/thailand.jpg', 'name': 'Thailand'},
    {'image': 'assets/country/peris.jpg', 'name': 'Peris'},
    {'image': 'assets/country/england.jpg', 'name': 'England'}
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0.0,
        centerTitle: true,
        title: Text('Trips', style: appBarTextStyle),
      ),
      body: ListView(
        children: [
          // Slider Start
          slider(),
          // Slider End
          heightSpace,
          heightSpace,
          // Must Visit Start
          mustVisit(),
          // Must Visit End
          heightSpace,
          heightSpace,
          // Popular Destination Strat
          popularDestination(),
          // Popular Destination End
          // Recommended Start
          const Recommended(),
          // Recommended End
        ],
      ),
    );
  }

  slider() {
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: 230.0,
      width: width,
      child: Carousel(
        images: const [
          ExactAssetImage('assets/trips/mount-fuji.jpg'),
          ExactAssetImage('assets/trips/swiss-alps.jpg'),
          ExactAssetImage('assets/trips/grand-teton.jpg'),
        ],
        dotSize: 6.0,
        dotSpacing: 18.0,
        dotColor: primaryColor,
        indicatorBgPadding: 5.0,
        dotBgColor: Colors.transparent,
        borderRadius: false,
        moveIndicatorFromBottom: 180.0,
        noRadiusForIndicator: true,
        overlayShadow: true,
        overlayShadowColors: Colors.white,
        overlayShadowSize: 0.7,
      ),
    );
  }

  mustVisit() {
    double width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.only(right: fixPadding * 2.0, left: fixPadding * 2.0),
          child: Text('Must visit this place', style: blackHeadingTextStyle),
        ),
        heightSpace,
        heightSpace,
        SizedBox(
          width: width,
          height: 340.0,
          child: ListView.builder(
            itemCount: mustVisitList.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final item = mustVisitList[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.fade,
                          duration: const Duration(milliseconds: 1000),
                          child: MustVisitPlace(
                              title: item['name'],
                              image: item['image'],
                              location: item['location'],
                              rating: item['rating'])));
                },
                child: Container(
                  width: 150.0,
                  margin: (index == mustVisitList.length - 1)
                      ? EdgeInsets.only(
                          left: fixPadding * 2.0, right: fixPadding * 2.0)
                      : EdgeInsets.only(left: fixPadding * 2.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: item['name']!,
                        child: Container(
                          width: 150.0,
                          height: 200.0,
                          alignment: Alignment.topLeft,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(item['image']!),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                      heightSpace,
                      SizedBox(
                        width: 130.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.star,
                                    color: Colors.lime[600], size: 16.0),
                                const SizedBox(width: 5.0),
                                Text(item['rating']!,
                                    style: blackSmallTextStyle),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              item['name']!,
                              style: blackBigTextStyle,
                              maxLines: 2,
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: greyColor,
                                  size: 18.0,
                                ),
                                Text(
                                  item['location']!,
                                  style: greySmallTextStyle,
                                ),
                              ],
                            ),
                            heightSpace,
                            Container(
                              padding: EdgeInsets.all(fixPadding),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15.0),
                                  bottomRight: Radius.circular(15.0),
                                ),
                                color: Colors.red,
                              ),
                              child: Text(
                                item['offer']!.toUpperCase(),
                                style: whiteSmallTextStyle,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  popularDestination() {
    double width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.only(right: fixPadding * 2.0, left: fixPadding * 2.0),
          child: Text('Popular Destination', style: blackHeadingTextStyle),
        ),
        heightSpace,
        heightSpace,
        SizedBox(
          width: width,
          height: 200.0,
          child: ListView.builder(
            itemCount: popularDestinationList.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final item = popularDestinationList[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.fade,
                          duration: const Duration(milliseconds: 1000),
                          child: Place(
                              title: item['name'], image: item['image'])));
                },
                child: Container(
                  width: 150.0,
                  margin: (index == popularDestinationList.length - 1)
                      ? EdgeInsets.only(
                          left: fixPadding * 2.0, right: fixPadding * 2.0)
                      : EdgeInsets.only(left: fixPadding * 2.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 180.0,
                        height: 150.0,
                        alignment: Alignment.topLeft,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(item['image']!),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      heightSpace,
                      Container(
                        width: 180.0,
                        alignment: Alignment.center,
                        child: Text(
                          item['name']!,
                          style: blackBigTextStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
