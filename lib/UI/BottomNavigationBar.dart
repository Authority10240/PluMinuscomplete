import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:treva_shop_flutter/UI/BrandUIComponent/BrandLayout.dart';
import 'package:treva_shop_flutter/UI/CartUIComponent/CartLayout.dart';
import 'package:treva_shop_flutter/UI/HomeUIComponent/Home.dart';
import 'package:treva_shop_flutter/UI/AcountUIComponent/Profile.dart';
import 'package:treva_shop_flutter/UI/PlaceHolders/EmptyHome.dart';
import 'package:treva_shop_flutter/DataModels/StaticValues.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:treva_shop_flutter/DataModels/UserModel.dart';

class bottomNavigationBar extends StatefulWidget {
 @override
 _bottomNavigationBarState createState() => _bottomNavigationBarState(currentIndex);
 int currentIndex = 0;
 bottomNavigationBar();
 bottomNavigationBar.from( int page);
}

class _bottomNavigationBarState extends State<bottomNavigationBar> {
 int currentIndex = 0;

_bottomNavigationBarState(this.currentIndex);


 /// Set a type current number a layout class
 Widget callPage(int current)  {

  switch (current) {
   case 0:
    //return new Menu();
    return new Empty();
   case 1:
    return new brand();
   case 2:
    return new cart();
  /* case 3:
    return new profil();
    break;*/
   default:
    //return Menu();
   initValues();

      return Empty();
  }




 }

 initValues() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    StaticValues.userName = sp.getString('NAME');
    StaticValues.userSurname = sp.getString('SURNAME');
    StaticValues.Age = sp.getInt('AGE');
    StaticValues.occupation = sp.getString('OCCUPATION');
    StaticValues.employeeNumber = sp.getString('EMPLOYEE_NUMBER');
    StaticValues.pin = sp.getString('PIN');
    StaticValues.bio = sp.getBool('BIO');
 }

 /// Build BottomNavigationBar Widget
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   body: callPage(currentIndex),
   bottomNavigationBar: Theme(
       data: Theme.of(context).copyWith(
           canvasColor: Colors.white,
           textTheme: Theme.of(context).textTheme.copyWith(
               caption: TextStyle(color: Colors.black26.withOpacity(0.15)))),
       child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        fixedColor: Color(0xFF6991C7),
        onTap: (value) {
         currentIndex = value;
         setState(() {});
        },
        items: [
         BottomNavigationBarItem(
             icon: Icon(
              Icons.home,
              size: 23.0,
             ),
             title: Text(
              "Home",
              style: TextStyle( letterSpacing: 0.5),
             )),
         BottomNavigationBarItem(
             icon: Icon(Icons.autorenew),
             title: Text(
              "Transactions",
              style: TextStyle( letterSpacing: 0.5),
             )),
         BottomNavigationBarItem(
             icon: Icon(Icons.group),
             title: Text(
              "Groups",
              style: TextStyle( letterSpacing: 0.5),
             )),
       /* BottomNavigationBarItem(
             icon: Icon(Icons.account_circle),
             title: Text(
               "Account",
               style: TextStyle(fontFamily: "Berlin", letterSpacing: 0.5),
             )),*/

        ],
       )),
  );
 }

 Future<UserModel> getInformation ()async{

 }


}
