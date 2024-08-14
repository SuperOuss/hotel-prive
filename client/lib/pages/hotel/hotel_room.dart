// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:hotel_prive/constant/constant.dart';
import 'package:hotel_prive/pages/hotel/selectHotelDate.dart';
import 'package:hotel_prive/pages/related_place/related_place.dart';
import 'package:hotel_prive/pages/review/review.dart';
import 'package:hotel_prive/widget/carousel_pro/lib/carousel_pro.dart';
import 'package:hotel_prive/widget/column_builder.dart';

class HotelRoom extends StatefulWidget {
  final String? title, imgPath, price;
  const HotelRoom(
      {Key? key,
      @required this.title,
      @required this.imgPath,
      @required this.price})
      : super(key: key);
  @override
  _HotelRoomState createState() => _HotelRoomState();
}

class _HotelRoomState extends State<HotelRoom> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool favorite = false;
  Set<Marker>? markers;

  final ratingList = [
    {
      'name': 'Ersel',
      'image': 'assets/user/user_1.jpg',
      'rating': 5,
      'review': 'Everthing was ok and the location is nice.',
      'time': 'August 2020'
    },
    {
      'name': 'Jane',
      'image': 'assets/user/user_2.jpg',
      'rating': 5,
      'review': 'Great spot!',
      'time': 'August 2020'
    },
    {
      'name': 'Apollonia',
      'image': 'assets/user/user_3.jpg',
      'rating': 5,
      'review': 'Awesome place.',
      'time': 'July 2020'
    },
    {
      'name': 'Beatriz',
      'image': 'assets/user/user_4.jpg',
      'rating': 5,
      'review': 'Really nice!',
      'time': 'June 2020'
    },
    {
      'name': 'Linnea',
      'image': 'assets/user/user_5.jpg',
      'rating': 5,
      'review': 'Fabulous place.',
      'time': 'May 2020'
    },
    {
      'name': 'Ronan',
      'image': 'assets/user/user_6.jpg',
      'rating': 5,
      'review': 'Fantastic.',
      'time': 'April 2020'
    },
    {
      'name': 'Brayden',
      'image': 'assets/user/user_7.jpg',
      'rating': 5,
      'review': 'Must visit.',
      'time': 'Fabruary 2020'
    },
    {
      'name': 'Hugo',
      'image': 'assets/user/user_8.jpg',
      'rating': 5,
      'review': 'It\'s clean and nice.',
      'time': 'January 2020'
    }
  ];

  @override
  void initState() {
    super.initState();
    // ignore: prefer_collection_literals
    markers = Set.from([]);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0.0,
        titleSpacing: 0.0,
        title: Text(widget.title!, style: appBarTextStyle),
        actions: [
          IconButton(
            icon: Icon((favorite) ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              setState(() {
                favorite = !favorite;
              });
              if (favorite) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Added to Favorite'),
                ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Remove from Favorite'),
                ));
              }
            },
          )
        ],
      ),
      bottomNavigationBar: Material(
        elevation: 5.0,
        child: Container(
          color: Colors.white,
          width: width,
          height: 70.0,
          padding: EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
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
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: SelectHotelDate(
                            price: widget.price!,
                          )));
                },
                child: Container(
                  padding: EdgeInsets.only(
                      top: fixPadding,
                      bottom: fixPadding,
                      right: fixPadding * 2.0,
                      left: fixPadding * 2.0),
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
            ],
          ),
        ),
      ),
      body: ListView(
        children: [
          Hero(
            tag: widget.title!,
            child: slider(),
          ),

          // Title Rating Start
          titleRating(),
          // Title Rating End
          divider(),
          // Facility Start
          facility(),
          // Facility End
          divider(),
          // About this place start
          aboutThisPlace(),
          // About this place end
          divider(),
          // Sleeping Arrangement Start
          sleepingArrangement(),
          // Sleeping Arrangement End
          divider(),
          // Location Start
          location(),
          // Location End
          divider(),
          // Review Start
          review(),
          // Review End
          // Related Places Start
          const RelatedPlaces(),
          // Related Places End
        ],
      ),
    );
  }

  divider() {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: 1.0,
      color: greyColor.withOpacity(0.2),
      margin: EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
    );
  }

  slider() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height / 2.3,
      width: width,
      child: Carousel(
        images: [
          ExactAssetImage(widget.imgPath!),
          ExactAssetImage(widget.imgPath!),
          ExactAssetImage(widget.imgPath!),
        ],
        dotSize: 6.0,
        dotSpacing: 18.0,
        dotColor: primaryColor,
        indicatorBgPadding: 10.0,
        dotBgColor: Colors.transparent,
        borderRadius: false,
        moveIndicatorFromBottom: 180.0,
        noRadiusForIndicator: true,
        overlayShadow: false,
        overlayShadowColors: Colors.white,
        overlayShadowSize: 0.7,
      ),
    );
  }

  titleRating() {
    return Container(
      padding: EdgeInsets.all(fixPadding * 2.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title!,
            style: blackHeadingTextStyle,
          ),
          heightSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.star, color: Colors.lime[600], size: 18.0),
              const SizedBox(width: 5.0),
              Text(
                '5.0',
                style: blackSmallTextStyle,
              ),
              const SizedBox(width: 3.0),
              Text(
                '(12)',
                style: greySmallTextStyle,
              ),
              widthSpace,
              Text(
                'Budapest, Hungary',
                style: primaryColorSmallTextStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }

  facility() {
    double width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(fixPadding * 2.0),
          child: Text(
            'Facility',
            style: blackBigTextStyle,
          ),
        ),
        Container(
          padding: EdgeInsets.only(bottom: fixPadding * 2.0),
          width: width,
          height: 130.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              horizontalSpace(),
              facilityTile('assets/icons/parking.png', 'Free Parking'),
              horizontalSpace(),
              facilityTile('assets/icons/lift.png', 'Lift'),
              horizontalSpace(),
              facilityTile('assets/icons/wifi.png', 'Wifi'),
              horizontalSpace(),
              facilityTile('assets/icons/kitchen.png', 'Kitchen'),
              horizontalSpace(),
              facilityTile('assets/icons/ac.png', 'Air conditioning'),
              horizontalSpace(),
              facilityTile('assets/icons/tv.png', 'Television'),
              horizontalSpace(),
            ],
          ),
        ),
      ],
    );
  }

  horizontalSpace() {
    return SizedBox(width: fixPadding * 2.0);
  }

  facilityTile(imgPath, title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 70.0,
          height: 70.0,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(35.0),
            border: Border.all(width: 0.7, color: primaryColor),
            boxShadow: <BoxShadow>[
              BoxShadow(
                blurRadius: 1.0,
                spreadRadius: 1.0,
                color: Colors.grey[300]!,
              ),
            ],
          ),
          child: Image.asset(
            imgPath,
            width: 40.0,
            height: 40.0,
          ),
        ),
        heightSpace,
        Text(
          title,
          style: primaryColorSmallTextStyle,
        ),
      ],
    );
  }

  aboutThisPlace() {
    return Container(
      padding: EdgeInsets.all(fixPadding * 2.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About this Place',
            style: blackBigTextStyle,
          ),
          heightSpace,
          Text(
            'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
            style: greySmallTextStyle,
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  sleepingArrangement() {
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(fixPadding * 2.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sleeping arrangements', style: blackBigTextStyle),
          heightSpace,
          heightSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(fixPadding * 2.0),
                width: (width - (fixPadding * 6.0 + 2.8)) / 2,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(width: 0.7, color: primaryColor),
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
                    Image.asset('assets/icons/bed.png',
                        width: 35.0, height: 35.0),
                    heightSpace,
                    Text(
                      'Bedroom 1',
                      style: blackSmallBoldTextStyle,
                    ),
                    Text(
                      '1 queen bed',
                      style: greySmallTextStyle,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(fixPadding * 2.0),
                width: (width - (fixPadding * 6.0 + 2.8)) / 2,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(width: 0.7, color: primaryColor),
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
                    Image.asset('assets/icons/bed.png',
                        width: 35.0, height: 35.0),
                    heightSpace,
                    Text(
                      'Bedroom 2',
                      style: blackSmallBoldTextStyle,
                    ),
                    Text(
                      '1 king bed',
                      style: greySmallTextStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  location() {
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(fixPadding * 2.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Location', style: blackBigTextStyle),
          heightSpace,
          heightSpace,
          Container(
            width: width - fixPadding * 4.0,
            height: 250.0,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  blurRadius: 1.0,
                  spreadRadius: 1.0,
                  color: Colors.grey[300]!,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: GoogleMap(
                markers: markers!,
                onMapCreated: (GoogleMapController controller) {
                  Marker m = const Marker(
                      markerId: MarkerId('1'),
                      position: LatLng(47.4517861, 18.973275));
                  setState(() {
                    markers!.add(m);
                  });
                },
                initialCameraPosition: const CameraPosition(
                    target: LatLng(47.4517861, 18.973275), zoom: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  review() {
    double width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(fixPadding * 2.0),
          child: Text(
            'Review',
            style: blackBigTextStyle,
          ),
        ),
        ColumnBuilder(
          itemCount: 3,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          itemBuilder: (context, index) {
            final item = ratingList[index];
            return Container(
              margin: (index == 0)
                  ? EdgeInsets.symmetric(horizontal: fixPadding * 2.0)
                  : EdgeInsets.only(
                      top: fixPadding * 2.0,
                      right: fixPadding * 2.0,
                      left: fixPadding * 2.0),
              padding: EdgeInsets.all(fixPadding * 2.0),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(15.0),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 70.0,
                        height: 70.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35.0),
                          image: DecorationImage(
                            image: AssetImage('${item['image']}'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      widthSpace,
                      SizedBox(
                        width: width - (fixPadding * 8.0 + 10.0 + 70.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${item['name']}',
                              style: blackSmallBoldTextStyle,
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              '${item['time']}',
                              style: greySmallTextStyle,
                            ),
                            const SizedBox(height: 5.0),
                            ratingBar(item['rating']),
                          ],
                        ),
                      )
                    ],
                  ),
                  heightSpace,
                  Text(
                    '${item['review']}',
                    style: blackNormalTextStyle,
                  ),
                ],
              ),
            );
          },
        ),
        Padding(
          padding: EdgeInsets.all(fixPadding * 2.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(15.0),
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      duration: const Duration(milliseconds: 600),
                      type: PageTransitionType.rightToLeftWithFade,
                      child: Review(
                        reviewList: ratingList,
                      )));
            },
            child: Container(
              padding: EdgeInsets.all(fixPadding * 1.5),
              width: width - fixPadding * 4.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(width: 1.0, color: primaryColor),
              ),
              child: Text(
                'Show all reviews',
                style: primaryColorButtonTextStyle,
              ),
            ),
          ),
        ),
      ],
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
          color: Colors.lime[600],
          size: 18.0,
        ),

        // 2 Star
        Icon(
          (number == 2 || number == 3 || number == 4 || number == 5)
              ? Icons.star
              : Icons.star_border,
          color: Colors.lime[600],
          size: 18.0,
        ),

        // 3 Star
        Icon(
          (number == 3 || number == 4 || number == 5)
              ? Icons.star
              : Icons.star_border,
          color: Colors.lime[600],
          size: 18.0,
        ),

        // 4 Star
        Icon(
          (number == 4 || number == 5) ? Icons.star : Icons.star_border,
          color: Colors.lime[600],
          size: 18.0,
        ),

        // 5 Star
        Icon(
          (number == 5) ? Icons.star : Icons.star_border,
          color: Colors.lime[600],
          size: 18.0,
        ),
      ],
    );
  }
}
