import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotel_prive/constant/constant.dart';
import 'package:hotel_prive/pages/splashScreen.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = "pk_test_51OyYnVA4FXPoRk9YJECd2jJmfprI2inRzqbt5Brk7R41kKIaftBnO8rCetwEVUdfR5WSsLorvNQ0tr4dDcFk8pof002p27EYzN";
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotel Prive',
      theme: ThemeData(
          primarySwatch: Colors.teal,
          primaryColor: primaryColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Noto Sans',
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: primaryColor,
          ),
          iconTheme: IconThemeData(
            color: blackColor,
          ),
          appBarTheme: AppBarTheme(
              iconTheme: IconThemeData(
            color: blackColor,
          ))).copyWith(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
          },
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
