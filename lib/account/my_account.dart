import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paywise/account/account_info.dart';
import 'package:paywise/account/profile_pic.dart';
import 'package:paywise/size_config.dart';

class MyAccount extends StatefulWidget {
  static String routeName = "/myaccount";
  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  String email;
  String fname, lname;
  String mobile;

  // TextEditingController _fnameController = TextEditingController();
  // TextEditingController _lnameController = TextEditingController();
  // TextEditingController _mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Map<String, Object> data = ModalRoute.of(context).settings.arguments;
    mobile = data['mobile'];
    email = data['email'];
    fname = data['fname'];
    lname = data['lname'];
    return Scaffold(
      appBar: AppBar(
        title: Text("My Profile"),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     _showAndEditData();
      //   },
      //   child: Icon(Icons.edit),
      //   backgroundColor: Colors.cyan,
      // ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            // SizedBox(height: getProportionateScreenHeight(20),),
            ProfilePic(),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            Divider(),
            SizedBox(height: 20),
            AccountInfo(
              text: fname + ' ' + lname,
              icon: "assets/icons/User Icon.svg",
              press: () => {},
            ),
            AccountInfo(
              text: email,
              icon: "assets/icons/Mail.svg",
              press: () {},
            ),
            AccountInfo(
              text: mobile,
              icon: "assets/icons/Call.svg",
              press: () {},
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }

  // _showAndEditData() {
  //   _fnameController = TextEditingController(text: fname);
  //   _lnameController = TextEditingController(text: lname);
  //   _mobileController = TextEditingController(text: mobile);

  //   showDialog(
  //       context: context,
  //       builder: (_) {
  //         return new CupertinoAlertDialog(
  //           // backgroundColor: Colors.white,
  //           // // Color(0xFF4A3298),
  //           // insetPadding: EdgeInsets.all(5),
  //           title: Text('Edit Profile'),
  //           content: SingleChildScrollView(
  //               child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                 Container(
  //                   padding: EdgeInsets.all(12),
  //                   decoration: BoxDecoration(
  //                       // color: Colors.tealAccent,
  //                       //borderRadius: BorderRadius.circular(0),
  //                       ),
  //                   child: TextField(
  //                     decoration: InputDecoration(
  //                       hintStyle: TextStyle(fontSize: 17),
  //                       hintText: 'First name',
  //                       suffixIcon: Icon(
  //                         Icons.verified_user,
  //                         color: kPrimaryColor,
  //                       ),
  //                       enabledBorder: UnderlineInputBorder(
  //                         borderSide: BorderSide(color: Colors.cyan),
  //                       ),
  //                       focusedBorder: UnderlineInputBorder(
  //                         borderSide: BorderSide(color: Colors.purple),
  //                       ),
  //                       //border: InputBorder.none,
  //                       contentPadding: EdgeInsets.all(15),
  //                     ),
  //                     textAlign: TextAlign.left,
  //                     maxLines: null,
  //                     controller: _fnameController,
  //                   ),
  //                 ),
  //                 Container(
  //                   padding: EdgeInsets.all(12),
  //                   decoration: BoxDecoration(
  //                       // color: Colors.tealAccent,
  //                       //borderRadius: BorderRadius.circular(0),
  //                       ),
  //                   child: TextField(
  //                     decoration: InputDecoration(
  //                       hintStyle: TextStyle(fontSize: 17),
  //                       hintText: 'Last name',
  //                       suffixIcon: Icon(
  //                         Icons.verified_user,
  //                         color: kPrimaryColor,
  //                       ),
  //                       enabledBorder: UnderlineInputBorder(
  //                         borderSide: BorderSide(color: Colors.cyan),
  //                       ),
  //                       focusedBorder: UnderlineInputBorder(
  //                         borderSide: BorderSide(color: Colors.purple),
  //                       ),
  //                       //border: InputBorder.none,
  //                       contentPadding: EdgeInsets.all(15),
  //                     ),
  //                     textAlign: TextAlign.left,
  //                     maxLines: null,
  //                     controller: _lnameController,
  //                   ),
  //                 ),
  //                 Container(
  //                   padding: EdgeInsets.all(12),
  //                   decoration: BoxDecoration(
  //                       // color: Colors.tealAccent,
  //                       //borderRadius: BorderRadius.circular(0),
  //                       ),
  //                   child: TextField(
  //                     decoration: InputDecoration(
  //                       hintStyle: TextStyle(fontSize: 17),
  //                       hintText: 'Mobile No.',
  //                       suffixIcon: Icon(
  //                         Icons.call,
  //                         color: kPrimaryColor,
  //                       ),
  //                       enabledBorder: UnderlineInputBorder(
  //                         borderSide: BorderSide(color: Colors.cyan),
  //                       ),
  //                       focusedBorder: UnderlineInputBorder(
  //                         borderSide: BorderSide(color: Colors.purple),
  //                       ),
  //                       //border: InputBorder.none,
  //                       contentPadding: EdgeInsets.all(15),
  //                     ),
  //                     textAlign: TextAlign.left,
  //                     maxLines: null,
  //                     controller: _mobileController,
  //                   ),
  //                 ),
  //                 SizedBox(height: getProportionateScreenWidth(12)),
  //               ])),

  //           actions: <Widget>[
  //             // ignore: deprecated_member_use
  //             new FlatButton(
  //                 child: const Text('BACK'),
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                 }),
  //             // ignore: deprecated_member_use
  //             new FlatButton(
  //                 child: const Text('CHANGE'),
  //                 onPressed: () {
  //                   _checkData();
  //                 })
  //           ],
  //         );
  //       });
  // }

  // _checkData() {
  //   if (_fnameController.text.trim().isEmpty ||
  //       _lnameController.text.trim().isEmpty) {
  //     Fluttertoast.showToast(
  //         msg: "Fill Details Correctly",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         timeInSecForIosWeb: 3,
  //         backgroundColor: Colors.blue,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //   } else if (_fnameController.text.trim().isNotEmpty ||
  //       _lnameController.text.trim().isNotEmpty) {
  //     EasyLoading.show(status: 'updating...');
  //     _editData();
  //   }
  // }

  // _editData() async {
  //   setState(() {
  //     fname = _fnameController.text.trim();
  //     lname = _lnameController.text.trim();
  //     mobile = _mobileController.text.trim();
  //   });

  //   CollectionReference editData =
  //       FirebaseFirestore.instance.collection('Customer_Sign_In');
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   String email = pref.getString('email');

  //   return editData.doc(email).update({
  //     'fname': fname,
  //     'lname': lname,
  //     'mobile': mobile,
  //   }).then((value) => {
  //         EasyLoading.dismiss(),
  //         Navigator.pushAndRemoveUntil(
  //             context,
  //             MaterialPageRoute(
  //               builder: (BuildContext context) => HomeScreen(),
  //             ),
  //             (route) => false)
  //       });
  // }
}

// ignore: must_be_immutable
// class MyAccount extends StatelessWidget {
//   static String routeName = "/myaccount";
//   String email;
//   String name;
//   String mobile;
//   String address;

//   @override
//   Widget build(BuildContext context) {

//     final  Map<String, Object> data = ModalRoute.of(context).settings.arguments;
//     mobile = data['mobile'];
//     address = data['address'];
//     email = data['email'];
//     name = data['name'];

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Account Info"),
//       ),
//       floatingActionButton:  FloatingActionButton(
//         onPressed: () {

//         },
//         child: Icon(Icons.edit),
//         backgroundColor: Color(0xFF4A3298),
//       ),
//       body: SingleChildScrollView(
//       padding: EdgeInsets.symmetric(vertical: 20),
//       child: Column(
//         children: [
//           ProfilePic(),
//           SizedBox(height: 20),
//           AccountInfo(
//             text: name,
//             icon: "assets/icons/User Icon.svg",
//             press: () => {

//             },
//           ),
//           AccountInfo(
//             text: email,
//             icon: "assets/icons/Mail.svg",
//             press: () {

//             },
//           ),
//           AccountInfo(
//             text: mobile,
//             icon: "assets/icons/Call.svg",
//             press: () {

//             },
//           ),
//           AccountInfo(
//             text: address,
//             icon: "assets/icons/Location point.svg",
//             press: () {

//             },
//           ),
//         ],
//       ),
//     ),
//     );
//   }
// }
