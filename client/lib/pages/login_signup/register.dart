import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:travel_pro/pages/bottom_bar.dart';
import 'package:travel_pro/constant/constant.dart';

class Register extends StatelessWidget {
  const Register({super.key});

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
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              ),
              body: ListView(
                physics: const BouncingScrollPhysics(),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                    child: Text(
                      'Register',
                      style: loginBigTextStyle,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      'Create account',
                      style: whiteSmallLoginTextStyle,
                    ),
                  ),
                  const SizedBox(height: 50.0),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200]!.withOpacity(0.3),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20.0)),
                      ),
                      child: TextField(
                        style: inputLoginTextStyle,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 20.0),
                          hintText: 'Username',
                          hintStyle: inputLoginTextStyle,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200]!.withOpacity(0.3),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20.0)),
                      ),
                      child: TextField(
                        style: inputLoginTextStyle,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 20.0),
                          hintText: 'Email',
                          hintStyle: inputLoginTextStyle,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200]!.withOpacity(0.3),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20.0)),
                      ),
                      child: TextField(
                        style: inputLoginTextStyle,
                        obscureText: true,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 20.0),
                          hintText: 'Password',
                          hintStyle: inputLoginTextStyle,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200]!.withOpacity(0.3),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20.0)),
                      ),
                      child: TextField(
                        style: inputLoginTextStyle,
                        obscureText: true,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 20.0),
                          hintText: 'Confirm Password',
                          hintStyle: inputLoginTextStyle,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30.0),
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                duration: const Duration(milliseconds: 600),
                                type: PageTransitionType.fade,
                                child: const BottomBar()));
                      },
                      child: Container(
                        height: 50.0,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.bottomRight,
                            stops: const [0.1, 0.5, 0.9],
                            colors: [
                              Colors.teal[300]!.withOpacity(0.8),
                              Colors.teal[500]!.withOpacity(0.8),
                              Colors.teal[800]!.withOpacity(0.8),
                            ],
                          ),
                        ),
                        child: Text(
                          'Continue',
                          style: inputLoginTextStyle,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
