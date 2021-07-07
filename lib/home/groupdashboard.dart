import 'package:flutter/material.dart';
import 'package:paywise/size_config.dart';

class Groupdashboard extends StatefulWidget {
  @override
  _Groupdashboard createState() => new _Groupdashboard();
}

class _Groupdashboard extends State<Groupdashboard> {
  _displayDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            elevation: 6,
            backgroundColor: Colors.transparent,
            child: _DialogWithTextField(context),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: getProportionateScreenHeight(150),
            ),
            Center(
                child: Image.asset(
              'assets/images/list.png',
              scale: 3,
            )),
            SizedBox(height: getProportionateScreenHeight(20),),
            Text(
              'Create Group to Split Expenses',
              style: TextStyle(
                  fontFamily: 'Muli',
                  color: Colors.grey,
                  // fontWeight: FontWeight.bold,
                  fontSize: getProportionateScreenWidth(22)),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
        onPressed: _displayDialog,
        icon: Icon(Icons.add),
        label: Text(
          'Create Group',
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Muli'),
        ),
      ),
    );
  }
}

// ignore: non_constant_identifier_names
Widget _DialogWithTextField(BuildContext context) => Container(
      height: 320,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: <Widget>[
          SizedBox(height: 24),
          Text(
            "create group".toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10, right: 15, left: 15),
            child: Icon(
              Icons.account_circle,
              size: 100,
            ),
          ),
          Container(
            width: 150.0,
            height: 1.0,
            color: Colors.grey[400],
          ),
          Padding(
              padding: EdgeInsets.only(top: 10, right: 15, left: 15),
              child: TextFormField(
                maxLines: 1,
                autofocus: true,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Group Name',
                  hintText: 'Group Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              )),
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
                  print('Update the user info');
                  // return Navigator.of(context).pop(true);
                },
              )
            ],
          ),
        ],
      ),
    );
