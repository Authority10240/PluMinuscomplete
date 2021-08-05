

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:treva_shop_flutter/DataModels/StaticValues.dart';
import 'package:local_auth/local_auth.dart';
import 'package:treva_shop_flutter/UI/AcountUIComponent/Profile.dart';
import 'package:treva_shop_flutter/UI/HomeUIComponent/BalanceYear.dart';
import 'package:treva_shop_flutter/UI/HomeUIComponent/Help.dart';
import 'package:treva_shop_flutter/UI/HomeUIComponent/HelpPages.dart';
import 'package:treva_shop_flutter/UI/HomeUIComponent/Requests.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:treva_shop_flutter/UI/HomeUIComponent/AboutPage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:treva_shop_flutter/UI/HomeUIComponent/SettingsPage.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

class Empty extends StatefulWidget{
  @override
  _EmptyState createState() => _EmptyState();



}

class _EmptyState extends State<Empty> with TickerProviderStateMixin {
  @override
  int count = 0;
  int pcount = 0;
  SharedPreferences pic;
  String pin = '';
  bool locked = false;


  Widget build(BuildContext context) {
    // TODO: implement build
    checkConnection(context);
    LoadProfileValues();
    if (pcount == 0){
      startTime();
      pcount++;
    }

    return
    Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('Home',style: TextStyle(
            fontFamily: "Gotik",
            fontSize: 20.0,
            color: Colors.grey,
            fontWeight: FontWeight.w700),),

      ),

      drawer:
          ListView(
            padding: EdgeInsets.all(10),
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height / 5,),
              GestureDetector(
                  onTap: () async{
                    //insert code for biometrics and facial ID
                    var localAuth = LocalAuthentication();
                    List<BiometricType> availableBiometrics =
                        await localAuth.getAvailableBiometrics();
                  if(StaticValues.bio == true) {
                    if (Platform.isIOS) {
                      if (availableBiometrics.contains(
                          BiometricType.fingerprint)) {
                        // Touch ID.
                        bool didAuthenticate =
                        await localAuth.authenticateWithBiometrics(
                            localizedReason: 'Please authenticate to show account balance',
                            useErrorDialogs: false);
                        if (await didAuthenticate) {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => new BalanceYear(),),);
                        } else {
                          loadKeyPad(context);
                        }
                      } else {
                        //use pin code method
                        loadKeyPad(context);
                      }
                    } else if (Platform.isAndroid) {
                      if (availableBiometrics.contains(
                          BiometricType.fingerprint)) {
                        bool didAuthenticate =
                        await localAuth.authenticateWithBiometrics(
                            localizedReason: 'Please authenticate to show account balance',
                            useErrorDialogs: false);
                        if (await didAuthenticate) {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => new BalanceYear(),),);
                        } else {
                          loadKeyPad(context);
                        }
                      } else {
                        //use pin code method
                        loadKeyPad(context);
                      }
                    }
                  }else{
                    loadKeyPad(context);
                  }

                          },
              child:
              Card(
                color: Colors.white,
                child:
                Padding(padding:EdgeInsets.all(10),child:
                Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                         Icon(Icons.account_balance, color: Colors.grey,size:40),
                      ],
                    ),
                    SizedBox(width: 5.0,),



                            SizedBox(height: 2.5,),
                            Text('Balances',style: TextStyle(
                                color: Colors.grey,
                                fontSize: 20,

                                letterSpacing: 0.5), ),
                          ],
                        )
                ),
              ),
            ),
            GestureDetector(
             onTap:(){ Navigator.push(context, MaterialPageRoute(builder: (context) => new RequestPage() ,),);
              },
              child:
              Card(

                color: Colors.white,
                child:

                Padding(padding:EdgeInsets.all(10),child:
                Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[

                        Icon(Icons.record_voice_over, color: Colors.grey,size:40,),



                      ],
                    ),
                    SizedBox(width: 5.0,),
                    Column(

                      children: <Widget>[
                        SizedBox(height: 2.5,),
                        Text('Requests',style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,

                            letterSpacing: 0.5), ),
                      ],
                    )
                  ],
                ),
                ),
              ),
              ),
              GestureDetector(child: Card(

                color: Colors.white,
                child:
                Padding(padding:EdgeInsets.all(10),child:
                Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Icon(Icons.settings, color: Colors.grey,
                          size: 40,),
                      ],
                    ),
                    SizedBox(width: 5.0,),
                    Column(

                      children: <Widget>[
                        SizedBox(height: 2.5,),
                        Text('Settings',style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,

                            letterSpacing: 0.5),),
                      ],
                    )
                  ],
                ),
                ),
              ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => new SettingsPage() ,),);
                },),
GestureDetector(child: Card(

  color: Colors.white,
  child:
  Padding(padding:EdgeInsets.all(10),child:
  Row(
    children: <Widget>[
      Column(
        children: <Widget>[
          Icon(Icons.notification_important, color: Colors.grey,
            size: 40,),
        ],
      ),
      SizedBox(width: 5.0,),
      Column(

        children: <Widget>[
          SizedBox(height: 2.5,),
          Text('About',style: TextStyle(
              color: Colors.grey,
              fontSize: 20,

              letterSpacing: 0.5),),
        ],
      )
    ],
  ),
  ),
),
    onTap: (){
      Navigator.push(context, MaterialPageRoute(builder: (context) => new AboutPage() ,),);
    },),
              GestureDetector(child: Card(

                color: Colors.white,
                child:
                Padding(padding:EdgeInsets.all(10),child:
                Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Icon(Icons.help, color: Colors.grey,
                          size: 40,),
                      ],
                    ),
                    SizedBox(width: 5.0,),
                    Column(

                      children: <Widget>[
                        SizedBox(height: 2.5,),
                        Text('Help',style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,

                            letterSpacing: 0.5),),
                      ],
                    )
                  ],
                ),
                ),
              ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => new HelpPage() ,),);
                },),

            ],
          ),

        body:

            Container(
              color: Colors.white,
              child:
                  ListView(
                    children: <Widget>[
                  GestureDetector(
                    child:Container(
                      height: MediaQuery.of(context).size.height / 3.4,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(StaticValues.backgroundImage),
                              fit: BoxFit.cover)),
                    ),
                    onDoubleTap: (){
                      loadPicture(context, 'Change Background Picture?', 'Open?', 'BACKGROUND');
                    },
                  ),
                  ///////////////////////////////////////////////////////////////////////////////////////////////
                Padding(
                  padding:  EdgeInsets.only(top: 20.0, ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(

                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(child:Container(
                            height: 100.0,
                            width: 100.0,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white, width: 5),
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: NetworkImage(StaticValues.userDisplayPicture ))),
                          ),onDoubleTap: (){
                            loadPicture(context,'Change Profile Picture?','Open?','PROFILE');
                          }, ),
                          Text('Double tap images to change pictures', style: TextStyle(color: Colors.grey),),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                              StaticValues.userName + ' ' + StaticValues.userSurname,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 30,

                                  letterSpacing: 0.5
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: null,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 0.0),
                              child: Text(
                                StaticValues.occupation,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 20,

                                    letterSpacing: 0.5
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: null,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 0.0),
                              child: Text(
                                StaticValues.employeeNumber,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,

                                    letterSpacing: 0.5
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                      Container(

                      ),
                    ],
                  ),
                ),
  ]  ),

            ),


    );
  }



  LoadProfileValues() async{
    SharedPreferences profile = await SharedPreferences.getInstance();

      StaticValues.userDisplayPicture = profile.getString('PROFILE');
      StaticValues.backgroundImage = profile.getString('BACKGROUND');
      StaticValues.employeeNumber = profile.getString('EMPLOYEE_NUMBER');
      StaticValues.userName = profile.getString('NAME');
      StaticValues.userSurname = profile.getString('SURNAME');
      StaticValues.occupation = profile.getString('OCCUPATION');
      StaticValues.Age = profile.getInt('AGE');
      StaticValues.pin = profile.getString('PIN');
      StaticValues.answer1 = profile.getString('ANSWER1');
      StaticValues.answer2 = profile.getString('ANSWER2');
      StaticValues.answer3 = profile.getString('ANSWER3');

  }
  startTime() async {
    return new Timer(Duration(milliseconds: 500), checkGroupList);
  }




  checkGroupList(){

    setState(() {

    });
  }

loadKeyPad(BuildContext context){
    return showDialog(context: context, barrierDismissible:true, builder: (BuildContext context){
      return AlertDialog(
        title: Text('Enter Pin'),
        content: TextField(obscureText: true,keyboardType: TextInputType.number, maxLength: 5, onChanged: (value){
           pin = value;
        },),
        actions: [
          FlatButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('Cancel')),
          FlatButton(onPressed: (){
            SharedPreferences.getInstance().then((value)  {
              if(value.getString("PIN") == pin){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => new BalanceYear() ,),);
              }else{
                Fluttertoast.showToast(msg: 'Invalid Pin, Please check your pin and try again');
              }
            });
          }, child: Text('Submit')),
        ],
         );
    });
}
lockpin(){

}

  loadPicture(BuildContext context, String title, String description, String type) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(description),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Column(
                  children: <Widget>[
                    Icon(Icons.image, color: Colors.grey, size: 50,),
                    Text('Pictures', style: TextStyle(color: Colors.grey),),

                  ],
                ),
                onPressed: () {
                  getGalleryImage().then((file){
                    saveImageOnline(type, file);
                  });
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Column(
                  children: <Widget>[
                    Icon(Icons.camera, color: Colors.grey, size: 50,),
                    Text('Camera', style: TextStyle(color: Colors.grey),),
                  ],
                ),
                onPressed: () async {
                  getCameraImage().then((file){
                    saveImageOnline(type, file);
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
    );
  }

  saveImageOnline(String type,File file) async{
    pic = await SharedPreferences.getInstance();
    final StorageReference storageRefrence = FirebaseStorage().ref().child(StaticValues.employeeNumber).child('PICTURES').child(type);
    final StorageUploadTask uploadTask = storageRefrence.putFile(file);

    if (type == 'PROFILE') {
      var downURL = await(await uploadTask.onComplete).ref.getDownloadURL();
      String url = downURL.toString();
      pic.setString('PROFILE',url);


      setState(() {
        StaticValues.userDisplayPicture = url;
      });

    }else{
      var downURL = await(await uploadTask.onComplete).ref.getDownloadURL();
      String url = downURL.toString();
      pic.setString('BACKGROUND',url);


      setState(() {
        StaticValues.backgroundImage = url;
      });
    }



  }
  Future<File>  getCameraImage() async{
    return await ImagePicker.pickImage(source: ImageSource.camera);
  }

  Future<File> getGalleryImage() async{
    return await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  checkConnection(BuildContext context)async{
    bool result = await DataConnectionChecker().hasConnection;
    if(result == true) {

    } else {
      showDialog(context: context, builder: (context) {
        return AlertDialog(content: Text('You have no data connection, System functionality will be limited.'),
          title: Text('No Internet Connection'),
          actions: [],);
      });

      }
      print(DataConnectionChecker().lastTryResults);
    }
  }

