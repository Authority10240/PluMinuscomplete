import 'package:flutter/material.dart';

import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/rendering.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:share/share.dart';
import 'package:treva_shop_flutter/DataModels/GROUP_INFORMATION.dart';
import 'package:treva_shop_flutter/DataModels/GroupModel.dart';
class QRView extends StatefulWidget {
  @override

  GROUP_INFORMATION _groupModel = new GROUP_INFORMATION.blank();

  String _dataString;

  QRView(this._groupModel);
  _QRViewState createState() => _QRViewState(_groupModel);
}

class _QRViewState extends State<QRView> {
  @override
  String _dataString;
  GlobalKey _globalKey = new GlobalKey();
  GROUP_INFORMATION  _groupModel = new GROUP_INFORMATION .blank();


  _QRViewState(this._groupModel);
  Widget build(BuildContext context) {

    setQRInformation();


    
   // _captureAndSharePng();
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.grey,
      centerTitle: true,
      title: Text('Group QR Code', style: TextStyle(color: Colors.white),),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            _contentWidget(),
          ],
        ),
      ),
    );
  }

  _contentWidget() {
    final bodyHeight = MediaQuery
        .of(context)
        .size
        .height - MediaQuery
        .of(context)
        .viewInsets
        .bottom;
    return Container(
      color: const Color(0xFFFFFFFF),
      child: Column(
        children: <Widget>[
          Divider(height: 10,),
          ListTile(
            leading: CircleAvatar(backgroundColor: Colors.grey,
              child: Text(_groupModel.groupModel.groupName[0],style: TextStyle(color: Colors.white)),),
            title: Text('Group Name : ' + _groupModel.groupModel.groupName),
            subtitle: Text('Group Departmenr ' + _groupModel.groupModel.groupDepartment),
          ),
          Divider(height: 20,),

          Center(
            child: RepaintBoundary(
                key: _globalKey,
                child: QrImage(data: _groupModel.groupModel.groupName +':'+ _groupModel.groupModel.groupDepartment+':'+_groupModel.admin.memberEmployeeNumber,
                   size: 0.5 * bodyHeight,
                  )
            ),
          ),
          SizedBox(height: 20,),

        ],
      ),
    );
  }


  Future<String> generateQRCode(GroupModel gm, String Subject,
      String Grade) async {
    String QRString = '';//place Group model here for QR code
    _dataString = QRString;
    // Image img = await QrUtils.generateQR(QRString);

    return QRString;
  }


  String QRContent(){
    /*
                String Device_ID = MainScreen.cEmployeeNumber;
                String User_Department = token.nextToken();
                String User_Course = token.nextToken();
                String User_Subject = token.nextToken();
                String User_ID = token.nextToken();
                String Institution = token.nextToken(); // School name
                sSubject = User_Subject;
     */


  }



  Future setQRInformation() async {

   // _dataString = await generateQRCode(ti, Subject, Grade);

  }



 /* Future<Uint8List> _capturePng() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext
          .findRenderObject();
      ui.Image image = await boundary.toImage();
      ByteData byteData = await image.toByteData(
          format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
     // String bs64 = base64Encode(pngBytes);
    await writeCounter(pngBytes);
    }catch(e){
      print(e);
    }

  }
  createDirectory()async{
    final path = await localPath;
    final myDir = new Directory('$path/Entacom/QrCodes/'+year);
    myDir.exists().then((exists){
      exists ? print('created') : myDir.create();
       _capturePng().then((complete){

      });
    });
  }
*/

  _shareFile(String URL)async{
    final path = await localPath;


  }

 Future<String> get localPath async{
    final directory = await getExternalStorageDirectory();

    return directory.path;
 }

 /*Future<File> get localFile async {
   final path = await localPath;
   return File('$path/Entacom/QRCodes/'+year+'/' + Subject + '_' + Grade +'.png' );
 }

 Future<File> writeCounter(Uint8List counter) async{
    try {
      final file = await localFile;
      saveFileOnline(counter);
      return file.writeAsBytes(counter);
    }catch(e){
      print(e);
    }
 }

 Future <String>saveFileOnline(Uint8List pic)async{
    final file = await localFile;
    final StorageReference storageReference = FirebaseStorage().ref().child('Entacom').child('QrCodes').child(year);
    final StorageUploadTask uploadTask = storageReference.putData(pic);
    final StreamSubscription<StorageTaskEvent> streamSubscription = uploadTask.events.listen((event){
      print('EVENT ${event.type}');
    });
    var downURL = await(await uploadTask.onComplete).ref.getDownloadURL();
    String url = downURL.toString();
    Share.share('Thank you for using Entacom,\nPlease click link below to download QR code\n\n' + url);
    streamSubscription.cancel();
 }*/



  Confirm(BuildContext context,  String title,
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
                child: Text('Cancel', style: TextStyle(color: Colors.black)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('Confirm', style: TextStyle(color: Colors.black)),
                onPressed: () async {

                  Navigator.pop(context);



                },
              )
            ],
          );
        }
    );
  }

}
