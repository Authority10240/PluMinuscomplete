import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:treva_shop_flutter/DataModels/StaticValues.dart';
import 'package:image_picker/image_picker.dart';
import 'package:treva_shop_flutter/UI/BottomNavigationBar.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:treva_shop_flutter/UI/LoginOrSignup/SecurityQuestions.dart';
class ProfilePicSelector extends StatefulWidget {
  @override
  _ProfilePicSelectorState createState() => _ProfilePicSelectorState();
}

class _ProfilePicSelectorState extends State<ProfilePicSelector> {
  File _image;
  SharedPreferences pic;


  @override
  Widget build(BuildContext context) {
    LoadProfileValues();
    int height = MediaQuery
        .of(context)
        .size
        .height
        .floor();
    int width = MediaQuery
        .of(context)
        .size
        .width
        .floor();
    return Scaffold(
        appBar: AppBar(centerTitle: true,
          title: Text('Select Display Picture',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontFamily: 'Gotik'),),),
        body: ListView(
          children: <Widget>[
            SizedBox(height: 20,),
            Center(child: Text('Tap to choose a Background Picture',  style: TextStyle(
                color: Colors.black26,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                fontFamily: 'Gotik'),),),

            SizedBox(height: 20,),
            returnBackgroundImage(),
            SizedBox(height: 20,),
            Center(child: Text('Tap to choose a Profile Picture', style: TextStyle(
                color: Colors.black26,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                fontFamily: 'Gotik'),),),
            SizedBox(height: 20,),
            returnProfileImage(),

            SizedBox(height: 50,),
            Container(padding: EdgeInsets.all(25),child:FlatButton(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              onPressed: () async{
                if(StaticValues.backgroundImage.isEmpty){
                  Confirm(context, 'Background Image', 'Please select background image before we go on any further');
                }else if(StaticValues.userDisplayPicture.isEmpty){
                  Confirm(context, 'Profile Image', 'Please select Profile image before we go on any further');
                }else {
                  pic.setBool('PICTURE', true);
                  if( pic.getString('ANSWER1') == null){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (
                            BuildContext context) => new SecurityQuestions()));
                  }else {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (
                            BuildContext context) => new bottomNavigationBar()));
                  }
                }

              },
              child: Text(
                "Finish",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.0,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Gotik"),
              ),
              color: Colors.grey,),)
          ],
        )
    );
  }
  LoadProfileValues() async{
    SharedPreferences profile = await SharedPreferences.getInstance();
      StaticValues.employeeNumber = profile.getString('EMPLOYEE_NUMBER');
      StaticValues.userName = profile.getString('NAME');
      StaticValues.userSurname = profile.getString('SURNAME');
      StaticValues.occupation = profile.getString('OCCUPATION');
      StaticValues.Age = profile.getInt('AGE');
      StaticValues.email = profile.getString('EMAIL');
  }

  LoadPicture(BuildContext context, String title, String description, String type) {
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

  double _bytesTransfered(StorageTaskSnapshot snapshot){
    double res = snapshot.bytesTransferred/1;
    double res2 = snapshot.totalByteCount/1;

    return(res / res2);

  }

  
  showProgressBar(StorageTaskSnapshot snapshot){
    return showDialog(context: context,barrierDismissible: false,builder: (BuildContext context){
      return CircularProgressIndicator(value: _bytesTransfered(snapshot) );
    });
  }




  saveImageOnline(String type,File file) async{
        pic = await SharedPreferences.getInstance();
        final StorageReference storageRefrence = FirebaseStorage().ref().child(StaticValues.employeeNumber).child('PICTURES').child(type);
        final StorageUploadTask uploadTask = storageRefrence.putFile(file);
        showProgressIndicator(context);

        if (type == 'PROFILE') {
          var downURL = await(await uploadTask.onComplete).ref.getDownloadURL();
         await uploadTask.onComplete.then((data){


           String url = downURL.toString();
           pic.setString('PROFILE',url);
           Navigator.pop(context);

           setState(() {
             StaticValues.userDisplayPicture = url;

           });
         });

        }else{

          var downURL = await(await uploadTask.onComplete).ref.getDownloadURL();
          await uploadTask.onComplete.then((data){

            String url = downURL.toString();
            pic.setString('BACKGROUND',url);
            Navigator.pop(context);

            setState(() {
              StaticValues.backgroundImage = url;

            });
          });

        }



    }
   Future<File>  getCameraImage() async{
    return await ImagePicker.pickImage(source: ImageSource.camera);
   }

   Future<File> getGalleryImage() async{
    return await ImagePicker.pickImage(source: ImageSource.gallery);
   }



  Widget returnProfileImage(){
    var images;
    if(StaticValues.userDisplayPicture == '') {
      images = GestureDetector(
          child: Container(

            child: Center(
              child: Icon(
                Icons.add_a_photo, color: Colors.grey, size: 100,),
            ),
          ),
          onTap: () {
            LoadPicture(context, 'Upload Profile Image', 'Open?', 'PROFILE');
          })
      ;

    }else{
      images =  GestureDetector(
          child: Container(

            child: Center(
                child: Container(child: CircleAvatar(radius: 100,backgroundColor: Colors.transparent,child: Image.network(StaticValues.userDisplayPicture,loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress ){
                  if(loadingProgress == null)
                    return child;
                  return Center(child:CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                    value: loadingProgress.expectedTotalBytes != null ?
                    loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                        :null,
                  ));
                },),),)),
          ),
          onTap: () {
            LoadPicture(context, 'Upload Profile Image', 'Open?', 'PROFILE');
          });
    }

    return images;
  }

  Widget returnBackgroundImage(){
    var images;
    if(StaticValues.backgroundImage == '') {
      images = GestureDetector(
          child: Container(

            child: Center(
              child: Icon(
                Icons.add_a_photo, color: Colors.grey, size: 100,),
            ),
          ),
          onTap: () {
            LoadPicture(context, 'Upload Profile Image', 'Open?', 'BACKGROUND');

          })
      ;

    }else{
      images =  GestureDetector(
          child: Container(

            child: Center(
                child: Container(child: CircleAvatar(radius: 100,backgroundColor: Colors.transparent,child: Image.network(StaticValues.backgroundImage,loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress ){
                  if(loadingProgress == null)
                    return child;
                  return Center(child:CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                    value: loadingProgress.expectedTotalBytes != null ?
                    loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                        :null,
                  ));
                },),),)),
          ),
          onTap: () {
            LoadPicture(context, 'Upload Profile Image', 'Open?', 'BACKGROUND');
          });
    }

    return images;
  }

  showProgressIndicator(BuildContext context){
    return showDialog(context: context, barrierDismissible: false, builder: (BuildContext contect){
      return Container(width: 50 , child: Column(children: <Widget>[
        SizedBox(height: MediaQuery.of(context).size.height/2,),
        CircularProgressIndicator(),

      ],),);
    });
  }

  Confirm(BuildContext context, String title,
      String description) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(

            title: Text(title,),
            elevation: 7.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(description),

                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok', style: TextStyle(color: Colors.black)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),

            ],
          );
        }
    );
  }







}





class buttonCustomFacebook extends StatelessWidget {
  String title;
  IconData icon;
  buttonCustomFacebook(this.title ,  this.icon);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Container(
        alignment: FractionalOffset.center,
        height: 49.0,
        width: 500.0,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(40.0),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 15.0)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Icon(icon),
            Padding(padding: EdgeInsets.symmetric(horizontal: 7.0)),
            Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Gotik'),
            ),
          ],
        ),
      ),
    );
  }

}
