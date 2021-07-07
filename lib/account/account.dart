import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:paywise/account/my_account.dart';
import 'package:paywise/account/profile_menu.dart';
import 'package:paywise/account/profile_pic.dart';
import 'package:paywise/sign_in/sign_in_screen.dart';
import 'package:paywise/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../user_detail.dart';

class Account extends StatefulWidget {
  static String routeName = '\account';
  @override
  _Account createState() => _Account();
}

class _Account extends State<Account> {
  CollectionReference info =
      FirebaseFirestore.instance.collection('Customer_Sign_In');
  final FirebaseAuth auth = FirebaseAuth.instance;
  String email;
  String fname, lname;
  String mobile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (AppBar()),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            ProfilePic(),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            Divider(),
            SizedBox(height: 20),
            ProfileMenu(
              text: "My Profile",
              icon: "assets/icons/User Icon.svg",
              press: () => {
                information(context),
              },
            ),
            // Divider(),
            ProfileMenu(
              text: "Notifications",
              icon: "assets/icons/Bell.svg",
              press: () {},
            ),
            // Divider(),
            ProfileMenu(
              text: "Settings",
              icon: "assets/icons/Settings.svg",
              press: () {},
            ),
            // Divider(),
            ProfileMenu(
              text: "Help Center",
              icon: "assets/icons/Question mark.svg",
              press: () {},
            ),
            // Divider(),
            ProfileMenu(
              text: "Log Out",
              icon: "assets/icons/Log out.svg",
              press: () async {
                await FirebaseAuth.instance.signOut();
                GoogleSignIn().signOut();
                addEmail('');
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => SignInScreen(),
                  ),
                  (route) => false,
                );
              },
            ),
            Divider(),
          ],
        ),
      ),
    );
  }

  Future<void> information(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String email = pref.getString('email');
    return info.where('email', isEqualTo: email).get().then((value) => {
          value.docs.forEach((element) {
            fname = element['fname'];
            lname = element['lname'];
            mobile = element['mobile'];
            Navigator.pushNamed(context, MyAccount.routeName, arguments: {
              'email': email,
              'mobile': mobile,
              'fname': fname,
              'lname': lname
            });
          })
        });
  }
}
