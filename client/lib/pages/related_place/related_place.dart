// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:travel_pro/constant/constant.dart';

class RelatedPlaces extends StatefulWidget {
  const RelatedPlaces({super.key});

  @override
  _RelatedPlacesState createState() => _RelatedPlacesState();
}

class _RelatedPlacesState extends State<RelatedPlaces> {
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
    return Container(
      padding: EdgeInsets.symmetric(vertical: fixPadding * 2.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
            child: Text(
              'Related Places',
              style: blackBigBoldTextStyle,
            ),
          ),
          heightSpace,
          heightSpace,
          SizedBox(
            height: 250.0,
            width: width,
            child: ListView.builder(
              itemCount: hotelList.length,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final item = hotelList[index];
                return InkWell(
                  onTap: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 160.0,
                        height: 140.0,
                        margin: (index == hotelList.length - 1)
                            ? EdgeInsets.only(
                                left: fixPadding, right: fixPadding * 2.0)
                            : EdgeInsets.only(left: fixPadding * 2.0),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('${item['image']}'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      heightSpace,
                      Container(
                        width: 160.0,
                        margin: (index == hotelList.length - 1)
                            ? EdgeInsets.only(
                                left: fixPadding, right: fixPadding * 2.0)
                            : EdgeInsets.only(left: fixPadding * 2.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${item['name']}',
                              style: blackBigBoldTextStyle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
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
                                const SizedBox(width: 5.0),
                                Text('${item['location']}',
                                    style: greySmallTextStyle),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 18.0,
                                  color: Colors.lime[600],
                                ),
                                const SizedBox(width: 5.0),
                                Text('(${item['rating']}.0)',
                                    style: greySmallTextStyle),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
