import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_picker/contact_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:paywise/friends_dashboard/get_details.dart';
import 'package:paywise/size_config.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Friendsdashboard extends StatefulWidget {
  @override
  _Friendsdashboard createState() => new _Friendsdashboard();
}

class _Friendsdashboard extends State<Friendsdashboard> {
  final ContactPicker _contactPicker = new ContactPicker();
  Contact _contact;
  String mobile;
  String currentUserMobileNumber;
  var data = [];
  Future _data;
  int count = 0;

  @override
  void initState() {
    super.initState();
    _data = getFriends();
  }

  navigateToDetail(DocumentSnapshot post) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailPage(
                  post: post,
                )));
  }

  Future getFriends() async {
    var friend = FirebaseFirestore.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email');

    QuerySnapshot qn = await friend
        .collection('Customer_Sign_In')
        .doc(email)
        .collection('friends')
        .get();
    return qn.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: FutureBuilder(
            future: _data,
            // ignore: missing_return
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Text("Loading..."),
                );
              } else {
                if (snapshot.data.length > 0) {
                  return ListView.separated(
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.all(5),
                      clipBehavior: Clip.hardEdge,
                      separatorBuilder: (context, index) => Divider(
                            color: Colors.white,
                            height: 20,
                            thickness: 0,
                          ),
                      shrinkWrap: false,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        final item = snapshot.data[index].toString();
                        return Dismissible(
                            key: Key(item),
                            onDismissed: (direction) {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) =>
                                      CupertinoAlertDialog(
                                        title: Text('Remove ' +
                                            snapshot.data[index]
                                                .data()['name']),
                                        content: Text(
                                            'Are you sure you want to remove ' +
                                                snapshot.data[index]
                                                    .data()['name'] +
                                                ' ? Your data and expenses will be deleted and your friend will also be notified about this remove and your data will never be recovered'),
                                        actions: <Widget>[
                                          CupertinoDialogAction(
                                              child: Text('No'),
                                              onPressed: () => {
                                                    setState(() {
                                                      count = 1;
                                                      if (count == 1) {
                                                        _data = getFriends();
                                                        count = 0;
                                                      }
                                                    }),
                                                    Navigator.of(context).pop(),
                                                  }),
                                          CupertinoDialogAction(
                                            child: Text('Yes'),
                                            onPressed: () => {
                                              EasyLoading.show(
                                                  status: 'loading...'),
                                              setState(() {
                                                String friendEmail = snapshot
                                                    .data[index]
                                                    .data()['email'];
                                                removeFriend(
                                                    friendEmail, context);
                                                // ignore: unnecessary_statements
                                                snapshot.data.removeAt[index];
                                                Navigator.of(context).pop();
                                              })
                                            },
                                          ),
                                        ],
                                      ));
                            },
                            background: Container(
                                color: Colors.red,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: getProportionateScreenWidth(
                                                20)),
                                        child: Icon(
                                          Icons.delete_forever,
                                          color: Colors.white,
                                        ),
                                      )
                                    ])),
                            child: Container(
                              child: ListTile(
                                  leading: Image.asset(
                                    "assets/images/app_logo.png",
                                  ),
                                  trailing: Text('\u20B9 100',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontFamily: 'Muli',
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              getProportionateScreenWidth(15))),
                                  title: Text.rich(
                                    TextSpan(
                                      style: TextStyle(color: Colors.black),
                                      children: [
                                        TextSpan(
                                          text: snapshot.data[index]
                                              .data()['name'],
                                          style: TextStyle(
                                            fontFamily: 'Muli',
                                            fontSize:
                                                getProportionateScreenWidth(18),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  subtitle: Text.rich(
                                    TextSpan(
                                      style: TextStyle(color: Colors.black),
                                      children: [
                                        TextSpan(
                                            text: snapshot.data[index]
                                                .data()['mobile']),
                                      ],
                                    ),
                                  ),
                                  onTap: () => {
                                        navigateToDetail(snapshot.data[index]),
                                      }),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    blurRadius: 6,
                                    offset: Offset(-4, 4),
                                  ),
                                ],
                              ),
                            ));
                      });
                } else {
                  return Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: getProportionateScreenHeight(150),
                      ),
                      Center(
                          child: Image.asset(
                        'assets/images/broke.png',
                        scale: 2,
                      )),
                      Text(
                        'Add Friends to Split Expenses',
                        style: TextStyle(
                            fontFamily: 'Muli',
                            color: Colors.grey,
                            // fontWeight: FontWeight.bold,
                            fontSize: getProportionateScreenWidth(22)),
                      )
                    ],
                  );
                }
              }
            }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF00BCD4),
        foregroundColor: Colors.white,
        onPressed: () async {
          if (await Permission.contacts.request().isGranted) {
            Contact contact = await _contactPicker.selectContact();
            contact != null
                ? showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) => CupertinoAlertDialog(
                          title: Text('Sending Request'),
                          content: Text(
                              'Are you sure you want to send request to ' +
                                  contact.phoneNumber.toString() +
                                  ' ?'),
                          actions: <Widget>[
                            CupertinoDialogAction(
                              child: Text('No'),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            CupertinoDialogAction(
                              child: Text('Yes'),
                              onPressed: () => {
                                EasyLoading.show(status: 'loading...'),
                                setState(() {
                                  _contact = contact;
                                  mobile = mobileEdit(_contact);
                                  addFriend();
                                  Navigator.of(context).pop();
                                })
                              },
                            ),
                          ],
                        ))
                : Fluttertoast.showToast(
                    msg: 'Not Selected any Contact',
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    fontSize: 16.0);

            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => AddFriend()));
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) => CupertinoAlertDialog(
                      title: Text('Contact Permission'),
                      content: Text(
                          'This app needs Contact access to add your friends of your bill'),
                      actions: <Widget>[
                        CupertinoDialogAction(
                          child: Text('Deny'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        CupertinoDialogAction(
                          child: Text('Settings'),
                          onPressed: () => openAppSettings(),
                        ),
                      ],
                    ));
          }
          // Navigator.pushNamed(context, AddFriend.routeName);
        },
        icon: Icon(Icons.add),
        label: Text('Friend',
            style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Muli')),
      ),
    );
  }

  mobileEdit(Contact contact) {
    String str = contact.phoneNumber.number.replaceAll(RegExp('[^0-9\\+]'), '');
    return str.startsWith('+91') ? str.substring(3) : str;
  }

  removeFriend(String friendEmail, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email');
    CollectionReference removeFriend =
        FirebaseFirestore.instance.collection('Customer_Sign_In');

    removeFriend.doc(email).collection('friends').doc(friendEmail).delete();
    removeFriend
        .doc(friendEmail)
        .collection('friends')
        .doc(email)
        .delete()
        .then((value) => {
              setState(() {
                count = 1;
                if (count == 1) {
                  _data = getFriends();
                  count = 0;
                }
              }),
              EasyLoading.dismiss(),
              Navigator.of(context).pop()
            })
        .onError((error, stackTrace) => {EasyLoading.dismiss()});
  }

  Future<void> addFriend() async {
    CollectionReference findNumberOfCurrentUser =
        FirebaseFirestore.instance.collection('Customer_Sign_In');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email');
    String friendName;
    String friendEmail;
    String currentUserName;

    findNumberOfCurrentUser
        .where('email', isEqualTo: email)
        .get()
        .then((value) => {
              if (value.size > 0)
                {
                  value.docs.forEach((element) {
                    if (element['mobile'] != null &&
                        element['fname'] != null &&
                        element['lname'] != null) {
                      setState(() {
                        currentUserMobileNumber = element['mobile'];
                        currentUserName =
                            element['fname'] + ' ' + element['lname'];
                      });
                    }
                  })
                }
              else
                {EasyLoading.dismiss()}
            });

    CollectionReference exist =
        FirebaseFirestore.instance.collection('Customer_Sign_In');
    // CollectionReference add = FirebaseFirestore.instance
    //     .collection('Customer_Sign_In')
    //     .doc(email)
    //     .collection('friends');

    exist.where('mobile', isEqualTo: mobile).get().then((value) => {
          if (value.size > 0)
            {
              value.docs.forEach((element) {
                if (element['fname'] != null &&
                    element['lname'] != null &&
                    element['email'] != null) {
                  friendName = element['fname'] + ' ' + element['lname'];
                  friendEmail = element['email'];
                } else {
                  EasyLoading.dismiss();
                }
              }),
              if (friendEmail != null)
                {
                  checkFriendExist(
                      email, friendEmail, friendName, currentUserName),
                  // add.doc(friendEmail).set({
                  //   'mobile': mobile,
                  //   'email': friendEmail,
                  //   'name': friendName,
                  // }),
                }
              else
                {EasyLoading.dismiss()}
            }
          else
            {
              EasyLoading.dismiss(),
              Fluttertoast.showToast(
                  msg: '$mobile not exist in the app',
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  fontSize: 16.0)
            }
        });
  }

  checkFriendExist(String email, String friendEmail, String friendName,
      String currentUserName) async {
    CollectionReference checkFriendExist = FirebaseFirestore.instance
        .collection('Customer_Sign_In')
        .doc(email)
        .collection('friends');

    await checkFriendExist
        .where('email', isEqualTo: friendEmail)
        .get()
        .then((value) => {
              if (value.size > 0)
                {
                  EasyLoading.dismiss(),
                  Fluttertoast.showToast(
                      msg: '$friendName is already in your friend list',
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      fontSize: 16.0)
                }
              else
                {
                  checkFriendExist.doc(friendEmail).set({
                    'mobile': mobile,
                    'email': friendEmail,
                    'name': friendName,
                  }),
                  friendSideAdd(email, currentUserName, friendEmail),
                }
            });
  }

  friendSideAdd(String email, String name, String friendEmail) {
    CollectionReference friendSideAdd =
        FirebaseFirestore.instance.collection('Customer_Sign_In');
    friendSideAdd.doc(friendEmail).collection('friends').doc(email).set({
      'mobile': currentUserMobileNumber,
      'email': email,
      'name': name,
    }).then((value) => {
          EasyLoading.dismiss(),
          Fluttertoast.showToast(
              msg: 'Successfully added',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              fontSize: 16.0),
          setState(() {
            count = 1;
            if (count == 1) {
              _data = getFriends();
              count = 0;
            }
          })
        });
  }
}
