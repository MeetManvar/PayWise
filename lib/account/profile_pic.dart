import 'dart:io';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:paywise/size_config.dart';

class ProfilePic extends StatefulWidget {
  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  File image;
  File imagestorage;
  String imageUrl;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final auth = FirebaseAuth.instance.currentUser.email;

  @protected
  void initState() {
    super.initState();
    // downloadFileExample();
  }

  // downloadFileExample() async {
  //   try {
  //     String downloadURL = await firebase_storage.FirebaseStorage.instance
  //         .ref('Customer/$auth/profilepic/imageName')
  //         .getDownloadURL();

  //     if (downloadURL != null) {
  //       print(downloadURL);

  //       setState(() {
  //         imageUrl = downloadURL;
  //       });
  //     }
  //   } on firebase_storage.FirebaseException catch (e) {
  //     if (e.code == 'permission-denied') {
  //       print('User does not have permission to upload to this reference.');
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        // ignore: deprecated_member_use
        overflow: Overflow.visible,
        children: [
          CircleAvatar(
            backgroundImage: imageUrl != null
                ? NetworkImage(imageUrl)
                : AssetImage("assets/images/Profile Image.png"),
            // ignore: deprecated_member_use
            child: FlatButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SimpleDialog(
                        contentPadding: EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              SizedBox(
                                height: 400,
                                width: 400,
                                child: Stack(
                                  fit: StackFit.expand,
                                  // ignore: deprecated_member_use
                                  overflow: Overflow.visible,
                                  children: [
                                    Image(
                                      image: imageUrl != null
                                          ? NetworkImage(imageUrl)
                                          : AssetImage(
                                              "assets/images/Profile Image.png"),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Expanded(
                                    child: InkWell(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(6)),
                                          color: Colors.lightBlueAccent,
                                        ),
                                        height: 45,
                                        child: Center(
                                          child: InkWell(
                                            onTap: () {
                                              // removeFile();
                                            },
                                            child: Text(
                                              "Remove",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        12),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      );
                    });
              },
              child: null,
            ),
          ),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              // ignore: deprecated_member_use
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: BorderSide(color: Colors.white),
                ),
                color: Color(0xFFF5F6F9),
                onPressed: () {
                  _showSelectionDialog(context);
                },
                child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
              ),
            ),
          )
        ],
      ),
    );
  }

  // removeFile() async {
  //   try {
  //     await firebase_storage.FirebaseStorage.instance
  //         .ref('Customer/$auth/profilepic')
  //         .child('imageName')
  //         .delete();

  //     Fluttertoast.showToast(
  //         msg: '...Removed Successfully...',
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.blue,
  //         textColor: Colors.white,
  //         fontSize: 16.0);

  //     Navigator.of(context).pop();

  //     setState(() {
  //       imageUrl = null;
  //     });
  //   } on firebase_storage.FirebaseException catch (e) {
  //     if (e.code == 'permission-denied') {
  //       print('User does not have permission to upload to this reference.');
  //     }
  //   }
  // }

  Future<void> _showSelectionDialog(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        _openGallery(context);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _openCamera(context);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _openGallery(BuildContext context) async {
    // ignore: deprecated_member_use
    // File picture = (await ImagePicker.pickImage(
    //     source: ImageSource.gallery, imageQuality: 10));

    // var file = File(picture.path);

    // if (picture != null) {
    //   //Upload to Firebase
    //   await storage
    //       .ref('Customer')
    //       .child('/$auth/profilepic/imageName')
    //       .putFile(file);

    //   downloadFileExample();

    //   setState(() {
    //     image = file;
    //   });
    // } else {
    //   print('No Image Path Received');
    // }
  }

  _openCamera(BuildContext context) async {
    // ignore: deprecated_member_use
    // File picture = await ImagePicker.pickImage(
    //     source: ImageSource.camera, imageQuality: 50);

    // var file = File(picture.path);

    // if (picture != null) {
    //   //Upload to Firebase
    //   await storage
    //       .ref('Customer')
    //       .child('/$auth/profilepic/imageName')
    //       .putFile(file);

    //   setState(() {
    //     image = picture;
    //     //downloadFileExample();
    //   });
    // } else {
    //   print('No Image Path Received');
    // }
  }
}
