import 'package:flutter/material.dart';
import 'package:treva_shop_flutter/Library/intro_views_flutter-2.4.0/lib/Models/page_view_model.dart';
import 'package:treva_shop_flutter/Library/intro_views_flutter-2.4.0/lib/intro_views_flutter.dart';
import 'package:treva_shop_flutter/UI/LoginOrSignup/Signup.dart';
import 'package:treva_shop_flutter/UI/LoginOrSignup/ChoseLoginOrSignup.dart';
import 'package:treva_shop_flutter/UI/LoginOrSignup/Signup.dart';
import 'package:treva_shop_flutter/UI/HomeUIComponent/Home.dart';

class onBoarding extends StatefulWidget {
  @override
  _onBoardingState createState() => _onBoardingState();
}

var _fontHeaderStyle = TextStyle(
  fontFamily: "Popins",
  fontSize: 21.0,
  fontWeight: FontWeight.w800,
  color: Colors.black87,
  letterSpacing: 1.5
);

var _fontDescriptionStyle = TextStyle(
  fontFamily: "Gotik",
  fontSize: 15.0,
  color: Colors.black26,
  fontWeight: FontWeight.w400
);

///
/// Page View Model for on boarding
///
final pages = [
  new PageViewModel(
      pageColor:  Colors.white,
      iconColor: Colors.green[900],
      bubbleBackgroundColor: Colors.grey,
      title: Text(
        'True Financial Accountability',style: _fontHeaderStyle,
      ),
      body: Text(
        'Digitally Integrate Your Petty Cash Accounts',textAlign: TextAlign.center,
        style: _fontDescriptionStyle
      ),
      mainImage: Image.asset(
        'assets/img/coin.jpg',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      )),

  new PageViewModel(
      pageColor:  Colors.white,
      iconColor: Colors.green[900],
      bubbleBackgroundColor: Colors.grey,
      title: Text(
        'Grouped Finances',style: _fontHeaderStyle,
      ),
      body: Text(
          'Collective Work Place Accountability',textAlign: TextAlign.center,
          style: _fontDescriptionStyle,
      ),
      mainImage: Image.asset(
        'assets/img/Keep-rec.jpg',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      )),

  new PageViewModel(
      pageColor:  Colors.white,
      iconColor: Colors.green[900],
      bubbleBackgroundColor: Colors.grey,
      title: Text(
        'One Touch Analytics',style: _fontHeaderStyle,
      ),
      body: Text(
          'Balance Your Books As Per Your Bank Statement',textAlign: TextAlign.center,
          style: _fontDescriptionStyle
      ),
      mainImage: Image.asset(
        'assets/img/mob-ana.jpg',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      )),

];

class _onBoardingState extends State<onBoarding> {
  @override
  Widget build(BuildContext context) {
    return IntroViewsFlutter(
      pages,
      pageButtonsColor: Colors.black45,
      skipText: Text("SKIP",style: _fontDescriptionStyle.copyWith(color: Colors.black,fontWeight: FontWeight.w800,letterSpacing: 1.0),),
      doneText: Text("DONE",style: _fontDescriptionStyle.copyWith(color: Colors.black,fontWeight: FontWeight.w800,letterSpacing: 1.0),),
      onTapDoneButton: (){
        Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (_,__,___)=> new Signup(),
        transitionsBuilder: (_,Animation<double> animation,__,Widget widget){
          return Opacity(
            opacity: animation.value,
            child: widget,
          );
        },
        transitionDuration: Duration(milliseconds: 1500),
        ));
      },
    );
  }
}

