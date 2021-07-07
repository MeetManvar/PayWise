import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../size_config.dart';

class DetailPage extends StatefulWidget {
  final DocumentSnapshot post;

  DetailPage({this.post});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Future _data;
  String friendEmail;
  int count = 0;
  void initState() {
    getFriend();
    _data = getData();
    super.initState();
  }

  getFriend() {
    CollectionReference getFriendEmail =
        FirebaseFirestore.instance.collection('Customer_Sign_In');
    getFriendEmail
        .where('mobile', isEqualTo: widget.post['mobile'])
        .get()
        .then((value) => {
              if (value.size > 0)
                {
                  value.docs.forEach((element) {
                    if (element['email'] != null) {
                      setState(() {
                        count = 1;
                        if (count == 1) {
                          _data = getData();
                          count = 0;
                        }
                        friendEmail = element['email'];
                      });
                    } else {
                      Fluttertoast.showToast(
                          msg: 'Email doesn\'t match',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.blue,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  })
                }
              else
                {
                  Fluttertoast.showToast(
                      msg: 'Friend Email doesn\'t match',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.blue,
                      textColor: Colors.white,
                      fontSize: 16.0)
                }
            });
  }

  getData() async {
    var friend = FirebaseFirestore.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email');
    QuerySnapshot qn = await friend
        .collection('Customer_Sign_In')
        .doc(email)
        .collection('friends')
        .doc(friendEmail)
        .collection('Expense')
        .get();
    return qn.docs;
  }

  String dropdownValue = 'You Paid';
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.post['name'],
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'muli',
              fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF00BCD4),
        foregroundColor: Colors.white,
        onPressed: _displayDialog,
        label: Text("Add Expense"),
        icon: Icon(Icons.add_circle),
      ),
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
                if (snapshot.data != null) {
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
                              onDismissed: (direction) {},
                              background: Container(
                                  color: Colors.red,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right:
                                                  getProportionateScreenWidth(
                                                      20)),
                                          child: Icon(
                                            Icons.delete_forever,
                                            color: Colors.white,
                                          ),
                                        )
                                      ])),
                              child: Container(
                                child: ListTile(
                                    // leading: Image.asset(
                                    //   "assets/images/app_logo.png",
                                    // ),
                                    trailing: Text(
                                        '\u20B9' +
                                            snapshot.data[index]
                                                .data()['amount'],
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontFamily: 'Muli',
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                getProportionateScreenWidth(
                                                    15))),
                                    title: Text.rich(
                                      TextSpan(
                                        style: TextStyle(color: Colors.black),
                                        children: [
                                          TextSpan(
                                            text: 'From : ' +
                                                snapshot.data[index]
                                                    .data()['from'],
                                            style: TextStyle(
                                              fontFamily: 'Muli',
                                              fontSize:
                                                  getProportionateScreenWidth(
                                                      14),
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
                                          TextSpan(
                                              text: '\nDescription : ' +
                                                  snapshot.data[index]
                                                      .data()['description']),
                                        ],
                                      ),
                                    ),
                                    onTap: () => {
                                          // navigateToDetail(snapshot.data[index]),
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
                          'No Expanses Yet',
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
              }
            }),
      ),
    );
  }

  _displayDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                elevation: 6,
                backgroundColor: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 24),
                      Text(
                        "add expense".toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      SizedBox(height: 10),
                      // Padding(
                      //   padding:
                      //       EdgeInsets.only(top: 10, bottom: 10, right: 15, left: 15),
                      //   child: Icon(
                      //     Icons.account_circle,
                      //     size: 100,
                      //   ),
                      // ),
                      Padding(
                          padding:
                              EdgeInsets.only(top: 10, right: 15, left: 15),
                          child: TextFormField(
                            maxLines: 1,
                            autofocus: true,
                            controller: _descriptionController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: 'Description',
                              hintText: 'Description',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          )),
                      Container(
                        width: 150.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                          padding:
                              EdgeInsets.only(top: 10, right: 15, left: 15),
                          child: TextFormField(
                            maxLines: 1,
                            autofocus: true,
                            controller: _amountController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: 'Amount',
                              hintText: 'Amount',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          )),
                      DropdownButton<String>(
                        value: dropdownValue,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue = newValue;
                          });
                        },
                        items: <String>['You Paid', 'You are Owned']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          // ignore: deprecated_member_use
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Cancel".toUpperCase(),
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          // ignore: deprecated_member_use
                          RaisedButton(
                            color: Color(0xFF00BCD4),
                            child: Text(
                              "Save".toUpperCase(),
                              style: TextStyle(
                                color: Colors.indigo[900],
                              ),
                            ),
                            onPressed: () {
                              addExpense();
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ));
          });
        });
  }

  addExpense() async {
    EasyLoading.show(status: 'loading...');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email');
    String description = _descriptionController.text.trim();
    String amount = _amountController.text.trim();
    CollectionReference friend =
        FirebaseFirestore.instance.collection('Customer_Sign_In');
    String friendEmail;
    String currentUserMobileNumber;

    friend
        .where('email', isEqualTo: email)
        .get()
        .then((value) => {
              if (value.size > 0)
                {
                  value.docs.forEach((element) {
                    if (element['mobile'] != null) {
                      currentUserMobileNumber = element['mobile'];
                    }
                  })
                }
              else
                {
                  EasyLoading.dismiss(),
                  Navigator.pop(context),
                  Fluttertoast.showToast(
                      msg: 'Email doesn\'t found',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.blue,
                      textColor: Colors.white,
                      fontSize: 16.0)
                }
            })
        .then((value) => {
              friend
                  .where('mobile', isEqualTo: widget.post['mobile'])
                  .get()
                  .then((value) => {
                        if (value.size > 0)
                          {
                            value.docs.forEach((element) {
                              if (element['email'] != null) {
                                friendEmail = element['email'];
                                addDetails(
                                    email,
                                    friendEmail,
                                    currentUserMobileNumber,
                                    widget.post['mobile'],
                                    amount,
                                    description);
                              } else {
                                Fluttertoast.showToast(
                                    msg: 'Email doesn\'t match',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.blue,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            })
                          }
                        else
                          {
                            EasyLoading.dismiss(),
                            Navigator.pop(context),
                            Fluttertoast.showToast(
                                msg: 'Friend Email doesn\'t match',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.blue,
                                textColor: Colors.white,
                                fontSize: 16.0)
                          }
                      })
            });
  }

  addDetails(String email, String friendEmail, String currentUserMobileNumber,
      String friendMobileNumber, String amount, String description) {
    CollectionReference add = FirebaseFirestore.instance
        .collection('Customer_Sign_In')
        .doc(email)
        .collection('friends')
        .doc(friendEmail)
        .collection('Expense');

    CollectionReference addToFriend = FirebaseFirestore.instance
        .collection('Customer_Sign_In')
        .doc(friendEmail)
        .collection('friends')
        .doc(email)
        .collection('Expense');

    if (dropdownValue == 'You Paid') {
      add.add({
        'from': currentUserMobileNumber,
        'to': friendMobileNumber,
        'amount': amount,
        'description': description,
      }).then((value) {
        String id = value.id;
        addToFriend.doc(id).set({
          'from': currentUserMobileNumber,
          'to': friendMobileNumber,
          'amount': amount,
          'description': description,
        });
        EasyLoading.dismiss();
        setState(() {
          count = 1;
          if (count == 1) {
            _data = getData();
            count = 0;
          }
        });
        Navigator.pop(context);
      });
    } else {
      add.add({
        'to': currentUserMobileNumber,
        'from': friendMobileNumber,
        'amount': amount,
        'description': description,
      }).then((value) {
        String id = value.id;
        addToFriend.doc(id).set({
          'to': currentUserMobileNumber,
          'from': friendMobileNumber,
          'amount': amount,
          'description': description,
        });
        EasyLoading.dismiss();
        setState(() {
          count = 1;
          if (count == 1) {
            _data = getData();
            count = 0;
          }
        });
        Navigator.pop(context);
      });
    }
  }
}
