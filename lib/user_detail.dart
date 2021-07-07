import 'package:shared_preferences/shared_preferences.dart';

addEmail(String email) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('email', email);
}

getEmail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String email = prefs.getString('email');
  return email;
}

// addMechanicEmail(String email) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   prefs.setString('memail', email);
// }

// getMechanicEmail() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //Return String
//   String email = prefs.getString('memail');
//   return email;
// }