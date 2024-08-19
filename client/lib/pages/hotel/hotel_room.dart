import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:hotel_prive/constant/constant.dart';
import 'package:hotel_prive/pages/hotel/selectHotelDate.dart';
import 'package:hotel_prive/pages/related_place/related_place.dart';
import 'package:hotel_prive/pages/review/review.dart';
import 'package:hotel_prive/widget/carousel_pro/lib/carousel_pro.dart';
import 'package:hotel_prive/widget/column_builder.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart' as html;

class HotelRoom extends StatefulWidget {
  final Map<String, dynamic>? hotelData;
  final String? email;

  const HotelRoom({super.key, this.hotelData, this.email});

  @override
  _HotelRoomState createState() => _HotelRoomState();
}

class _HotelRoomState extends State<HotelRoom> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool favorite = false;
  Set<Marker> markers = {};
  List<dynamic> reviews = [];
  Map<String, dynamic>? fullHotelData;
  String sentiment = '';
  List<Widget> roomWidgets = [];
  List rooms = [];

  @override
  void initState() {
    super.initState();
    //markers = Set.from([]);
    print(widget.hotelData);
    final hotelId = widget.hotelData?['hotelId'];
    if (hotelId != null) {
      _fetchAndSetHotelData(hotelId);
      fetchReviews(hotelId).then((fetchedReviews) {
        setState(() {
          reviews = fetchedReviews;
        });
      });
    }
    print('email: ${widget.email}');
  }

  Future<void> _fetchAndSetHotelData(String hotelId) async {
    final fetchedHotelData = await fetchHotelData(hotelId);
    setState(() {
      fullHotelData = {
        ...fetchedHotelData,
        'offerRetailRate': widget.hotelData?['offerRetailRate'],
        'suggestedSellingPrice': widget.hotelData?['suggestedSellingPrice'],
        'percentageDifference': widget.hotelData?['percentageDifference']
      };
      rooms = fullHotelData?['rooms'] ?? [];
    });
  }

  Future<List<dynamic>> fetchReviews(String hotelId) async {
    print(hotelId);
    final String url = 'http://localhost:3000/v1/reviews?hotelId=$hotelId';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        final String fetchedSentiment = responseData['sentimentAnalysis'] ?? '';
        print(fetchedSentiment);

        setState(() {
          sentiment = fetchedSentiment;
          reviews = responseData['reviews'] ?? [];
        });

        return reviews;
      } else {
        throw Exception('Failed to load reviews');
      }
    } catch (e) {
      print('Error fetching reviews: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> fetchHotelData(String hotelId) async {
    final String url =
        'http://localhost:3000/v1/get-hotel-details?hotelId=$hotelId';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> hotelData = json.decode(response.body);
        print('Hotel Name: ${hotelData['name']}');
        return hotelData;
      } else {
        throw Exception('Failed to load hotel data');
      }
    } catch (e) {
      print('Error fetching hotel data: $e');
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final hotelData = widget.hotelData!;
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: whiteColor,
        appBar: AppBar(
          backgroundColor: whiteColor,
          elevation: 0.0,
          titleSpacing: 0.0,
          title: fullHotelData != null
              ? Text(fullHotelData!['name'], style: appBarTextStyle)
              : Text('Loading...', style: appBarTextStyle),
          actions: [
            IconButton(
              icon: Icon((favorite) ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                setState(() {
                  favorite = !favorite;
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      favorite ? 'Added to Favorite' : 'Removed from Favorite'),
                ));
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
                      '\$${hotelData['offerRetailRate']}',
                      style: blackBigBoldTextStyle,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      '\$${hotelData['suggestedSellingPrice']}',
                      style: smallBoldGreyTextStyle.copyWith(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                    if (hotelData['percentageDifference'] != null)
                      Container(
                        margin: EdgeInsets.only(left: 8.0),
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        color: Colors.red,
                        child: Text(
                          '-${hotelData['percentageDifference']}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                             hotelData: fullHotelData!,
                             email: widget.email,
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
              tag: 'hotelHeroMain',
              child: fullHotelData != null &&
                      fullHotelData?['hotelImages'] != null
                  ? slider(
                      List<Map<String, dynamic>>.from(
                              fullHotelData!['hotelImages'])
                          .take(10)
                          .toList(),
                    )
                  : Container(), // Placeholder widget if fullHotelData or hotelImages is null
            ),
            titleRating(hotelData['hotelName'], hotelData['stars'],
                hotelData['location']),
            divider(),
            // Sentiment Analysis Text Block
            if (sentiment.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reviews Sentiment Analysis',
                      style: blackBigTextStyle,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      sentiment,
                      style: greySmallTextStyle,
                    ),
                  ],
                ),
              ),
            facility(),
            divider(),
            aboutThisPlace(),
            divider(),
            location(),
            divider(),
            review(),
            const RelatedPlaces(),
          ],
        ));
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

  slider(List<Map<String, dynamic>> hotelImages) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // Sort the images to ensure the default image is first
    hotelImages.sort((a, b) {
      if (a['defaultImage'] == true) return -1;
      if (b['defaultImage'] == true) return 1;
      return 0;
    });

    // Extract the URLs and wrap them with Image widget
    List<Widget> imageWidgets = hotelImages.map((image) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0), // Optional: Add border radius
        child: Image.network(
          image['url'],
          fit: BoxFit.cover,
          width: width,
          height: height / 2.3,
        ),
      );
    }).toList();

    return SizedBox(
      height: height / 2.3,
      width: width,
      child: Carousel(
        images: imageWidgets,
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
        boxFit: BoxFit.cover, // Ensure images fit correctly
        autoplay: false, // Enable autoplay
        //autoplayDuration: Duration(seconds: 3), // Duration between transitions
      ),
    );
  }

  titleRating(String hotelName, dynamic stars, String location) {
    // Ensure stars is a string
    String starsStr = stars.toString();
    return Container(
      padding: EdgeInsets.all(fixPadding * 2.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hotelName,
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
                starsStr,
                style: blackSmallTextStyle,
              ),
              const SizedBox(width: 3.0),
              Text(
                '',
                style: greySmallTextStyle,
              ),
              widthSpace,
              Text(
                location,
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
          html.Html(
            data: fullHotelData?['hotelDescription'] ?? '',
            style: {
              "body": html.Style(
                fontSize: html.FontSize(14.0),
                color: Colors.grey,
              ),
            },
          ),
        ],
      ),
    );
  }

  location() {
    double width = MediaQuery.of(context).size.width;
    double latitude = fullHotelData?['location']['latitude'] ?? 47.4517861;
    double longitude = fullHotelData?['location']['longitude'] ?? 18.973275;
    print('Latitude: $latitude, Longitude: $longitude');

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
                markers: markers,
                onMapCreated: (GoogleMapController controller) {
                  print('Map created');
                  Marker m = Marker(
                    markerId: MarkerId('1'),
                    position: LatLng(latitude, longitude),
                  );
                  setState(() {
                    markers.add(m);
                  });
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(latitude, longitude),
                  zoom: 8,
                ),
                onCameraMove: (CameraPosition position) {
                  print('Camera position: ${position.target}');
                },
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
          itemCount: reviews.length > 10 ? 10 : reviews.length,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          itemBuilder: (context, index) {
            final item = reviews[index];
            return Container(
              margin: (index == 0)
                  ? EdgeInsets.symmetric(horizontal: fixPadding * 2.0)
                  : EdgeInsets.only(
                      top: fixPadding * 2.0,
                      right: fixPadding * 2.0,
                      left: fixPadding * 2.0),
              padding: EdgeInsets.all(fixPadding * 2.0),
              width: width -
                  fixPadding * 4.0, // Set a fixed width for the review boxes
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
                  Text(
                    '${item['name']}',
                    style: blackSmallBoldTextStyle,
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    '${item['date']}',
                    style: greySmallTextStyle,
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    'Rating: ${item['averageScore']}',
                    style: blackNormalTextStyle,
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    'Pros: ${item['pros']}',
                    style: blackNormalTextStyle,
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    'Cons: ${item['cons']}',
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
                        reviewList: reviews,
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
