import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:paywise/components/custom_surfix_icon.dart';
import 'package:paywise/components/default_button.dart';
import 'package:paywise/components/form_error.dart';
import 'package:paywise/home/home_screen.dart';
import '../../constants.dart';
import '../../size_config.dart';
import '../../user_detail.dart';

class CompleteProfileForm extends StatefulWidget {
  //test commit
  @override
  _CompleteProfileFormState createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  String firstName;
  String lastName;
  String mobile;
  String email;
  String password;
  QuerySnapshot uid;
  TextEditingController _fnameController = TextEditingController();
  TextEditingController _lnameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

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
    final Map<String, Object> data = ModalRoute.of(context).settings.arguments;
    email = data['email'];
    password = data['password'];
    mobile = data['mobile'];

    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildFirstNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildLastNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          mobile == null
              ? buildPhoneNumberFormField()
              : email == null
                  ? buildEmailFormField()
                  : buildPhoneNumberFormField(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "continue",
            press: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                firstName = _fnameController.text.trim();
                lastName = _lnameController.text.trim();
                if (mobile == null) {
                  mobile = _mobileController.text.trim();
                } else if (email == null) {
                  email = _emailController.text.trim();
                }
                // if (mobile != null) {
                //   updateCustomerData(
                //       firstName, lastName, email, password, mobile, context);
                //   EasyLoading.show(status: 'loading...');
                // } else if(email!=null){
                //   updateCustomerDataWithEmail(
                //       firstName, lastName, email, mobile, context);
                //   EasyLoading.show(status: 'loading...');
                // }

                updateCustomerData(
                    firstName, lastName, email, password, mobile, context);
                EasyLoading.show(status: 'loading...');
              }
            },
          ),
        ],
      ),
    );
  }

  // Future<void> updateCustomerDataWithEmail(String firstname, String lastname,
  //     String email, String mobile, BuildContext context) {
  //   CollectionReference profile =
  //       FirebaseFirestore.instance.collection('Customer_Sign_In');

  //   return profile.doc(email).set({
  //     'email': email,
  //     'password': 'User Signed In With Mobile Number',
  //     'fname': firstName,
  //     'lname': lastName,
  //     'mobile': mobile,
  //     'profilestatus': true,
  //     'devicetoken': ' ',
  //   }).then(
  //     (_) {
  //       addEmail(email);
  //       Fluttertoast.showToast(
  //           msg: '...Data Added Successfully...',
  //           toastLength: Toast.LENGTH_SHORT,
  //           gravity: ToastGravity.BOTTOM,
  //           timeInSecForIosWeb: 1,
  //           backgroundColor: Colors.blue,
  //           textColor: Colors.white,
  //           fontSize: 16.0);
  //       Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(
  //           builder: (BuildContext context) => HomeScreen(),
  //         ),
  //         (route) => false,
  //       );
  //       EasyLoading.dismiss();
  //     },
  //   ).catchError((error) {
  //     Fluttertoast.showToast(
  //         msg: error.message != null ? error.message : "Something Went Wrong!",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.blue,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //     EasyLoading.dismiss();
  //   });
  // }

  Future<void> updateCustomerData(String firstname, String lastname,
      String email, String password, String mobile, BuildContext context) {
    CollectionReference profile =
        FirebaseFirestore.instance.collection('Customer_Sign_In');

    return profile.doc(email).set({
      'email': email,
      'password': password,
      'fname': firstName,
      'lname': lastName,
      'mobile': mobile,
      'profilestatus': true,
      'devicetoken': ' ',
    }).then(
      (_) {
        addEmail(email);
        Fluttertoast.showToast(
            msg: '...Data Added Successfully...',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 16.0);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen(),
          ),
          (route) => false,
        );
        EasyLoading.dismiss();
      },
    ).catchError((error) {
      Fluttertoast.showToast(
          msg: error.message != null ? error.message : "Something Went Wrong!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0);
      EasyLoading.dismiss();
    });
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      controller: _emailController,
      onChanged: (value) {
        email = value;
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => mobile = newValue,
      controller: _mobileController,
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
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  TextFormField buildLastNameFormField() {
    return TextFormField(
      onSaved: (newValue) => lastName = newValue,
      controller: _lnameController,
      decoration: InputDecoration(
        labelText: "Last Name",
        hintText: "Enter your last name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildFirstNameFormField() {
    return TextFormField(
      onSaved: (newValue) => firstName = newValue,
      controller: _fnameController,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "First Name",
        hintText: "Enter your first name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }
}
