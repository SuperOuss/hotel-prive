// ignore_for_file: prefer_typing_uninitialized_variables, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:hotel_prive/constant/constant.dart';
import 'package:hotel_prive/pages/hotel/hotel_room.dart';

class HotelOnMap extends StatefulWidget {
  final hotelList;
  const HotelOnMap({Key? key, @required this.hotelList}) : super(key: key);
  @override
  _HotelOnMapState createState() => _HotelOnMapState();
}

class _HotelOnMapState extends State<HotelOnMap> {
  GoogleMapController? _controller;

  List<Marker> allMarkers = [];

  PageController? _pageController;

  int? prevPage;

  @override
  void initState() {
    super.initState();
    widget.hotelList.forEach((element) {
      // print(element);
      allMarkers.add(Marker(
          markerId: MarkerId(element['name']),
          draggable: false,
          infoWindow:
              InfoWindow(title: element['name'], snippet: element['address']),
          position: LatLng(element['locationLat'], element['locationLang'])));
    });
    _pageController = PageController(initialPage: 1, viewportFraction: 0.8)
      ..addListener(_onScroll);
  }

  void _onScroll() {
    if (_pageController!.page!.toInt() != prevPage) {
      prevPage = _pageController!.page!.toInt();
      moveCamera();
    }
  }
  final Map<String, dynamic> placeholderHotelData = {
  'name': 'Default Hotel',
  'defaultImageUrl': 'https://example.com/default-image.jpg',
  'offerRetailRate': 'N/A',
};

  _hotelFinalList(index) {
    return AnimatedBuilder(
      animation: _pageController!,
      builder: (BuildContext? context, Widget? widget) {
        double value = 1;
        if (_pageController!.position.haveDimensions) {
          value = _pageController!.page! - index;
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 175.0,
            width: Curves.easeInOut.transform(value) * 350.0,
            child: widget,
          ),
        );
      },
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              PageTransition(
                  duration: const Duration(milliseconds: 700),
                  type: PageTransitionType.fade,
                  child: HotelRoom(
             hotelData: placeholderHotelData
                  )));
        },
        child: Stack(
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 20.0,
                ),
                height: 175.0,
                width: 275.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black54,
                        offset: Offset(0.0, 4.0),
                        blurRadius: 10.0,
                      ),
                    ]),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white),
                  child: Row(
                    children: [
                      Hero(
                        tag: widget.hotelList[index]['name'],
                        child: Container(
                          height: 175.0,
                          width: 90.0,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10.0),
                                topLeft: Radius.circular(10.0)),
                            image: DecorationImage(
                                image: AssetImage(
                                    widget.hotelList[index]['image']),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5.0),
                      SizedBox(
                        width: 275.0 - 90.0 - 5.0 - 10.0,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.hotelList[index]['name'],
                                style: mapHeadingStyle,
                              ),
                              const SizedBox(height: 5.0),
                              Text(
                                widget.hotelList[index]['address'],
                                style: mapAddressStyle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5.0),
                              Text(
                                widget.hotelList[index]['description'],
                                style: mapDescStyle,
                              ),
                            ]),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          backgroundColor: whiteColor,
          elevation: 1.0,
          title: Text(
            'Hotel',
            style: appBarTextStyle,
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height - 50.0,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: LatLng(widget.hotelList[0]['locationLat'],
                        widget.hotelList[0]['locationLang']),
                    zoom: 12.0),
                markers: Set.from(allMarkers),
                onMapCreated: mapCreated,
                zoomControlsEnabled: false,
              ),
            ),
            Positioned(
              bottom: 20.0,
              child: SizedBox(
                height: 200.0,
                width: MediaQuery.of(context).size.width,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.hotelList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _hotelFinalList(index);
                  },
                ),
              ),
            )
          ],
        ));
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }

  moveCamera() {
    _controller!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(
            widget.hotelList[_pageController!.page!.toInt()]['locationLat'],
            widget.hotelList[_pageController!.page!.toInt()]['locationLang']),
        zoom: 14.0,
        bearing: 45.0,
        tilt: 45.0)));
  }
}
