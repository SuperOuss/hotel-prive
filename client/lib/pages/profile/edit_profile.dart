// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:hotel_prive/constant/constant.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String name = 'Ellison Perry';
  String phone = '123456789';
  String email = 'test@abc.com';
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = name;
    phoneController.text = phone;
    emailController.text = email;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    changeFullName() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          // return object of type Dialog
          return Dialog(
            elevation: 0.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
              height: 210.0,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Change Full Name",
                    style: blackBigTextStyle,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    controller: nameController,
                    style: blackColorButtonTextStyle,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Enter Your Full Name',
                      hintStyle: greySmallTextStyle,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: (width / 3.5),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Text(
                            'Cancel',
                            style: blackColorButtonTextStyle,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            name = nameController.text;
                            Navigator.pop(context);
                          });
                        },
                        child: Container(
                          width: (width / 3.5),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Text(
                            'Okay',
                            style: whiteColorButtonTextStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    changePassword() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          // return object of type Dialog
          return Dialog(
            elevation: 0.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
              height: 300.0,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Change Your Password",
                    style: blackBigTextStyle,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    obscureText: true,
                    style: blackColorButtonTextStyle,
                    decoration: InputDecoration(
                      hintText: 'Old Password',
                      hintStyle: greySmallTextStyle,
                    ),
                  ),
                  TextField(
                    obscureText: true,
                    style: blackColorButtonTextStyle,
                    decoration: InputDecoration(
                      hintText: 'New Password',
                      hintStyle: greySmallTextStyle,
                    ),
                  ),
                  TextField(
                    obscureText: true,
                    style: blackColorButtonTextStyle,
                    decoration: InputDecoration(
                      hintText: 'Confirm New Password',
                      hintStyle: greySmallTextStyle,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: (width / 3.5),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Text(
                            'Cancel',
                            style: blackColorButtonTextStyle,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: (width / 3.5),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Text(
                            'Okay',
                            style: whiteColorButtonTextStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    changePhoneNumber() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          // return object of type Dialog
          return Dialog(
            elevation: 0.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
              height: 200.0,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Change Phone Number",
                    style: blackBigTextStyle,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    controller: phoneController,
                    style: blackColorButtonTextStyle,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter Phone Number',
                      hintStyle: greySmallTextStyle,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: (width / 3.5),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Text(
                            'Cancel',
                            style: blackColorButtonTextStyle,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            phone = phoneController.text;
                            Navigator.pop(context);
                          });
                        },
                        child: Container(
                          width: (width / 3.5),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Text(
                            'Okay',
                            style: whiteColorButtonTextStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    changeEmail() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          // return object of type Dialog
          return Dialog(
            elevation: 0.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
              height: 200.0,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Change Email",
                    style: blackBigTextStyle,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    controller: emailController,
                    style: blackColorButtonTextStyle,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Enter Your Email Address',
                      hintStyle: greySmallTextStyle,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: (width / 3.5),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child:
                              Text('Cancel', style: blackColorButtonTextStyle),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            email = emailController.text;
                            Navigator.pop(context);
                          });
                        },
                        child: Container(
                          width: (width / 3.5),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Text(
                            'Okay',
                            style: whiteColorButtonTextStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: blackColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.all(fixPadding),
              alignment: Alignment.center,
              child: Text(
                'Save',
                style: blueSmallTextStyle,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Profile Image Start
              InkWell(
                onTap: _selectOptionBottomSheet,
                child: Container(
                  width: 100.0,
                  height: 100.0,
                  margin: EdgeInsets.all(fixPadding * 4.0),
                  alignment: Alignment.bottomRight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(width: 2.0, color: whiteColor),
                    image: const DecorationImage(
                      image: AssetImage('assets/user.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    height: 22.0,
                    width: 22.0,
                    margin: EdgeInsets.all(fixPadding / 2),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11.0),
                      border: Border.all(
                          width: 1.0, color: whiteColor.withOpacity(0.7)),
                      color: Colors.orange,
                    ),
                    child: Icon(Icons.add, color: whiteColor, size: 15.0),
                  ),
                ),
              ),
              // Profile Image End
              // Full Name Start
              InkWell(
                onTap: changeFullName,
                child: getTile('Full Name', name),
              ),
              // Full Name End
              // Password Start
              InkWell(
                onTap: changePassword,
                child: getTile('Password', '******'),
              ),
              // Password End
              // Phone Start
              InkWell(
                onTap: changePhoneNumber,
                child: getTile('Phone', phone),
              ),
              // Phone End
              // Email Start
              InkWell(
                onTap: changeEmail,
                child: getTile('Email', email),
              ),
              // Email End
            ],
          ),
        ],
      ),
    );
  }

  getTile(String title, String value) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(
          right: fixPadding, left: fixPadding, bottom: fixPadding * 1.5),
      padding: EdgeInsets.only(
        right: fixPadding,
        left: fixPadding,
        top: fixPadding * 2.0,
        bottom: fixPadding * 2.0,
      ),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: 1.5,
            spreadRadius: 1.5,
            color: Colors.grey[200]!,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: width - 80.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  width: (width - 80.0) / 2.4,
                  child: Text(
                    title,
                    style: greyNormalTextStyle,
                  ),
                ),
                SizedBox(
                  width: (width - 80.0) / 2.0,
                  child: Text(
                    value,
                    style: blackNormalTextStyle,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16.0,
            color: Colors.grey.withOpacity(0.6),
          ),
        ],
      ),
    );
  }

  // Bottom Sheet for Select Options (Camera or Gallery) Start Here
  void _selectOptionBottomSheet() {
    double width = MediaQuery.of(context).size.width;
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            color: whiteColor,
            child: Wrap(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: width,
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Choose Option',
                          textAlign: TextAlign.center,
                          style: blackBigTextStyle,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: width,
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.camera_alt,
                                color: Colors.black.withOpacity(0.7),
                                size: 18.0,
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Text('Camera', style: blackSmallTextStyle),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: width,
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.photo_album,
                                color: Colors.black.withOpacity(0.7),
                                size: 18.0,
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                'Upload from Gallery',
                                style: blackSmallTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
  // Bottom Sheet for Select Options (Camera or Gallery) Ends Here
}
