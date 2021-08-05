import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:treva_shop_flutter/DataModels/ItemsModel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:treva_shop_flutter/UI/AcountUIComponent/MakeRequest.dart';
import 'package:treva_shop_flutter/DataModels/GROUP_INFORMATION.dart';

class CreateItem extends StatefulWidget {
  @override
  String listName;
  List<Items> items ;
  GROUP_INFORMATION gi;

  CreateItem( this.gi,this.items, this.listName);
  _CreateItemState createState() => _CreateItemState(gi,items, listName);
}

class _CreateItemState extends State<CreateItem> {

  String title = '';
  bool vatValue = false ;
  GROUP_INFORMATION gi;
  List<Items> items = [];
  String listName = '';
  Items item = Items();
  _CreateItemState( this.gi,this.items, this.listName);
  @override
  Widget build(BuildContext context) {

    return Scaffold(backgroundColor: Colors.white,
    body:ListView(
          children: <Widget>[
            Center(child:Container(padding: EdgeInsets.only(left: 30, right: 30 , bottom: 15 ,top:15 ),
              child: Text('Add Item'),),),
            Container(padding: EdgeInsets.only(left: 30, right: 30 , bottom: 15 ),
              child: Card(elevation: 4,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),child:Container(padding: EdgeInsets.all(15),child:
            TextField(maxLines: 4,
              decoration: InputDecoration.collapsed(hintText: 'Enter description here'), onChanged: (val){
                item.Description = val;
              },),),)
            ),

            textFormField('Quantity',item, 1,TextInputType.number),
            SizedBox(height: 5,),
            textFormField('Price', item,2,TextInputType.number),
            SizedBox(height: 10 ,),
            Row(children: [
              Container( margin: EdgeInsets.only(left: 15),child:
              Checkbox(activeColor: Colors.grey,value: vatValue, onChanged:  (newValue){

                if(item.price == 0.00){
                  showToast('Please add Price before adding VAT');
                }else {
                  vatValue = newValue;
                  if (newValue == true) {
                    item.vat = (item.price * item.quantity) / 15;
                  } else {
                    item.vat = 0.00;
                  }
                  setState(() {

                  });
                }
              }, ),
              ),

              Container(child:
              Text('Include VAT?', style: TextStyle(fontSize:12 ),),
              ),
            ],),
      SizedBox(height: 20,),


      Row(children:

      [ Container( margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/6), child:FlatButton(
        child: Text('Add Item', style: TextStyle(color: Colors.black)),
        onPressed: () {
          if(item.price == 0 || item.quantity ==0 || item.Description ==''){

          }else{
            if(items.contains(item)){

            }else {
              vatValue = false;
              this.items.add(item);

              setState(() {
              });
              Navigator.pop(context);
              setState(() {

              });
            }
          }
        },
      ),),
        SizedBox(width: MediaQuery.of(context).size.width/4,),
        FlatButton(
          child: Text('Cancel', style: TextStyle(color: Colors.black)),
          onPressed: () {
            vatValue = false;
            Navigator.pop(context);
            setState(() {

            });
          },
        ),]

    )]));
  }

  Widget textFormField(String name, Items item, int pos, TextInputType type){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: Container(
        height: 60.0,
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.0),
            color: Colors.white,
            boxShadow: [BoxShadow(blurRadius: 10.0, color: Colors.black12)]),
        padding:
        EdgeInsets.only(left: 20.0, right: 30.0, top: 0.0, bottom: 0.0),
        child: Theme(
          data: ThemeData(
            hintColor: Colors.transparent,
          ),
          child: TextField(

            decoration: InputDecoration(
                border: InputBorder.none,
                labelText: name,
                labelStyle: TextStyle(
                    fontSize: 15.0,
                    letterSpacing: 0.3,
                    color: Colors.black38
                    )),
            keyboardType: type,
            onChanged: (value){
              if(pos==1){
                item.quantity = int.parse(value);
              }else if(pos==3) {
                listName = value;
              }else if(pos ==2){
                item.price = double.parse(value);
              }
            },
          ),
        ),
      ),
    );
  }

  showToast(String text){
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}
