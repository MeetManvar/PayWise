import 'package:flutter/material.dart';
import 'package:paywise/account/account.dart';
import 'package:paywise/home/home_screen.dart';
import '../constants.dart';
import '../enums.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    Key key,
    @required this.selectedMenu,
  }) : super(key: key);

  final MenuState selectedMenu;

  @override
  Widget build(BuildContext context) {
    final Color inActiveIconColor = Color(0xFFB6B6B6);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // ignore: deprecated_member_use
              FlatButton.icon(
                  onPressed: () => {
                        if (MenuState.Groups != selectedMenu)
                          {
                            Navigator.pushNamed(context, HomeScreen.routeName),
                          }
                      },
                  icon: Icon(
                    Icons.people,
                    color: MenuState.Groups == selectedMenu
                        ? kPrimaryColor
                        : inActiveIconColor,
                  ),
                  label: MenuState.Groups == selectedMenu
                      ? Text(
                          'Groups',
                        )
                      : Text('')),
              // ignore: deprecated_member_use
              FlatButton.icon(
                  icon: Icon(
                    Icons.face,
                    color: MenuState.Friends == selectedMenu
                        ? kPrimaryColor
                        : inActiveIconColor,
                  ),
                  onPressed: () => {
                        if (MenuState.Friends != selectedMenu)
                          {
                            // Navigator.pushNamed(context, ChatHomeScreen.routeName)
                          }
                      },
                  label: MenuState.Friends == selectedMenu
                      ? Text('Friends')
                      : Text('')),
              // ignore: deprecated_member_use
              FlatButton.icon(
                  icon: Icon(
                    Icons.broken_image_outlined,
                    color: MenuState.Activity == selectedMenu
                        ? kPrimaryColor
                        : inActiveIconColor,
                  ),
                  onPressed: () => {
                        if (MenuState.Activity != selectedMenu)
                          {
                            // Navigator.pushNamed(
                            //     context, ProfileScreen.routeName),
                          }
                      },
                  label: MenuState.Activity == selectedMenu
                      ? Text('Activity')
                      : Text('')),
              // ignore: deprecated_member_use
              FlatButton.icon(
                  icon: Icon(
                    Icons.account_circle_outlined,
                    color: MenuState.Account == selectedMenu
                        ? kPrimaryColor
                        : inActiveIconColor,
                  ),
                  onPressed: () => {
                        if (MenuState.Account != selectedMenu)
                          {
                            Navigator.pushNamed(context, Account.routeName)
                          }
                      },
                  label: MenuState.Account == selectedMenu
                      ? Text('Account')
                      : Text('')),
            ],
          )),
    );
  }
}
