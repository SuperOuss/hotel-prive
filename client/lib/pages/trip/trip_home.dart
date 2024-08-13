import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:travel_pro/constant/constant.dart';
import 'package:travel_pro/pages/trip/trip_main.dart';

class TripHome extends StatelessWidget {
  const TripHome({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/everest.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          width: width,
          height: height,
          padding: EdgeInsets.all(fixPadding * 1.5),
          alignment: Alignment.bottomLeft,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.1, 0.3, 0.6, 0.9],
              colors: [
                whiteColor.withOpacity(0.0),
                whiteColor.withOpacity(0.3),
                whiteColor.withOpacity(0.7),
                whiteColor.withOpacity(1.0),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(fixPadding * 2.0),
                child: Text(
                  'Where to trip?',
                  style: extraLargeBlackTextStyle,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
                child: Text(
                  'Plan your next trip with TravelPro',
                  style: greyNormalTextStyle,
                ),
              ),
              heightSpace,
              InkWell(
                borderRadius: BorderRadius.circular(10.0),
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.fade,
                          duration: const Duration(milliseconds: 1000),
                          child: const TripMain()));
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
                  padding: EdgeInsets.all(fixPadding),
                  width: 140.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(width: 1.0, color: primaryColor),
                  ),
                  child: Text(
                    'Explore trips',
                    style: primaryColorButtonTextStyle,
                  ),
                ),
              ),
              heightSpace,
              heightSpace,
            ],
          ),
        ),
      ),
    );
  }
}
