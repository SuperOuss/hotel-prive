// ignore_for_file: library_private_types_in_public_api, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:hotel_prive/constant/constant.dart';
import 'package:hotel_prive/pages/related_place/related_place.dart';
import 'package:hotel_prive/pages/review/review.dart';
import 'package:hotel_prive/widget/column_builder.dart';

class MustVisitPlace extends StatefulWidget {
  final String? title;
  final String? image;
  final String? location;
  final String? rating;
  const MustVisitPlace(
      {Key? key,
      @required this.title,
      @required this.image,
      @required this.location,
      @required this.rating})
      : super(key: key);
  @override
  _MustVisitPlaceState createState() => _MustVisitPlaceState();
}

class _MustVisitPlaceState extends State<MustVisitPlace> {
  Set<Marker>? markers;

  @override
  void initState() {
    super.initState();
    // ignore: prefer_collection_literals
    markers = Set.from([]);
  }

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
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Hero(
      tag: '${widget.title!}',
      child: Scaffold(
        backgroundColor: whiteColor,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: height,
                pinned: true,
                forceElevated: true,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                elevation: 0.0,
                leading: IconButton(
                  color: whiteColor.withOpacity(0.7),
                  icon: Icon(
                    Icons.arrow_back,
                    color: blackColor,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                centerTitle: true,
                title: Text(
                  widget.title!,
                  style: appBarTextStyle,
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    width: width,
                    height: height,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(widget.image!),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      width: width,
                      height: height,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.1, 0.3, 0.6, 0.9],
                          colors: [
                            whiteColor.withOpacity(0.0),
                            whiteColor.withOpacity(0.3),
                            whiteColor.withOpacity(0.6),
                            whiteColor.withOpacity(0.9),
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(fixPadding * 2.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title!,
                              style: extraLargeBlackTextStyle,
                            ),
                            heightSpace,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: greyColor,
                                  size: 22.0,
                                ),
                                const SizedBox(width: 5.0),
                                Text(
                                  widget.location!,
                                  style: greyNormalTextStyle,
                                ),
                              ],
                            ),
                            heightSpace,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.star,
                                    color: Colors.lime[600], size: 22.0),
                                const SizedBox(width: 5.0),
                                Text(widget.rating!,
                                    style: blackNormalTextStyle),
                              ],
                            ),
                            heightSpace,
                            heightSpace,
                            heightSpace,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: ListView(
            children: [
              heightSpace,
              heightSpace,
              // Things to do start
              thingsToDo(),
              // Things to do end
              // About start
              about(),
              // About end
              // Location start
              location(),
              // Location End
              // Review start
              review(),
              // Review end
              // Related places start
              const RelatedPlaces(),
              // Related places end
              // Book Now Button Start
              bookNowButton(),
              // Book Now Button End
            ],
          ),
        ),
      ),
    );
  }

  thingsToDo() {
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: 100.0,
      width: width,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          widthSpace,
          widthSpace,
          thingsToDoTile('assets/icons/plane.png', 'Travel'),
          widthSpace,
          widthSpace,
          thingsToDoTile('assets/icons/cycle.png', 'Cycling'),
          widthSpace,
          widthSpace,
          thingsToDoTile('assets/icons/surf.png', 'Surfing'),
          widthSpace,
          widthSpace,
          thingsToDoTile('assets/icons/trekking.png', 'Trekking'),
          widthSpace,
          widthSpace,
        ],
      ),
    );
  }

  thingsToDoTile(image, title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          image,
          height: 70.0,
          width: 70.0,
        ),
        Text(
          title,
          style: blackSmallTextStyle,
        ),
      ],
    );
  }

  about() {
    return Container(
      padding: EdgeInsets.all(fixPadding * 2.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: blackHeadingTextStyle,
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

  location() {
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(fixPadding * 2.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Location', style: blackBigBoldTextStyle),
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
            style: blackBigBoldTextStyle,
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

  bookNowButton() {
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      borderRadius: BorderRadius.circular(15.0),
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        width: width,
        margin: EdgeInsets.all(fixPadding * 2.0),
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
    );
  }
}
