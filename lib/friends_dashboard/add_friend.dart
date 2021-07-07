import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddFriend extends StatefulWidget {
  static String routeName = '\addfriend';
  @override
  _AddFriendState createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return null;
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> contactExist(var mobile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String email = prefs.getString('email');
    String senderMobile;

    CollectionReference exist =
        FirebaseFirestore.instance.collection('Customer_Sign_In');
    CollectionReference add = FirebaseFirestore.instance.collection('Friends');

    exist.where('email', isEqualTo: email).get().then((value) => {
          if (value.size > 0)
            {
              value.docs.forEach((element) {
                if (element['mobile'] != null) {
                  senderMobile = element['mobile'];
                }
              })
            }
        });

    exist.where('mobile', isEqualTo: mobile).get().then((value) => () {
          if (value.size > 0) {
            add.add(
                {'from': senderMobile, 'to': mobile, 'status': 'requested'});
          }
        });
  }
}
