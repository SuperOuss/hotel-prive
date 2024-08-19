import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:hotel_prive/constant/constant.dart';
import 'package:hotel_prive/pages/hotel/hotel_on_map.dart';
import 'package:hotel_prive/pages/hotel/hotel_room.dart';
import 'package:hotel_prive/widget/column_builder.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HotelList extends StatefulWidget {
  final List<String>? hotelIds;
  final String? email;

  const HotelList({super.key, this.hotelIds, this.email});

  @override
  _HotelListState createState() => _HotelListState();
}

class _HotelListState extends State<HotelList> {
  List<String>? hotelIds;
  List<Map<String, dynamic>> hotelList = [];
  late Map<String, dynamic> profile;
  bool isLoading = true; // Add this variable

  @override
  void initState() {
    super.initState();
    initialize();
    print('email: ${widget.email}');
  }

  Future<void> initialize() async {
    if (widget.hotelIds != null) {
      setState(() {
        hotelIds = widget.hotelIds?.map((id) => '$id').toList() ?? [];
      });
      print('Received hotelIds: $hotelIds');
      await fetchHotelData();
    } else if (widget.email != null) {
      print('Received email: ${widget.email}');
      await fetchUserData();
      await fetchHotelData();
    }
    setState(() {
      isLoading = false; // Set loading to false after data is fetched
    });
  }

  Future<void> fetchUserData() async {
    if (widget.email != null) {
      final response = await http.get(
          Uri.parse('http://localhost:3000/v1/get-user?email=${widget.email}'));

      if (response.statusCode == 200) {
        setState(() {
          profile = json.decode(response.body);
          print('Fetched user profile: $profile');

          // Extract fav_hotels from the profile and populate hotelIds
          hotelIds = List<String>.from(profile['fav_hotels']);
          print('Hotel IDs: $hotelIds');
        });
      } else {
        print('Failed to load user data');
      }
    }
  }

  Future<void> fetchHotelData() async {
    if (hotelIds != null && hotelIds!.isNotEmpty) {
      final requestBody = jsonEncode(<String, dynamic>{
        'hotelIds': [hotelIds], // Send only the first hotel ID
      });

      print('Sending request body: $requestBody'); // Debug print

      final response = await http.post(
        Uri.parse('http://localhost:3000/v1/get-rates'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        setState(() {
          hotelList =
              List<Map<String, dynamic>>.from(json.decode(response.body));
          print('Received hotel data: $hotelList'); // Debug print
        });
      } else {
        throw Exception('Failed to load hotel data');
      }
    } else {
      print('No hotel IDs available to send'); // Debug print
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 1.0,
        titleSpacing: 0.0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Your hotel deals', style: appBarTextStyle),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HotelOnMap(hotelList: hotelList)));
        },
        backgroundColor: whiteColor,
        child: Icon(
          Icons.map,
          color: primaryColor,
        ),
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(), // Spinner
                  SizedBox(height: 16.0), // Space between spinner and text
                  Text('Please wait while we confirm your hotel deals'),
                ],
              ),
            )
          : ListView(
              children: [
                Container(
                  padding: EdgeInsets.all(fixPadding * 2.0),
                  child: ColumnBuilder(
                    itemCount: hotelList.length,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    itemBuilder: (context, index) {
                      final item = hotelList[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  duration: const Duration(milliseconds: 700),
                                  type: PageTransitionType.fade,
                                  child: HotelRoom(
                                    hotelData: item,
                                    email: widget.email,
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
                              Stack(
                                children: [
                                  Hero(
                                    tag: 'hotelHeroList$index',
                                    child: Container(
                                      width: width - fixPadding * 4.0,
                                      height: 200.0,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                                top: Radius.circular(10.0)),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              '${item['defaultImageUrl']}'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10.0,
                                    left: 10.0,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 5.0),
                                      color: Colors.black.withOpacity(0.5),
                                      child: Text(
                                        '${item['hotelName']}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.all(fixPadding),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 5.0),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              ratingBar(item['stars']),
                                              const SizedBox(width: 5.0),
                                              Text('(${item['stars']}.0)',
                                                  style: greySmallTextStyle),
                                            ],
                                          ),
                                          const SizedBox(height: 5.0),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
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
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '\$${item['offerRetailRate']}',
                                            style: bigPriceTextStyle,
                                          ),
                                          const SizedBox(height: 5.0),
                                          Text(
                                            '\$${item['suggestedSellingPrice']}',
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.grey,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                            ),
                                          ),
                                          const SizedBox(height: 5.0),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 2.0),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            child: Text(
                                              '${item['percentageDifference']} OFF',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 5.0),
                                          Text('per night',
                                              style: greySmallTextStyle),
                                        ],
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
