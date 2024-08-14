// ignore_for_file: prefer_typing_uninitialized_variables, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:hotel_prive/constant/constant.dart';
import 'package:hotel_prive/widget/column_builder.dart';

class Review extends StatefulWidget {
  final reviewList;
  const Review({Key? key, @required this.reviewList}) : super(key: key);
  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0.0,
        titleSpacing: 0.0,
        title: Text(
          '${widget.reviewList.length} review found',
          style: appBarTextStyle,
        ),
      ),
      body: ListView(
        children: [
          heightSpace,
          heightSpace,
          ColumnBuilder(
            itemCount: widget.reviewList.length,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            itemBuilder: (context, index) {
              final item = widget.reviewList[index];
              return Container(
                margin: (index == 0)
                    ? EdgeInsets.symmetric(horizontal: fixPadding * 2.0)
                    : EdgeInsets.only(
                        top: fixPadding * 2.0,
                        right: fixPadding * 2.0,
                        left: fixPadding * 2.0),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 70.0,
                          height: 70.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35.0),
                            image: DecorationImage(
                              image: AssetImage(item['image']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        widthSpace,
                        SizedBox(
                          width: width - (fixPadding * 8.0 + 10.0 + 70.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'],
                                style: blackSmallBoldTextStyle,
                              ),
                              const SizedBox(height: 5.0),
                              Text(
                                item['time'],
                                style: greySmallTextStyle,
                              ),
                              const SizedBox(height: 5.0),
                              ratingBar(item['rating']),
                            ],
                          ),
                        )
                      ],
                    ),
                    heightSpace,
                    Text(
                      item['review'],
                      style: blackNormalTextStyle,
                    ),
                  ],
                ),
              );
            },
          ),
          heightSpace,
          heightSpace,
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
          color: Colors.lime[600],
          size: 18.0,
        ),

        // 2 Star
        Icon(
          (number == 2 || number == 3 || number == 4 || number == 5)
              ? Icons.star
              : Icons.star_border,
          color: Colors.lime[600],
          size: 18.0,
        ),

        // 3 Star
        Icon(
          (number == 3 || number == 4 || number == 5)
              ? Icons.star
              : Icons.star_border,
          color: Colors.lime[600],
          size: 18.0,
        ),

        // 4 Star
        Icon(
          (number == 4 || number == 5) ? Icons.star : Icons.star_border,
          color: Colors.lime[600],
          size: 18.0,
        ),

        // 5 Star
        Icon(
          (number == 5) ? Icons.star : Icons.star_border,
          color: Colors.lime[600],
          size: 18.0,
        ),
      ],
    );
  }
}
