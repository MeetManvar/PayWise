import 'package:flutter/material.dart';
import 'package:paywise/account/account.dart';
import 'package:paywise/friends_dashboard/friendsdashborad.dart';
import 'package:paywise/home/groupdashboard.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = '\homescreen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        // drawer: Account(),
        appBar: AppBar(
          // leading: IconButton(
          //     icon: Icon(
          //       Icons.supervised_user_circle,
          //       color: Colors.white,
          //     ),
          //     onPressed: () {
          //       Scaffold.of(context).openEndDrawer();
          //     },
          //   ),
          backgroundColor: Colors.cyan,
          elevation: 4,
          bottom: TabBar(
            indicatorColor: Colors.indigo[900],
            indicatorWeight: 4,
            tabs: [
              Tab(text: "Groups"),
              Tab(
                text: "Friends",
              ),
              Tab(
                text: "Expenses",
              ),
            ],
          ),
          centerTitle: true,
          title: Text(
            "PayWise",
            style: TextStyle(
              fontFamily: 'Muli',
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: 24,
              color: Colors.white,
              letterSpacing: 0.8,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.supervised_user_circle,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, Account.routeName);
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            )
          ],
        ),
        body: TabBarView(
          children: [
            Groupdashboard(),
            Friendsdashboard(),
            Groupdashboard(),
          ],
        ),
      ),
    );

    // return Scaffold(
    //   floatingActionButton: FloatingActionButton.extended(
    //     onPressed: () {},
    //     backgroundColor: Colors.cyan,
    //     icon: Icon(Icons.bookmark),
    //     label: Text('Add expense'),
    //   ),
    //   appBar: AppBar(
    //     title: Row(children: [
    //       Expanded(
    //         child: TextField(
    //           onChanged: (value) => print(value),
    //           decoration: InputDecoration(
    //               contentPadding: EdgeInsets.symmetric(
    //                   horizontal: getProportionateScreenWidth(20),
    //                   vertical: getProportionateScreenWidth(9)),
    //               border: InputBorder.none,
    //               focusedBorder: InputBorder.none,
    //               enabledBorder: InputBorder.none,
    //               hintText: "Search Groups",
    //               prefixIcon: Icon(Icons.search)),
    //         ),
    //       ),
    //       Divider(),
    //       Icon(Icons.add_box,color: Colors.cyan,)
    //     ]),
    //     actions: [],
    //   ),
    //   bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.Groups),
    //   body: Center(
    //     child: TextButton(
    //       onPressed: () async {
    //         await FirebaseAuth.instance.signOut();
    //         GoogleSignIn().signOut();
    //         addEmail('');
    //         Navigator.pushAndRemoveUntil(
    //           context,
    //           MaterialPageRoute(
    //             builder: (BuildContext context) => SignInScreen(),
    //           ),
    //           (route) => false,
    //         );
    //       },
    //       child: Text('PayWise Home'),
    //     ),
    //   ),
    // );
  }

//   @override
//   void initState() {
//     super.initState();
//     // _deviceToken();
//   }

//  _deviceToken() {
//     final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
//     _firebaseMessaging.configure(
//       // ignore: missing_return
//       onLaunch: (Map<String, dynamic> message) {
//         print('onLaunch called');
//         //return null;
//       },
//       // ignore: missing_return
//       onResume: (Map<String, dynamic> message) {
//         print('onResume called');
//         //return null;
//       },
//       // ignore: missing_return
//       onMessage: (Map<String, dynamic> message) {
//         print('onMessage called');
//         //return null;
//       },
//     );
//     _firebaseMessaging.subscribeToTopic('all');
//     _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(
//       sound: true,
//       badge: true,
//       alert: true,
//     ));
//     _firebaseMessaging.onIosSettingsRegistered
//         .listen((IosNotificationSettings settings) {
//       print('Hello');
//     });
//     _firebaseMessaging.getToken().then((token) {
//       print(token); // Print the Token in Console
//       //finalToken = DeviceToken(finalToken: token);
//       finalToken = token;
//       _updateDeviceToken(token);
//     });
//   }
//   _updateDeviceToken(String token) async {
//     CollectionReference signIn =
//         FirebaseFirestore.instance.collection('Customer_Sign_In');
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String email = prefs.getString('email');
//     if (token.isNotEmpty) {
//       return signIn.doc(email).update({'devicetoken': token});
//     }
//   }
}
