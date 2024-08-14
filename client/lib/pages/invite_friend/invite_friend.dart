// ignore_for_file: library_private_types_in_public_api

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hotel_prive/constant/constant.dart';

class InviteFriend extends StatefulWidget {
  const InviteFriend({super.key});

  @override
  _InviteFriendState createState() => _InviteFriendState();
}

class _InviteFriendState extends State<InviteFriend> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 1.0,
        titleSpacing: 0.0,
        title: Text(
          'Invite Friends',
          style: appBarTextStyle,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: blackColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(fixPadding * 2.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Share code & save at least 25%',
                  style: blackBigTextStyle,
                ),
                const SizedBox(height: 5.0),
                Text(
                  'Your friend gets \$15 TravelPro cash on sign up. You get \$15 when they book trip or experience of \$75 or more within 21 days. You can earn upto \$200 TravelPro Cash.',
                  style: greySmallTextStyle,
                ),
              ],
            ),
          ),
          heightSpace,
          Container(
            color: Colors.grey[200],
            padding: EdgeInsets.all(fixPadding * 2.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Your Referral Code',
                  style: blackSmallTextStyle,
                ),
                heightSpace,
                DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(10),
                  strokeWidth: 1.2,
                  color: greyColor.withOpacity(0.6),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: Container(
                      width: 200.0,
                      padding: EdgeInsets.all(fixPadding),
                      decoration: BoxDecoration(color: whiteColor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'SLP809',
                            style: blackBigTextStyle,
                          ),
                          InkWell(
                            onTap: () {},
                            child: Icon(
                              Icons.content_copy,
                              color: primaryColor,
                              size: 25.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                heightSpace,
                heightSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: (width - (fixPadding * 6.0)) / 2.0,
                      padding: EdgeInsets.all(fixPadding),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.green.withOpacity(0.6),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Whatsapp',
                            style: whiteSmallTextStyle,
                          ),
                          Icon(FontAwesomeIcons.whatsapp,
                              color: whiteColor, size: 25.0),
                        ],
                      ),
                    ),
                    Container(
                      width: (width - (fixPadding * 6.0)) / 2.0,
                      padding: EdgeInsets.all(fixPadding),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(width: 0.3, color: greyColor),
                        color: whiteColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'More Options',
                            style: blackSmallTextStyle,
                          ),
                          Icon(Icons.share, color: blackColor, size: 22.0),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
