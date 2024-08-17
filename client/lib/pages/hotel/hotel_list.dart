// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:hotel_prive/constant/constant.dart';
import 'package:hotel_prive/pages/hotel/hotel_on_map.dart';
import 'package:hotel_prive/pages/hotel/hotel_room.dart';
import 'package:hotel_prive/widget/column_builder.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HotelList extends StatefulWidget {
  final List<String> hotelIds;

  const HotelList({super.key, required this.hotelIds});

  @override
  _HotelListState createState() => _HotelListState();
}

class _HotelListState extends State<HotelList> {
  List<Map<String, dynamic>> hotelList2 = [];
  @override
  void initState() {
    super.initState();
    fetchHotelData();
  }

  Future<void> fetchHotelData() async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/v1/get-rates'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'hotelIds': widget.hotelIds,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        hotelList2 =
            List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      throw Exception('Failed to load hotel data');
    }
  }

  final hotelList = [
    {
      'name': 'Hôtel des Comédies Paris',
      'address': '8 Rue d\'Hauteville, 75010 Paris, France',
      'description': 'Upmarket hotel with an airy lounge/bar',
      'locationLat': 48.866483,
      'locationLang': 2.362437,
      'image': 'assets/hotel/hotel_1.jpg',
      'price': '70',
      'rating': 5,
      'location': 'Paris'
    },
    {
      'name': 'Paris France Hôtel',
      'address': '72 Rue de Turbigo, 75003 Paris, France',
      'description': 'Charming hotel with a lounge & cafe/bar',
      'locationLat': 48.863682,
      'locationLang': 2.360077,
      'image': 'assets/hotel/hotel_2.jpg',
      'price': '45',
      'rating': 5,
      'location': 'Paris'
    },
    {
      'name': 'Pullman Paris Tour Eiffel',
      'address':
          '18 Avenue De Suffren, 22 Rue Jean Rey Entrée Au, 75015 Paris, France',
      'description': 'High-end lodging with Eiffel Tower views',
      'locationLat': 48.855418,
      'locationLang': 2.292332,
      'image': 'assets/hotel/hotel_3.jpg',
      'price': '75',
      'rating': 5,
      'location': 'Paris'
    },
    {
      'name': 'Hôtel Darcet',
      'address': '4 Rue Darcet, 75017 Paris, France',
      'description': 'Simple rooms with free Wi-Fi, plus a bar',
      'locationLat': 48.883499,
      'locationLang': 2.325640,
      'image': 'assets/hotel/hotel_4.jpg',
      'price': '80',
      'rating': 5,
      'location': 'Paris'
    },
    {
      'name': 'Novotel Tour Eiffel Hotel',
      'address': '61 Quai de Grenelle, 75015 Paris, France',
      'description': 'Modern lodging with dining & free Wi-Fi',
      'locationLat': 48.850444,
      'locationLang': 2.283868,
      'image': 'assets/hotel/hotel_5.jpg',
      'price': '29',
      'rating': 3,
      'location': 'Paris'
    },
    {
      'name': 'Shangri-La Hotel',
      'address': '10 Avenue d' 'Iéna, 75116 Paris, France',
      'description': 'Posh hotel with acclaimed dining & a spa',
      'locationLat': 48.863755,
      'locationLang': 2.293532,
      'image': 'assets/hotel/hotel_6.jpg',
      'price': '110',
      'rating': 5,
      'location': 'Paris'
    },
    {
      'name': 'Le Bristol Paris',
      'address': '112 Rue du Faubourg Saint-Honoré, 75008 Paris, France',
      'description': 'Posh hotel with a spa & fine dining',
      'locationLat': 48.871619,
      'locationLang': 2.315213,
      'image': 'assets/hotel/hotel_7.jpg',
      'price': '90',
      'rating': 5,
      'location': 'Paris'
    },
    {
      'name': 'Castille Paris',
      'address': '33-37 Rue Cambon, 75001 Paris, France',
      'description': 'Posh rooms & suites, plus elegant dining',
      'locationLat': 48.865037,
      'locationLang': 2.332377,
      'image': 'assets/hotel/hotel_8.jpg',
      'price': '39',
      'rating': 4,
      'location': 'Paris'
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
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text('Hotel', style: appBarTextStyle),
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
      body: ListView(
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
                              SizedBox(
                                width: width - (fixPadding * 6.0 + 70.0),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
