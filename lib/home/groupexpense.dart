import 'package:flutter/material.dart';



class GroupExpense extends StatefulWidget {
  @override
  _GroupExpense createState() => _GroupExpense();
}

class _GroupExpense extends State<GroupExpense> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF00BCD4),
        title: Text(
          "Account",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 0.8,
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height:35,),
          Padding(
            padding: EdgeInsets.all(10),
            child: Icon(
              Icons.account_circle,
              size: 100,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "Meet Manvar",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26,
                letterSpacing: 0.8,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 55, right: 55, top: 0, bottom: 10),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5),
                  // child:Icon(Icons.email_outlined)
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    "meet.manvar@gmail.com",
                    //textAlign: TextAlign.center,
                    style: TextStyle(
                      //fontWeight:FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 0.8,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
