// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:hotel_prive/constant/constant.dart';
import 'package:hotel_prive/pages/experience/selectDate.dart';
import 'package:hotel_prive/widget/carousel_pro/lib/carousel_pro.dart';

class Experience extends StatefulWidget {
  final String? title;
  const Experience({Key? key, @required this.title}) : super(key: key);
  @override
  _ExperienceState createState() => _ExperienceState();
}

class _ExperienceState extends State<Experience> {
  Set<Marker>? markers;

  @override
  void initState() {
    super.initState();
    // ignore: prefer_collection_literals
    markers = Set.from([]);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0.0,
        titleSpacing: 0.0,
        title: Text(widget.title!, style: appBarTextStyle),
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
                    'From \$64',
                    style: blackBigBoldTextStyle,
                  ),
                  Text(
                    ' / person',
                    style: blackSmallTextStyle,
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: const SelectDate()));
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
          // Slider Start
          slider(),
          // Slider End
          // Name Rating Start
          nameRating(),
          // Name Rating End
          divider(),
          // Hosted by Start
          hostedBy(),
          // Hosted by End
          divider(),
          // What you do Start
          whatYouDo(),
          // What you do End
          divider(),
          // What included Start
          whatIncluded(),
          // What included End
          divider(),
          // Meet your host Start
          meetYourHost(),
          // Meet your host End
          divider(),
          // Where you will be Start
          whereYouWillBwe(),
          // Where you will be End
        ],
      ),
    );
  }

  slider() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height / 1.6,
      width: width,
      child: Carousel(
        images: const [
          ExactAssetImage('assets/experience/experience_1.jpg'),
          ExactAssetImage('assets/experience/experience_2.jpg'),
          ExactAssetImage('assets/experience/experience_3.jpg'),
        ],
        dotSize: 6.0,
        dotSpacing: 18.0,
        dotColor: primaryColor,
        indicatorBgPadding: 5.0,
        dotBgColor: Colors.transparent,
        borderRadius: false,
        moveIndicatorFromBottom: 180.0,
        noRadiusForIndicator: true,
        overlayShadow: true,
        overlayShadowColors: Colors.white,
        overlayShadowSize: 0.7,
      ),
    );
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

  nameRating() {
    return Container(
      padding: EdgeInsets.all(fixPadding * 2.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Private Scenic Travel Photo Shoot',
            style: blackHeadingTextStyle,
          ),
          heightSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.star, color: Colors.lime[600], size: 18.0),
              const SizedBox(width: 3.0),
              Text('4.96 (208)', style: greySmallTextStyle),
            ],
          ),
        ],
      ),
    );
  }

  hostedBy() {
    return Container(
      padding: EdgeInsets.all(fixPadding * 2.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Experience hosted by Peter', style: blackBigBoldTextStyle),
              Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  image: const DecorationImage(
                    image: AssetImage('assets/host.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          heightSpace,
          experienceInfoTile('assets/icons/clock.png', '90 mins'),
          heightSpace,
          experienceInfoTile('assets/icons/tag.png', 'Includes equipment'),
          heightSpace,
          experienceInfoTile('assets/icons/group.png', 'Up to 4 people'),
          heightSpace,
          experienceInfoTile('assets/icons/chat.png', 'Hosted in English'),
        ],
      ),
    );
  }

  experienceInfoTile(imagePath, title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(imagePath,
            width: 30.0, height: 30.0, fit: BoxFit.fitHeight),
        widthSpace,
        Text(title, style: blackNormalTextStyle),
      ],
    );
  }

  whatYouDo() {
    return Container(
      padding: EdgeInsets.all(fixPadding * 2.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('What you\'ll do', style: blackBigBoldTextStyle),
          heightSpace,
          Text(
            'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
            style: greySmallTextStyle,
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  whatIncluded() {
    return Container(
      padding: EdgeInsets.all(fixPadding * 2.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('What\'s included', style: blackBigBoldTextStyle),
          heightSpace,
          Container(
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
                Image.asset(
                  'assets/icons/travel.png',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.fitHeight,
                ),
                heightSpace,
                Text(
                  'Equipment',
                  style: blackBigBoldTextStyle,
                ),
                heightSpace,
                Text(
                  'Photo Equipment - special lenses.',
                  style: blackNormalTextStyle,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  meetYourHost() {
    return Container(
      padding: EdgeInsets.all(fixPadding * 2.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 70.0,
                height: 70.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35.0),
                  image: const DecorationImage(
                    image: AssetImage('assets/host.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              widthSpace,
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Meet your host, Peter',
                    style: blackBigBoldTextStyle,
                  ),
                  heightSpace,
                  Text(
                    'Host on TravelPro since 2018',
                    style: greySmallTextStyle,
                  ),
                ],
              ),
            ],
          ),
          heightSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.star, color: Colors.lime[600], size: 18.0),
              const SizedBox(width: 5.0),
              Text('208 Reviews', style: greySmallTextStyle),
              widthSpace,
              widthSpace,
              Icon(Icons.verified_user, color: Colors.lime[600], size: 18.0),
              const SizedBox(width: 5.0),
              Text('Identity verified', style: greySmallTextStyle),
            ],
          ),
          heightSpace,
          Text(
            'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
            style: greySmallTextStyle,
            textAlign: TextAlign.justify,
          ),
          heightSpace,
          heightSpace,
          InkWell(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.only(
                  left: fixPadding * 2.0,
                  right: fixPadding * 2.0,
                  top: fixPadding,
                  bottom: fixPadding),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(width: 1.0, color: primaryColor),
              ),
              child: Text(
                'Contact host',
                style: primaryColorButtonTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  whereYouWillBwe() {
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(fixPadding * 2.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Where you\'ll be', style: blackBigBoldTextStyle),
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
}
