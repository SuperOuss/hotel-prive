// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:hotel_prive/constant/constant.dart';
import 'package:hotel_prive/pages/bottom_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';

class Payment extends StatefulWidget {
  final String? selectedOfferId;
  final String? email;
  final int? offerRetailRate;

  const Payment(
      {Key? key, this.selectedOfferId, this.email, this.offerRetailRate})
      : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  bool card = false, paypal = false;
  late String offerId;
  late String paymentIntent;
  late String secretKey;
  late String prebookId;
  bool _ready = false; // Define the _ready variable
  String stripeSecret = 'sk_test_51OyYnVA4FXPoRk9YIAaZdfjo0hotIV2M4yPqCAaUQMr6FpsUJ1Rp99yJvsE5zohqFhtitwd1eoX7358oewt1GYNM00YGWZ80lK';

  @override
  void initState() {
    super.initState();
    offerId = widget.selectedOfferId ??
        'defaultOfferId'; // Replace 'defaultOfferId' with your default value
    prebook(offerId);
  }

  Future<void> prebook(String offerId) async {
    print('prebook: offerId = $offerId'); // Debug print
    final url = Uri.parse('http://localhost:3000/v1/prebook');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',// Add authorization header if needed
      },
      body: jsonEncode({'offerId': offerId}),
    );

    if (response.statusCode == 200) {
      // Parse the JSON response
      final data = jsonDecode(response.body);
      print(data['data']['secretKey']);
      print(data['data']['transactionId']);
      setState(() {
        prebookId = data['data']['prebookId'];
        paymentIntent = data['data']['transactionId'];
        secretKey = data['data']['secretKey'];
      });
    } else {
      // Handle error response
      print('Failed to prebook: ${response.body}');
    }
  }

  Future<void> initPaymentSheet() async {
    try {
      // 2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Set to true for custom flow
          customFlow: false,
          // Main params
          merchantDisplayName: 'Hotel Privé',
          paymentIntentClientSecret: paymentIntent,
          // Customer keys
          //customerEphemeralKeySecret: paymentIntent,
          customerId: prebookId,
          // Extra options
          style: ThemeMode.dark,
        ),
      );
      setState(() {
        _ready = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
  }

  successOrderDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          elevation: 0.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Container(
            height: 170.0,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 70.0,
                  width: 70.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35.0),
                    border: Border.all(color: primaryColor, width: 1.0),
                  ),
                  child: Icon(
                    Icons.check,
                    size: 40.0,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Success!",
                  style: smallBoldGreyTextStyle,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );

    Future.delayed(const Duration(milliseconds: 3000), () {
      setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BottomBar(email: widget.email)),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    // Print the email value
    print('Email: ${widget.email}');

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 1.0,
        titleSpacing: 0.0,
        title: Text('Payment', style: appBarTextStyle),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: blackColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      bottomNavigationBar: Material(
        elevation: 5.0,
        child: Container(
          color: Colors.white,
          width: width,
          height: 70.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InkWell(
                borderRadius: BorderRadius.circular(15.0),
                onTap: () async {
                  await initPaymentSheet();
                  successOrderDialog();
                },
                child: Container(
                  height: 50.0,
                  width: width - fixPadding * 4.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: primaryColor,
                  ),
                  child: Text(
                    'Pay',
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
          Container(
            width: width,
            padding: EdgeInsets.all(fixPadding * 2.0),
            color: lightPrimaryColor,
            child: Text(
              'Pay \$${widget.offerRetailRate}',
              style: blackBigTextStyle,
            ),
          ),
          // Comment out or remove other payment methods
          // getPaymentTile('Pay on Delivery', 'assets/payment_icon/cash_on_delivery.png'),
          // getPaymentTile('Amazon Pay', 'assets/payment_icon/amazon_pay.png'),
          getPaymentTile('Card', 'assets/payment_icon/card.png'),
          getPaymentTile('PayPal', 'assets/payment_icon/paypal.png'),
          // getPaymentTile('Skrill', 'assets/payment_icon/skrill.png'),
          Container(height: fixPadding * 2.0),
        ],
      ),
    );
  }

  getPaymentTile(String title, String imgPath) {
    return InkWell(
      onTap: () {
        if (title == 'Card') {
          setState(() {
            card = true;
            paypal = false;
          });
        } else if (title == 'PayPal') {
          setState(() {
            card = false;
            paypal = true;
          });
        }
      },
      child: Container(
        margin: EdgeInsets.only(
            right: fixPadding * 2.0,
            left: fixPadding * 2.0,
            top: fixPadding * 2.0),
        padding: EdgeInsets.all(fixPadding * 2.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.0),
          border: Border.all(
            width: 1.0,
            color: (title == 'Card')
                ? (card)
                    ? primaryColor
                    : Colors.grey[300]!
                : (title == 'PayPal')
                    ? (paypal)
                        ? primaryColor
                        : Colors.grey[300]!
                    : Colors.grey[300]!,
          ),
          color: whiteColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 70.0,
                  child:
                      Image.asset(imgPath, width: 70.0, fit: BoxFit.fitWidth),
                ),
                widthSpace,
                Text(title, style: primaryColorHeadingTextStyle),
              ],
            ),
            Container(
              width: 20.0,
              height: 20.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  width: 1.5,
                  color: (title == 'Card')
                      ? (card)
                          ? primaryColor
                          : Colors.grey[300]!
                      : (title == 'PayPal')
                          ? (paypal)
                              ? primaryColor
                              : Colors.grey[300]!
                          : Colors.grey[300]!,
                ),
              ),
              child: Container(
                width: 10.0,
                height: 10.0,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: (title == 'Card')
                      ? (card)
                          ? primaryColor
                          : Colors.transparent
                      : (title == 'PayPal')
                          ? (paypal)
                              ? primaryColor
                              : Colors.transparent
                          : Colors.transparent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
