import 'package:paywise/account/account.dart';
import 'package:paywise/account/my_account.dart';
import 'package:paywise/friends_dashboard/add_friend.dart';
import 'package:paywise/home/home_screen.dart';
import 'package:paywise/sign_in/sign_in_screen.dart';
import 'package:paywise/sign_up/sign_up_screen.dart';
import 'package:paywise/splash/splash_screen.dart';
import 'package:flutter/widgets.dart';
import 'complete_profile/complete_profile_screen.dart';
import 'forgot_password/forgot_password_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  Account.routeName: (context) => Account(),
  AddFriend.routeName:(context) => AddFriend(),
  MyAccount.routeName:(context) => MyAccount(),
};
