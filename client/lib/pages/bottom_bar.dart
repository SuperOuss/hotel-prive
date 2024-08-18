// bottom_bar.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hotel_prive/constant/constant.dart';
import 'package:hotel_prive/pages/favorite/favorite.dart';
import 'package:hotel_prive/pages/home/home.dart';
import 'package:hotel_prive/pages/hotel/hotel_list.dart';
import 'package:hotel_prive/pages/profile/profile.dart';
import 'package:hotel_prive/pages/trip/trip_home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BottomBar extends StatefulWidget {
  final String? email;

  const BottomBar({super.key, this.email});

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int currentIndex = 0;
  DateTime? currentBackPressTime;
  Map<String, dynamic>? profile;

  //init state
  @override
  void initState() {
    super.initState();
    print('Email passed to Homne: ${widget.email}');
    fetchUserData();
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
      } else {
        print('Failed to load user data');
      }
    }
  }

  changeIndex(index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: (Platform.isIOS) ? 120.0 : 80.0,
        child: BottomAppBar(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              getBottomBarItemTile(0, Icons.home),
              getBottomBarItemTile(1, Icons.hotel),
              getBottomBarItemTile(2, Icons.search),
              getBottomBarItemTile(3, Icons.favorite),
              getBottomBarItemTile(4, Icons.person),
            ],
          ),
        ),
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (bool key) {
          bool backStatus = onWillPop();
          if (backStatus) {
            exit(0);
          }
        },
        child: getCurrentPage(),
      ),
    );
  }

  Widget getCurrentPage() {
    switch (currentIndex) {
      case 0:
        return Homne(email: widget.email);
      case 1:
        return HotelList(email: widget.email);
      case 2:
        return const TripHome();
      case 3:
        return const Favorite();
      case 4:
        return const Profile();
      default:
        return Homne(email: widget.email);
    }
  }

  getBottomBarItemTile(int index, icon) {
    return InkWell(
      borderRadius: BorderRadius.circular(30.0),
      focusColor: primaryColor,
      onTap: () {
        changeIndex(index);
      },
      child: Container(
        height: 60.0,
        width: 60.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color:
              (currentIndex == index) ? Colors.grey[100] : Colors.transparent,
        ),
        child: Icon(icon,
            size: 30.0,
            color: (currentIndex == index) ? primaryColor : greyColor),
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