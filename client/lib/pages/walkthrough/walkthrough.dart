import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:hotel_prive/constant/constant.dart';
import 'package:hotel_prive/pages/login_signup/login.dart';

class WalkThrough extends StatefulWidget {
  const WalkThrough({super.key});

  @override
  _WalkThroughState createState() => _WalkThroughState();
}

class _WalkThroughState extends State<WalkThrough> {
  DateTime? currentBackPressTime;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/bg.jpg'), fit: BoxFit.cover),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0.0,
            left: 0.0,
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.1, 0.3, 0.5, 0.7, 0.9],
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.55),
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.8),
                    Colors.black.withOpacity(1.0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            child: PopScope(
              canPop: false,
              onPopInvoked: (bool key) {
                bool backStatus = onWillPop();
                if (backStatus) {
                  exit(0);
                }
              },
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(fixPadding * 2.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Welcome,',
                                style: walkthroughWhiteBigTextStyle,
                              ),
                              const SizedBox(width: 7.0),
                              Text(
                                'dear traveller,',
                                style: walkthroughPrimaryColorBigTextStyle,
                              ),
                            ],
                          ),
                          Text(
                            'to Hotel Privé',
                            style: walkthroughWhiteBigTextStyle,
                          ),
                          const SizedBox(height: 20.0),
                          Text(
                            'You have been invited to sample our private selection of exclusive hotel deals',
                            style: walkrhroughWhiteSmallTextStyle,
                          ),
                          SizedBox(height: 10),
                          Text('Invite token n° OENFZBU',
                              style: whiteExtraSmallTextStyle),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50.0),
                    Container(
                      width: width,
                      alignment: Alignment.center,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  duration: const Duration(milliseconds: 600),
                                  type: PageTransitionType.fade,
                                  child: const Login()));
                        },
                        child: Container(
                          width: 60.0,
                          height: 60.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Text(
                            'Start',
                            style: whiteSmallTextStyle,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
        msg: 'Press Back Once Again to Exit.',
        backgroundColor: Colors.black,
        textColor: whiteColor,
      );
      return false;
    } else {
      return true;
    }
  }
}
