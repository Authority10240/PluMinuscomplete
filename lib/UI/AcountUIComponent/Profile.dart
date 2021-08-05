import 'package:flutter/material.dart';
import 'package:treva_shop_flutter/DataModels/StaticValues.dart';
import 'package:treva_shop_flutter/UI/HOMEUIComponent/AboutApps.dart';
import 'package:treva_shop_flutter/UI/AcountUIComponent/CallCenter.dart';
import 'package:treva_shop_flutter/UI/AcountUIComponent/Message.dart';
import 'package:treva_shop_flutter/UI/LoginOrSignup/ChoseLoginOrSignup.dart';
import 'package:treva_shop_flutter/UI/AcountUIComponent/CreditCardSetting.dart';
import 'package:treva_shop_flutter/UI/AcountUIComponent/MyOrders.dart';
import 'package:treva_shop_flutter/UI/AcountUIComponent/Notification.dart';
import 'package:treva_shop_flutter/UI/AcountUIComponent/SettingAcount.dart';
import 'package:treva_shop_flutter/UI/LoginOrSignup/Signup.dart';

class profil extends StatefulWidget {
  @override
  _profilState createState() => _profilState();
}

/// Custom Font
var _txt = TextStyle(
  color: Colors.black,
  fontFamily: "Sans",
);

/// Get _txt and custom value of Variable for Name User
var _txtName = _txt.copyWith(fontWeight: FontWeight.w700, fontSize: 17.0);

/// Get _txt and custom value of Variable for Edit text
var _txtEdit = _txt.copyWith(color: Colors.black26, fontSize: 15.0);

/// Get _txt and custom value of Variable for Category Text
var _txtCategory = _txt.copyWith(
    fontSize: 14.5, color: Colors.black54, fontWeight: FontWeight.w500);

class _profilState extends State<profil> {
  @override
  Widget build(BuildContext context) {
    /// Declare MediaQueryData
    MediaQueryData mediaQueryData = MediaQuery.of(context);

    /// To Sett PhotoProfile,Name and Edit Profile
    var _profile = Padding(
      padding: EdgeInsets.only(
        top: 185.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 100.0,
                width: 100.0,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2.5),
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(StaticValues.userDisplayPicture))),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  StaticValues.userName + ' ' + StaticValues.userSurname,
                  style: _txtName,
                ),
              ),
              InkWell(
                onTap: null,
                child: Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Text(
                    "Profile",
                    style: _txtEdit,
                  ),
                ),
              ),
            ],
          ),
          Container(),
        ],
      ),
    );

    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            /// Setting Header Banner
            Container(
              height: 240.0,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(StaticValues.backgroundImage),
                      fit: BoxFit.cover)),
            ),

            /// Calling _profile variable
            _profile,
            Padding(
              padding: const EdgeInsets.only(top: 360.0),
              child: Column(
                /// Setting Category List
                children: <Widget>[
                  /// Call category class

                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 85.0, right: 30.0),
                    child: Divider(
                      color: Colors.black12,
                      height: 2.0,
                    ),
                  ),

                  Padding(padding: EdgeInsets.only(bottom: 20.0)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Component category class to set list
class category extends StatelessWidget {
  @override
  String txt, image;
  GestureTapCallback tap;
  double padding;

  category({this.txt, this.image, this.tap, this.padding});

  Widget build(BuildContext context) {
    return InkWell(
      onTap: tap,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 30.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: padding),
                  child: Image.asset(
                    image,
                    height: 25.0,
                  ),
                ),
                Text(
                  txt,
                  style: _txtCategory,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
