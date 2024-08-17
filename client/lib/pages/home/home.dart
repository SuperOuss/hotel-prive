// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:hotel_prive/pages/hotel/hotel_list.dart';
import 'package:page_transition/page_transition.dart';
import 'package:hotel_prive/constant/constant.dart';
import 'package:hotel_prive/pages/experience/experience.dart';
import 'package:hotel_prive/pages/places/recommended.dart';
import 'package:hotel_prive/pages/profile/profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Homne extends StatefulWidget {
  final String? email;

  const Homne({super.key, this.email});

  @override
  _HomneState createState() => _HomneState();
}



class _HomneState extends State<Homne> {
  //main objects
  List<Map<String, dynamic>> popularPlacesList = [];
  Map<String, dynamic>? profile;
  bool isLoading = false;

//init state
  @override
  void initState() {
    super.initState();
    print('Email passed to Homne: ${widget.email}');
    fetchUserData();
  }

  final popularExperiencesList = [
    {
      'name': 'Wine not taste our passion?',
      'image': 'assets/popular_experiences/popular_experiences_1.jpg',
      'type': 'Wine tasting',
      'price': '35',
      'rating': '4.9'
    },
    {
      'name': 'Fine Wines & Ruin Bars',
      'image': 'assets/popular_experiences/popular_experiences_2.jpg',
      'type': 'Wine tasting',
      'price': '61',
      'rating': '5.0'
    },
    {
      'name': 'Budapest Boat Cruise With a Bonus Drink',
      'image': 'assets/popular_experiences/popular_experiences_3.jpg',
      'type': 'Boat ride',
      'price': '31',
      'rating': '4.81'
    },
    {
      'name': 'Budapest Historic and Cultural Tour',
      'image': 'assets/popular_experiences/popular_experiences_4.jpg',
      'type': 'History walk',
      'price': '64',
      'rating': '5.0'
    },
    {
      'name': 'Private Scenic Travel Photo Shoot',
      'image': 'assets/popular_experiences/popular_experiences_5.jpg',
      'type': 'Photo shoot',
      'price': '64',
      'rating': '4.96'
    },
    {
      'name': 'BudapEster - Walking \'n\' street food',
      'image': 'assets/popular_experiences/popular_experiences_6.jpg',
      'type': 'History walk',
      'price': '69',
      'rating': '4.98'
    }
  ];
  Future<Map<String, dynamic>> fetchDealsCount(double latitude,
      double longitude, String countryCode, String city) async {
    final response = await http.get(Uri.parse(
        'http://localhost:3000/v1/get-deals?lat=$latitude&lon=$longitude&countryCode=$countryCode&city=$city'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data['results']);
      print(data['dealCount']);
      return {
        'dealCount': data['dealCount'],
        'hotelIds': data['results'].map((result) => result['hotelId']).toList(),
      };
    } else {
      print('Failed to load deals count');
      return {
        'dealCount': 0,
        'hotelIds': [],
      };
    }
  }

  Future<void> fetchUserData() async {
    if (widget.email != null) {
      final response = await http.get(
          Uri.parse('http://localhost:3000/v1/get-user?email=${widget.email}'));

      if (response.statusCode == 200) {
        setState(() {
          profile = json.decode(response.body);
          print('Fetched user profile: $profile');
        });
        updatePopularPlacesList();
      } else {
        print('Failed to load user data');
      }
    }
  }

  Future<String> fetchCityImage(String cityName) async {
    final response = await http.get(Uri.parse(
        'https://api.unsplash.com/photos/random?query=$cityName&client_id=TGy1U2upYzZGIXg4SYGDcxNUDoToBSKN28iWSfKwQcc'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['urls']['small_s3'];
    } else {
      print('Failed to load image for $cityName');
      return 'https://www.shutterstock.com/image-vector/city-skyline-vector-illustration-urban-260nw-720375790.jpg'; // Fallback image URL
    }
  }

  void updatePopularPlacesList() async {
    if (profile != null && profile!['fav_locations'] != null) {
      List<Map<String, dynamic>> updatedList = [];

      for (var location in profile!['fav_locations']) {
        updatedList.add({
          'name': location['city'],
          'image': await fetchCityImage(location['city']),
          'deals': 'Fetching deals...',
          'loading': true,
          'latitude': location['latitude'],
          'longitude': location['longitude'],
          'countryCode': location['countryCode'],
          'city': location['city'],
          'hotelIds': [],
        });
      }

      setState(() {
        popularPlacesList = updatedList;
      });

      for (var i = 0; i < updatedList.length; i++) {
        final result = await fetchDealsCount(
          updatedList[i]['latitude'],
          updatedList[i]['longitude'],
          updatedList[i]['countryCode'],
          updatedList[i]['city'],
        );

        setState(() {
          popularPlacesList[i]['deals'] = '${result['dealCount']} deals';
          popularPlacesList[i]['loading'] = false;
          popularPlacesList[i]['hotelIds'] = result['hotelIds'];
        });
      }
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: ListView(
        children: [
          heightSpace,
          heightSpace,
          Container(
            padding: EdgeInsets.all(fixPadding * 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, Oussama',
                      style: smallBoldGreyTextStyle,
                    ),
                    Text(
                      'Your deals',
                      style: extraLargeBlackTextStyle,
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            duration: const Duration(milliseconds: 700),
                            type: PageTransitionType.fade,
                            child: const Profile()));
                  },
                  child: Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      image: const DecorationImage(
                        image: AssetImage('assets/profil.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Search Start
          Container(
            height: 55.0,
            padding: EdgeInsets.all(fixPadding * 1.5),
            margin: EdgeInsets.all(fixPadding * 2.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(width: 1.0, color: greyColor.withOpacity(0.6)),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search city, hotel, etc',
                hintStyle: greyNormalTextStyle,
                prefixIcon: const Icon(Icons.search),
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(
                    top: fixPadding * 0.78, bottom: fixPadding * 0.78),
              ),
            ),
          ),
          // Search End
          // Popular Places Start
          popularPlaces(),
          // Popular Places End
          heightSpace,
          heightSpace,
          // Popular Experiences Start
          popularExperiences(),
          // Popular Experiences End
          heightSpace,
          // Recommended Start
          const Recommended(),
          // Recommended End
        ],
      ),
    );
  }

  Widget popularPlaces() {
  double width = MediaQuery.of(context).size.width;
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Padding(
        padding: EdgeInsets.only(right: fixPadding * 2.0, left: fixPadding * 2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Your locations', style: blackHeadingTextStyle),
            Text('View all', style: smallBoldGreyTextStyle),
          ],
        ),
      ),
      heightSpace,
      heightSpace,
      SizedBox(
        width: width,
        height: 150.0,
        child: ListView.builder(
          itemCount: popularPlacesList.length,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final item = popularPlacesList[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    duration: const Duration(milliseconds: 1000),
                    child: HotelList(
                      hotelIds: item['hotelIds'], // Pass hotelIds here
                    ),
                  ),
                );
              },
              child: Container(
                width: 130.0,
                margin: (index == popularPlacesList.length - 1)
                    ? EdgeInsets.only(left: fixPadding, right: fixPadding * 2.0)
                    : (index == 0)
                        ? EdgeInsets.only(left: fixPadding * 2.0)
                        : EdgeInsets.only(left: fixPadding),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(item['image']!),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Container(
                  width: 130.0,
                  height: 150.0,
                  padding: EdgeInsets.all(fixPadding * 1.5),
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.1, 0.5, 0.9],
                      colors: [
                        blackColor.withOpacity(0.0),
                        blackColor.withOpacity(0.3),
                        blackColor.withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['name']!, style: whiteSmallBoldTextStyle),
                      item['loading'] == true
                          ? CircularProgressIndicator()
                          : Text(item['deals']!, style: whiteExtraSmallTextStyle),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}

  popularExperiences() {
    double width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding:
              EdgeInsets.only(right: fixPadding * 2.0, left: fixPadding * 2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Popular Experiences', style: blackHeadingTextStyle),
              Text('View all', style: smallBoldGreyTextStyle),
            ],
          ),
        ),
        heightSpace,
        heightSpace,
        SizedBox(
          width: width,
          height: 295.0,
          child: ListView.builder(
            itemCount: popularExperiencesList.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final item = popularExperiencesList[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.fade,
                          duration: const Duration(milliseconds: 1000),
                          child: Experience(
                            title: item['name'],
                          )));
                },
                child: Container(
                  width: 130.0,
                  margin: (index == popularExperiencesList.length - 1)
                      ? EdgeInsets.only(
                          left: fixPadding, right: fixPadding * 2.0)
                      : (index == 0)
                          ? EdgeInsets.only(left: fixPadding * 2.0)
                          : EdgeInsets.only(left: fixPadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 130.0,
                        height: 150.0,
                        padding: EdgeInsets.all(fixPadding * 1.5),
                        alignment: Alignment.bottomLeft,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(item['image']!),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
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
                            Text(
                              item['type']!,
                              style: greyNormalTextStyle,
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              'From \$${item['price']}/person',
                              style: blackSmallTextStyle,
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
        ),
      ],
    );
  }
}
