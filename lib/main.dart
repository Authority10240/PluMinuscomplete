import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:treva_shop_flutter/UI/BottomNavigationBar.dart';
import 'package:treva_shop_flutter/UI/LoginOrSignup/ProfilePicture.dart';
import 'package:treva_shop_flutter/UI/LoginOrSignup/SecurityQuestions.dart';
import 'package:treva_shop_flutter/UI/OnBoarding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:treva_shop_flutter/UI/LoginOrSignup/UserInformation.dart';
import 'package:treva_shop_flutter/UI/CartUIComponent/CartLayout.dart';
import 'package:local_auth/local_auth.dart';

/// Run first apps open
void main(){
  runApp(myApp());
}

/// Set orienttation
class myApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// To set orientation always portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    ///Set color status bar
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent, //or set color with: Color(0xFF0000FF)
    ));

    return new MaterialApp(
      title: "PlusMinus",
      theme: ThemeData(
          fontFamily: 'Gotik',
          brightness: Brightness.light,
          backgroundColor: Colors.black,
          primaryColorLight: Colors.grey,
          primaryColorBrightness: Brightness.dark,
          primaryColor: Colors.grey),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      /// Move splash screen to ChoseLogin Layout
      /// Routes
      routes: <String, WidgetBuilder>{
        "login": (BuildContext context) => new onBoarding(),
        "cart": (BuildContext context) => new cart()
      },
    );
  }
}

/// Component UI
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

/// Component UI
class _SplashScreenState extends State<SplashScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  @override
  /// Setting duration in splash screen
  startTime() async {
    return new Timer(Duration(milliseconds: 4500), NavigatorPage);
  }
  /// To navigate layout change
  void NavigatorPage() async {
    List<BiometricType> availableBiometrics = await auth
        .getAvailableBiometrics();
    bool authneticated = false;
   /* try{
      if (availableBiometrics.contains(BiometricType.face)) {
        authneticated = await auth.authenticateWithBiometrics(
            localizedReason: 'Scan face to unlock app',
            stickyAuth: true);
      } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
        authneticated = await auth.authenticateWithBiometrics(
            localizedReason: 'Scan fingerprint to unlock app',
            stickyAuth: true);
      } else if (availableBiometrics.contains(BiometricType.iris)) {
        authneticated = await auth.authenticateWithBiometrics(
            localizedReason: 'Scan eyes to unlock app',
            stickyAuth: true);
      } else {
        // provide a page with textfield for pin code.
      }
    } catch (e) {

    }
*/
   // if (authneticated) {
      if (await checkVirginity() == null) {
        Navigator.of(context).pushReplacementNamed("login");
      } else if (await checkCredentias == null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => new UserInformation()));
      } else if (await checkPictures() == null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => new ProfilePicSelector()));
      } else  if(await checkSecurity() == null){
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (
                BuildContext context) => new SecurityQuestions()));
      }else{

        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => new bottomNavigationBar()));
      }
   // }
  }
  /// Declare startTime to InitState
  @override
  void initState() {
    super.initState();
    startTime();
  }
  /// Code Create UI Splash Screen
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Container(
        /// Set Background image in splash screen layout (Click to open code)
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/img/fin-bal.png'), fit: BoxFit.cover)),
        child: Container(
          /// Set gradient black in image splash screen (Click to open code)
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(0, 0, 0, 0.3),
                    Color.fromRGBO(0, 0, 0, 0.4)
                  ],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter)),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 30.0),
                    ),

                    
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


}
  Future<bool> checkVirginity() async {
    bool virgin;
    SharedPreferences virginity = await SharedPreferences.getInstance();
    virgin = virginity.getBool('Virginity');
    return virgin;
  }

  Future<String> checkCredentias() async{
    SharedPreferences reg = await SharedPreferences.getInstance();
   return reg.getString('NAME');
  }

  Future<bool> checkPictures()async{
  SharedPreferences pic = await SharedPreferences.getInstance();
  return pic.getBool('PICTURE');
  }

  Future<String> checkSecurity() async{
  SharedPreferences pic = await SharedPreferences.getInstance();
  return pic.getString('ANSWER1');
  }
