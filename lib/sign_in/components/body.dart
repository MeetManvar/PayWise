import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:paywise/complete_profile/complete_profile_screen.dart';
import 'package:paywise/components/custom_surfix_icon.dart';
import 'package:paywise/components/default_button.dart';
import 'package:paywise/components/no_account_text.dart';
import 'package:paywise/constants.dart';
import 'package:paywise/home/home_screen.dart';
import 'package:paywise/user_detail.dart';
import '../../size_config.dart';
import 'sign_form.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String mobile;
  String code;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _codeController = TextEditingController();
  final List<String> errors = [];

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                Text(
                  "Welcome Back",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(28),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Sign in with your email and password  \nor continue with social media",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                SignForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.03),
                Text('OR'),
                SignInButton(
                  Buttons.Google,
                  onPressed: () {
                    signInWithGoogle().then((result) {
                      if (result != null) {
                        _checkUser(result.email, context);
                        // addEmail(result.email);
                      } else {
                        EasyLoading.dismiss();
                      }
                    },
                        onError: (e) => Fluttertoast.showToast(
                            msg: e.message != null
                                ? e.message
                                : "Something Went Wrong!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.white,
                            textColor: Colors.black,
                            fontSize: 16.0));
                    EasyLoading.dismiss();
                  },
                ),
                SignInButtonBuilder(
                  backgroundColor: Colors.white,
                  icon: Icons.phone,
                  iconColor: Colors.blue,
                  onPressed: () {
                    _showSelectionDialog(context);
                  },
                  text: 'Sign In with Mobile',
                  textColor: Colors.blueGrey,
                ),
                SizedBox(height: getProportionateScreenHeight(30)),
                NoAccountText(),
                SizedBox(height: getProportionateScreenHeight(20)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ignore: missing_return
  Future<void> _showSelectionDialog(BuildContext context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 12.0),
                    child: Text(
                      'Enter your Mobile Number to authenticate',
                    ),
                  ),
                  Divider(),
                  buildPhoneNumberFormField(),
                  Divider(),
                  DefaultButton(
                    text: 'Continue',
                    press: () async {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        EasyLoading.show(status: 'loading...');
                        mobile = _mobileController.text.trim();
                        if (mobile.length == 10 && mobile.isNotEmpty) {
                          try {
                            await FirebaseAuth.instance.verifyPhoneNumber(
                              phoneNumber: '+91' + mobile,
                              verificationCompleted:
                                  (PhoneAuthCredential credential) async {
                                await _auth.signInWithCredential(credential);
                              },
                              verificationFailed: (FirebaseAuthException e) {
                                EasyLoading.dismiss();
                                if (e.code == 'invalid-phone-number') {
                                  EasyLoading.dismiss();
                                  print(
                                      'The provided phone number is not valid.');
                                  Fluttertoast.showToast(
                                      msg:
                                          "The provided phone number is not valid.",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.white,
                                      textColor: Colors.black,
                                      fontSize: 16.0);
                                }
                              },
                              codeSent: (String verificationId,
                                  int resendToken) async {
                                EasyLoading.dismiss();
                                _verifyCodeDialog(
                                    context, code, verificationId, mobile);
                              },
                              timeout: const Duration(seconds: 60),
                              codeAutoRetrievalTimeout:
                                  (String verificationId) {
                                EasyLoading.dismiss();
                              },
                            );
                          } catch (e) {
                            EasyLoading.dismiss();
                            Fluttertoast.showToast(
                                msg: "Failed to Verify Phone Number",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.white,
                                textColor: Colors.black,
                                fontSize: 16.0);
                          }
                        } else {
                          EasyLoading.dismiss();
                          Fluttertoast.showToast(
                              msg: "Make sure length of Mobile no. is TEN!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.white,
                              textColor: Colors.black,
                              fontSize: 16.0);
                        }
                      }
                    },
                  ),
                  Divider(),
                ],
              ),
            )));
  }

  // ignore: missing_return
  Future<void> _verifyCodeDialog(BuildContext context, String otpCode,
      String verificationId, String number) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 12.0),
                    child: Text(
                      'Enter your otp to verify number',
                    ),
                  ),
                  Divider(),
                  buildVerifyCodeFormField(),
                  Divider(),
                  DefaultButton(
                    text: 'Continue',
                    press: () async {
                      EasyLoading.show(status: 'loading...');
                      try {
                        PhoneAuthCredential credential =
                            PhoneAuthProvider.credential(
                                verificationId: verificationId,
                                smsCode: _codeController.text.trim());
                        final User user =
                            (await _auth.signInWithCredential(credential)).user;

                        if (user != null) {
                          _checkUserNumber(number);
                          // EasyLoading.dismiss();
                          // Navigator.pop(context);
                          // Navigator.pushAndRemoveUntil(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (BuildContext context) => HomeScreen(),
                          //   ),
                          //   (route) => false,
                          // );
                        } else {
                          EasyLoading.dismiss();
                          Fluttertoast.showToast(
                              msg:
                                  "Something went wrong! Please try after some time",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.white,
                              textColor: Colors.black,
                              fontSize: 16.0);
                        }
                      } catch (e) {
                        EasyLoading.dismiss();
                        Fluttertoast.showToast(
                            msg: "Invalid OTP",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.white,
                            textColor: Colors.black,
                            fontSize: 16.0);
                        Navigator.pop(context);
                      }
                    },
                  ),
                  Divider(),
                ],
              ),
              // )
            ));
  }

  _checkUserNumber(String mobile) {
    EasyLoading.show(status: 'loading...');
    CollectionReference checkUser =
        FirebaseFirestore.instance.collection('Customer_Sign_In');

    checkUser.where('mobile', isEqualTo: mobile).get().then((value) => {
          if (value.size > 0)
            {
              value.docs.forEach((element) {
                if (element['profilestatus']) {
                  String email = element['email'];
                  addEmail(email);
                  Fluttertoast.showToast(
                      msg: "...Sign In successful..",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      fontSize: 16.0);
                  EasyLoading.dismiss();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => HomeScreen(),
                    ),
                    (route) => false,
                  );
                } else {
                  Fluttertoast.showToast(
                      msg: "...Complete Your Profile to Continue...",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      fontSize: 16.0);
                  EasyLoading.dismiss();
                  Navigator.pushNamed(context, CompleteProfileScreen.routeName,
                      arguments: {
                        'mobile': mobile,
                        'password':
                            'User Signed in with Mobile(No Password Available)',
                      });
                }
              })
            }
          else
            {
              EasyLoading.dismiss(),
              Navigator.pushNamed(context, CompleteProfileScreen.routeName,
                  arguments: {
                    'mobile': mobile,
                    'password':
                        'User Signed in with Mobile(No Password Available)',
                  })
              // checkUser.doc(email).set({
              //   'mobile': mobile,
              //   'password': 'User Signed in with Google(No Password Available)',
              //   'profilestatus': false
              // }).then((value) => {
              //       EasyLoading.dismiss(),
              //       Navigator.pushNamed(
              //           context, CompleteProfileScreen.routeName,
              //           arguments: {
              //             'email': mobile,
              //             'password':
              //                 'User Signed in with Google(No Password Available)',
              //           })
              //     })
            }
        });
  }

  TextFormField buildVerifyCodeFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => code = newValue,
      controller: _codeController,
      autofocus: true,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPhoneNumberNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPhoneNumberNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "OTP code",
        hintText: "Enter your code",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => mobile = newValue,
      controller: _mobileController,
      autofocus: true,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPhoneNumberNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPhoneNumberNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Phone Number",
        hintText: "Enter your phone number",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  Future<User> signInWithGoogle() async {
    //EasyLoading.show(status: 'loading...');
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    EasyLoading.show(status: 'loading...');
    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User user = authResult.user;
    //EasyLoading.show(status: 'loading...');
    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);
      print('signInWithGoogle succeeded: $user');

      return user;
    }

    return null;
  }

  _checkUser(var email, var context) {
    EasyLoading.show(status: 'loading...');
    CollectionReference checkUser =
        FirebaseFirestore.instance.collection('Customer_Sign_In');

    checkUser.where('email', isEqualTo: email).get().then((value) => {
          if (value.size > 0)
            {
              value.docs.forEach((element) {
                if (element['profilestatus']) {
                  addEmail(email);
                  Fluttertoast.showToast(
                      msg: "...Sign In successful..",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      fontSize: 16.0);
                  EasyLoading.dismiss();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => HomeScreen(),
                    ),
                    (route) => false,
                  );
                } else {
                  Fluttertoast.showToast(
                      msg: "...Complete Your Profile to Continue...",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      fontSize: 16.0);
                  EasyLoading.dismiss();
                  Navigator.pushNamed(context, CompleteProfileScreen.routeName,
                      arguments: {
                        'email': email,
                        'password':
                            'User Signed in with Google(No Password Available)',
                      });
                }
              })
            }
          else
            {
              checkUser.doc(email).set({
                'email': email,
                'password': 'User Signed in with Google(No Password Available)',
                'location': ' ',
                'profilestatus': false
              }).then((value) => {
                    EasyLoading.dismiss(),
                    Navigator.pushNamed(
                        context, CompleteProfileScreen.routeName,
                        arguments: {
                          'email': email,
                          'password':
                              'User Signed in with Google(No Password Available)',
                        })
                  })
            }
        });
  }
}
