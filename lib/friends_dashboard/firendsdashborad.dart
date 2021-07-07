import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_picker/contact_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  Future _dataFrom;
  Future _dataTo;

  @override
  void initState() {
    super.initState();
    findNumber();
    _dataFrom = getFriendFrom();
    _dataTo = getFriendTo();
  }

  findNumber() async {
    CollectionReference findNumberOfCurrentUser =
        FirebaseFirestore.instance.collection('Customer_Sign_In');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email');

    findNumberOfCurrentUser
        .where('email', isEqualTo: email)
        .get()
        .then((value) => {
              if (value.size > 0)
                {
                  value.docs.forEach((element) {
                    if (element['mobile'] != null) {
                      setState(() {
                        currentUserMobileNumber = element['mobile'];
                        _dataFrom = getFriendFrom();
                        _dataTo = getFriendTo();
                      });
                    }
                  })
                }
            });
  }

  navigateToDetail(DocumentSnapshot post) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailPage(
                  post: post,
                )));
  }

  Future getFriendFrom() async {
    var friend = FirebaseFirestore.instance;
    QuerySnapshot qn = await friend
        .collection('Friends')
        .where('from', isEqualTo: currentUserMobileNumber)
        .get();
    return qn.docs;
  }

  Future getFriendTo() async {
    var friend = FirebaseFirestore.instance;
    QuerySnapshot qn = await friend
        .collection('Friends')
        .where('to', isEqualTo: currentUserMobileNumber)
        .get();
    return qn.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       new Text(
      //         mobile == null ? 'No contact selected.' : mobile,
      //       ),
      //     ],
      //   ),
      // ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: FutureBuilder(
                future: _dataFrom,
                // ignore: missing_return
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Text("Loading..."),
                    );
                  } else {
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
                          return Container(
                            child: ListTile(
                                leading: Image.asset(
                                  "assets/images/app_logo.png",
                                ),
                                // leading: CircleAvatar(
                                //   radius: 25,
                                //   child: Icon(
                                //     Icons.supervised_user_circle,
                                //   ),
                                // ),
                                // trailing: InkWell(
                                //   onTap: () => {},
                                //   child: Icon(
                                //     Icons.more_vert,
                                //     color: Colors.black,
                                //   ),
                                // ),
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
                                        text: 'From : ' +
                                            snapshot.data[index].data()['from'],
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
                                          text: 'To : ' +
                                              snapshot.data[index]
                                                  .data()['to']),
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
                                  offset: Offset(
                                      -4, 4), // changes position of shadow
                                ),
                              ],
                            ),
                            // decoration: BoxDecoration(
                            //   gradient: LinearGradient(
                            //     begin: Alignment.centerLeft,
                            //     end: Alignment.centerRight,
                            //     colors: [
                            //       Colors.purple[900],
                            //       Colors.white,
                            //       // Colors.blue[100],
                            //       // Colors.green[500]
                            //     ],
                            //   ),
                            //   borderRadius: BorderRadius.circular(20),
                            // ),
                          );
                        });
                  }
                }),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: FutureBuilder(
                future: _dataTo,
                // ignore: missing_return
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Text(""),
                    );
                  } else {
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
                          return Container(
                            child: ListTile(
                                leading: Image.asset(
                                  "assets/images/app_logo.png",
                                ),
                                // leading: CircleAvatar(
                                //   radius: 25,
                                //   child: Icon(
                                //     Icons.supervised_user_circle,
                                //   ),
                                // ),
                                // trailing: InkWell(
                                //   onTap: () => {},
                                //   child: Icon(
                                //     Icons.more_vert,
                                //     color: Colors.black,
                                //   ),
                                // ),
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
                                        text: 'From : ' +
                                            snapshot.data[index].data()['from'],
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
                                          text: 'To : ' +
                                              snapshot.data[index]
                                                  .data()['to']),
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
                                  offset: Offset(
                                      -4, 4), // changes position of shadow
                                ),
                              ],
                            ),
                            // decoration: BoxDecoration(
                            //   gradient: LinearGradient(
                            //     begin: Alignment.centerLeft,
                            //     end: Alignment.centerRight,
                            //     colors: [
                            //       Colors.purple[900],
                            //       Colors.white,
                            //       // Colors.blue[100],
                            //       // Colors.green[500]
                            //     ],
                            //   ),
                            //   borderRadius: BorderRadius.circular(20),
                            // ),
                          );
                        });
                  }
                }),
          ),
        )
      ]),
      // Divider(),
      // Text(
      //   'List of you are in other friend list',
      //   style: TextStyle(fontFamily: 'Muli', color: Colors.black),
      // ),
      // Divider(),
      // Container(
      //   padding: EdgeInsets.all(12.0),
      //   child: FutureBuilder(
      //       future: _dataTo,
      //       // ignore: missing_return
      //       builder: (context, snapshot) {
      //         if (snapshot.connectionState == ConnectionState.waiting) {
      //           return Center(
      //             child: Text("Loading..."),
      //           );
      //         } else {
      //           return ListView.separated(
      //               scrollDirection: Axis.vertical,
      //               padding: EdgeInsets.all(10),
      //               clipBehavior: Clip.hardEdge,
      //               separatorBuilder: (context, index) => Divider(
      //                     color: Colors.white,
      //                     height: 20,
      //                     thickness: 0,
      //                   ),
      //               shrinkWrap: false,
      //               itemCount: snapshot.data.length,
      //               itemBuilder: (context, index) {
      //                 return Container(
      //                   child: ListTile(
      //                       leading: Image.asset(
      //                         "assets/images/app_logo.png",
      //                       ),
      //                       trailing: InkWell(
      //                         onTap: () => {},
      //                         child: Icon(
      //                           Icons.more_vert,
      //                           color: Colors.white,
      //                         ),
      //                       ),
      //                       title: Text.rich(
      //                         TextSpan(
      //                           style: TextStyle(color: Colors.white),
      //                           children: [
      //                             TextSpan(
      //                               text: 'From : ' +
      //                                   snapshot.data[index].data()['from'],
      //                               style: TextStyle(
      //                                 fontSize:
      //                                     getProportionateScreenWidth(21),
      //                                 fontWeight: FontWeight.bold,
      //                               ),
      //                             ),
      //                           ],
      //                         ),
      //                       ),
      //                       subtitle: Text.rich(
      //                         TextSpan(
      //                           style: TextStyle(color: Colors.white),
      //                           children: [
      //                             TextSpan(
      //                                 text: 'To : ' +
      //                                     snapshot.data[index].data()['to']),
      //                           ],
      //                         ),
      //                       ),
      //                       onTap: () => {
      //                             navigateToDetail(snapshot.data[index]),
      //                           }),

      //                   decoration: BoxDecoration(
      //                     color: Color(0xFF4A3298),
      //                     borderRadius: BorderRadius.circular(20),
      //                     boxShadow: [
      //                       BoxShadow(
      //                         color: Colors.grey.withOpacity(0.5),
      //                         spreadRadius: 5,
      //                         blurRadius: 7,
      //                         offset:
      //                             Offset(0, 3), // changes position of shadow
      //                       ),
      //                     ],
      //                   ),
      //                   // decoration: BoxDecoration(
      //                   //   gradient: LinearGradient(
      //                   //     begin: Alignment.centerLeft,
      //                   //     end: Alignment.centerRight,
      //                   //     colors: [
      //                   //       Colors.purple[900],
      //                   //       Colors.white,
      //                   //       // Colors.blue[100],
      //                   //       // Colors.green[500]
      //                   //     ],
      //                   //   ),
      //                   //   borderRadius: BorderRadius.circular(20),
      //                   // ),
      //                 );
      //               });
      //         }
      //       }),
      // ),
      // ]),
      // body: ListView.builder(

      //   itemCount: data.length,
      //   itemBuilder: (BuildContext context, int index) {
      //     final screenHeight = MediaQuery.of(context).size.height;
      //     final screenWidth = MediaQuery.of(context).size.width;
      //     return Padding(
      //         padding: EdgeInsets.symmetric(horizontal: screenWidth / 40),
      //         child: Card(
      //             shape: RoundedRectangleBorder(
      //                 borderRadius: BorderRadius.all(Radius.circular(30))),
      //             elevation: 3.0,
      //             child: Container(
      //               height: screenHeight / 7,
      //               child: Row(
      //                 mainAxisAlignment: MainAxisAlignment.start,
      //                 crossAxisAlignment: CrossAxisAlignment.center,
      //                 children: [
      //                   // Padding(
      //                   //   padding: const EdgeInsets.only(left: 10),
      //                   //   child: CircleAvatar(
      //                   //     child: Image.asset(food_images[index]),
      //                   //     radius: 30,
      //                   //   ),
      //                   // ),
      //                   Padding(
      //                     padding: EdgeInsets.only(left: screenWidth / 20),
      //                     child: Column(
      //                       mainAxisAlignment: MainAxisAlignment.center,
      //                       crossAxisAlignment: CrossAxisAlignment.start,
      //                       children: [
      //                         Text(
      //                           data[index],
      //                           style: TextStyle(
      //                               // color: enableDarkMode
      //                               //     ? Colors.white
      //                               //     : Colors.black,
      //                               fontSize: screenHeight / 40),
      //                         ),
      //                         SizedBox(
      //                           height: 10,
      //                         ),
      //                         Text(
      //                           data[index],
      //                           style: TextStyle(
      //                             // color: enableDarkMode
      //                             //     ? Colors.white
      //                             //     : Colors.black,
      //                           ),
      //                         ),
      //                       ],
      //                     ),
      //                   )
      //                 ],
      //               ),
      //             )));
      //   },
      // ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF00BCD4),
        foregroundColor: Colors.white,
        onPressed: () async {
          if (await Permission.contacts.request().isGranted) {
            Contact contact = await _contactPicker.selectContact();
            showDialog(
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
                            setState(() {
                              _contact = contact;
                              mobile = mobileEdit(_contact);
                              addFriend();
                              Navigator.of(context).pop();
                            })
                          },
                        ),
                      ],
                    ));

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

  Future<void> addFriend() async {
    CollectionReference findNumberOfCurrentUser =
        FirebaseFirestore.instance.collection('Customer_Sign_In');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email');

    findNumberOfCurrentUser
        .where('email', isEqualTo: email)
        .get()
        .then((value) => {
              if (value.size > 0)
                {
                  value.docs.forEach((element) {
                    if (element['mobile'] != null) {
                      setState(() {
                        currentUserMobileNumber = element['mobile'];
                      });
                    }
                  })
                }
            });

    CollectionReference exist =
        FirebaseFirestore.instance.collection('Customer_Sign_In');
    CollectionReference add = FirebaseFirestore.instance.collection('Friends');

    exist.where('mobile', isEqualTo: mobile).get().then((value) => {
          if (value.size > 0)
            {
              add.add({
                'from': currentUserMobileNumber,
                'to': mobile,
              }),
              Fluttertoast.showToast(
                  msg: '...$mobile is available in this app...',
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  fontSize: 16.0)
            }
          else
            {
              Fluttertoast.showToast(
                  msg: '...$mobile not exist in the app...',
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  fontSize: 16.0)
            }
        });
  }

  // Future<void> friendData() {
  //   String name;
  //   CollectionReference friend =
  //       FirebaseFirestore.instance.collection('Friends');

  //   CollectionReference userName =
  //       FirebaseFirestore.instance.collection('Customer_Sign_in');

  //   friend
  //       .where('from', isEqualTo: currentUserMobileNumber)
  //       .where('to', isEqualTo: currentUserMobileNumber)
  //       .get()
  //       .then((value) => {
  //             if (value.size > 0)
  //               {
  //                 value.docs.forEach((element) {
  //                   userName
  //                       .where('mobile', isEqualTo: mobile)
  //                       .get()
  //                       .then((value) => {
  //                             if (value.size > 0)
  //                               {
  //                                 value.docs.forEach((element) {
  //                                   name = element['fname'];
  //                                 })
  //                               }
  //                           });
  //                   data.add({
  //                     'name': name,
  //                     'mobile': mobile,
  //                   });
  //                 })
  //               }
  //           });
  // }
}

class DetailPage extends StatefulWidget {
  final DocumentSnapshot post;

  DetailPage({this.post});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("List"),
        ),
        body: Container(
          child: Card(
            child: ListTile(
              title: Text(widget.post['from']),
              subtitle: Text(widget.post['to']),
            ),
          ),
        ));
  }
}
