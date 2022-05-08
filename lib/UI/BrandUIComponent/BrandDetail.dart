import 'package:flutter/material.dart';
import 'package:treva_shop_flutter/DataModels/Request.dart';
import 'package:treva_shop_flutter/DataModels/StaticValues.dart';
import 'package:treva_shop_flutter/ListItem/BrandDataList.dart';
import 'package:treva_shop_flutter/UI/BrandUIComponent/Chat.dart';
import 'package:treva_shop_flutter/UI/HomeUIComponent/Home.dart';
import 'package:treva_shop_flutter/DataModels/GroupModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:treva_shop_flutter/BackEnd/DBHelper.dart';
import 'package:treva_shop_flutter/DataModels/GROUP_INFORMATION.dart';
import 'package:share/share.dart';
import 'package:fluttertoast/fluttertoast.dart';

class brandDetail extends StatefulWidget {
  @override
  /// Get data from BrandDataList.dart (List Item)
  /// Declare class
   Brand brand;
  int type ;
  brandDetail(this.brand,this.type);
  _brandDetailState createState() => _brandDetailState(brand,type);
}

class _brandDetailState extends State<brandDetail> {
  /// set key for bottom sheet
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  List<Request> request;

  DatabaseReference refUser;
  DBHelper db_helper = DBHelper();
  List<GROUP_INFORMATION> groups, groups2;


  int type;

  /// Get data from BrandDataList.dart (List Item)
  /// Declare class
  Brand brand;

  _brandDetailState(this.brand, this.type);

  String notif = "Notifications";

  /// https://firebasestorage.googleapis.com/v0/b/beauty-look.appspot.com/o/Artboard%203.png?alt=media&token=dc7f4bf5-8f80-4f38-bb63-87aed9d59b95

  /// Custom text header for bottomSheet
  final _fontCostumSheetBotomHeader = TextStyle(

      color: Colors.black54,
      fontWeight: FontWeight.w600,
      fontSize: 16.0);

  /// Custom text for bottomSheet
  final _fontCostumSheetBotom = TextStyle(

      color: Colors.black45,
      fontWeight: FontWeight.w400,
      fontSize: 16.0);

  /// Create Modal BottomSheet (SortBy)
  void _modalBottomSheetSort() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return SingleChildScrollView(
            child: new Container(
              height: 320.0,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 20.0)),
                  Text("SORT BY", style: _fontCostumSheetBotomHeader),
                  Padding(padding: EdgeInsets.only(top: 20.0)),
                  Container(
                    width: 500.0,
                    color: Colors.black26,
                    height: 0.5,
                  ),
                  Padding(padding: EdgeInsets.only(top: 25.0)),
                  InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => new Menu()));
                      },
                      child: Text(
                        "Popularity",
                        style: _fontCostumSheetBotom,
                      )),
                  Padding(padding: EdgeInsets.only(top: 25.0)),
                  Text(
                    "New",
                    style: _fontCostumSheetBotom,
                  ),
                  Padding(padding: EdgeInsets.only(top: 25.0)),
                  Text(
                    "Discount",
                    style: _fontCostumSheetBotom,
                  ),
                  Padding(padding: EdgeInsets.only(top: 25.0)),
                  Text(
                    "Price: High-Low",
                    style: _fontCostumSheetBotom,
                  ),
                  Padding(padding: EdgeInsets.only(top: 25.0)),
                  Text(
                    "Price: Log-High",
                    style: _fontCostumSheetBotom,
                  ),
                  Padding(padding: EdgeInsets.only(top: 25.0)),
                ],
              ),
            ),
          );
        });
  }

  /// Create Modal BottomSheet (RefineBy)
  void _modalBottomSheetRefine() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return SingleChildScrollView(
            child: new Container(
              height: 320.0,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 20.0)),
                  Text("REFINE BY", style: _fontCostumSheetBotomHeader),
                  Padding(padding: EdgeInsets.only(top: 20.0)),
                  Container(
                    width: 500.0,
                    color: Colors.black26,
                    height: 0.5,
                  ),
                  Padding(padding: EdgeInsets.only(top: 25.0)),
                  InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => new Menu()));
                      },
                      child: Text(
                        "Popularity",
                        style: _fontCostumSheetBotom,
                      )),
                  Padding(padding: EdgeInsets.only(top: 25.0)),
                  Text(
                    "New",
                    style: _fontCostumSheetBotom,
                  ),
                  Padding(padding: EdgeInsets.only(top: 25.0)),
                  Text(
                    "Discount",
                    style: _fontCostumSheetBotom,
                  ),
                  Padding(padding: EdgeInsets.only(top: 25.0)),
                  Text(
                    "Price: High-Low",
                    style: _fontCostumSheetBotom,
                  ),
                  Padding(padding: EdgeInsets.only(top: 25.0)),
                  Text(
                    "Price: Log-High",
                    style: _fontCostumSheetBotom,
                  ),
                  Padding(padding: EdgeInsets.only(top: 25.0)),
                ],
              ),
            ),
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);


    if (request == null) {
      request = List();
      getGroupsFromSQL();
    }

    /// Hero animation for image
    final hero = Hero(
      tag: 'hero-tag-${brand.id}',
      child: new DecoratedBox(
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          image: new DecorationImage(
            fit: BoxFit.cover,
            image: new AssetImage(brand.img),
          ),
          shape: BoxShape.rectangle,
        ),
        child: Container(
          margin: EdgeInsets.only(top: 130.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: <Color>[
                  new Color(0x00FFFFFF),
                  new Color(0xFFFFFFFF),
                ],
                stops: [
                  0.0,
                  1.0
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(0.0, 1.0)),
          ),
        ),
      ),
    );

    return Scaffold(
      key: _key,
      body: CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: <Widget>[

          /// Appbar Custom using a SliverAppBar
          SliverAppBar(
            centerTitle: true,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            expandedHeight: 380.0,
            elevation: 0.1,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  brand.name,
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 17.0,

                      fontWeight: FontWeight.w700),
                ),
                background: Material(
                  child: hero,
                )),
          ),

          /// Container for description to Sort and Refine
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(

                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(
                          0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(
                                  10),
                              child: Text(
                                brand.desc,
                                style: TextStyle(

                                    fontWeight: FontWeight.w400,
                                    fontSize: 15.0,
                                    color: Colors.black54),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// Create Grid Item
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF656565).withOpacity(0.15),
                          blurRadius: 4.0,
                          spreadRadius: 1.0,
                        )
                      ]),
                  child: Wrap(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[

                          Padding(padding: EdgeInsets.only(top: 7.0)),
                          Padding(
                            padding:
                            const EdgeInsets.only(left: 15.0, right: 15.0),
                            child: Text(
                              request[index].GROUP_NAME,
                              style: TextStyle(
                                  letterSpacing: 0.5,
                                  color: Colors.black54,

                                  fontWeight: FontWeight.w500,
                                  fontSize: 15.0),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 1.0)),
                          Padding(
                            padding:
                            const EdgeInsets.only(left: 15.0, right: 15.0),
                            child: Text(
                              request[index].DEPARTMENT,
                              style: TextStyle(

                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.0
                              ,) ,overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 5.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[

                                Row(
                                    children: <Widget>[
                                      Container(width: MediaQuery.of(context).size.width / 2.5 , child:
                                        Text(
                                            request[index].GROUP_ADMIN,
                                            style: TextStyle(
                                                color: Colors.black26,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12.0),overflow: TextOverflow.ellipsis
                                        ),
                                      ),

                                    ]
                                ),

                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 5.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Date:",
                                      style: TextStyle(

                                          color: Colors.black26,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.0),overflow: TextOverflow.ellipsis
                                    ),

                                  ],
                                ),
                                Row(
                                    children: <Widget>[
                                      Text(
                                        request[index].date,
                                        style: TextStyle(

                                            color: Colors.black26,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12.0),overflow: TextOverflow.ellipsis
                                      ),
                                    ]
                                ),

                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 5.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Response",
                                      style: TextStyle(

                                          color: Colors.black26,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.0),
                                    ),

                                  ],
                                ),
                                Row(
                                    children: <Widget>[
                                      Text(
                                        request[index].Response,
                                        style: TextStyle(

                                            color: Colors.black26,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12.0),
                                      ),
                                    ]
                                ),

                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 5.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Status:",
                                      style: TextStyle(

                                          color: Colors.black26,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.0),
                                    ),

                                  ],
                                ),
                                Row(
                                    children: <Widget>[
                                      Text(
                                        request[index].STATUS,
                                        style: TextStyle(

                                            color: Colors.black26,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12.0),
                                      ),
                                    ]
                                ),

                              ],
                            ),
                          ),
                          Divider(height: 5,),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 5.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Total Item Count",
                                      style: TextStyle(

                                          color: Colors.black26,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.0),
                                    ),

                                  ],
                                ),
                                Row(
                                    children: <Widget>[
                                      Text(
                                        request[index].items.length.toString(),
                                        style: TextStyle(

                                            color: Colors.black26,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12.0),
                                      ),
                                    ]
                                ),


                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 5.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Total Amount:",
                                      style: TextStyle(

                                          color: Colors.black26,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.0),
                                    ),

                                  ],
                                ),
                                Row(
                                    children: <Widget>[
                                      Text(
                                        "R"+getTotalAmount(index),
                                        style: TextStyle(

                                            color: Colors.black26,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12.0),
                                      ),
                                    ]
                                ),


                              ],
                            ),
                          ),
                          Divider(height: 5,),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 5.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Center(child:Text('Download:')),
                                    SizedBox(height: 10,),
                                    InkWell(
                                      onTap: (){
                                        if(request[index].proofOfPaynent.isNotEmpty) {
                                          Share.share(
                                              request[index].proofOfPaynent,
                                              subject: 'Plus Minus: ${request[index]
                                                  .Title}\'s Proof Of Payment');
                                        }else{
                                          ShowToast("No Deposit was made for his transaction");
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 10.0),
                                        child: Container(
                                          height: 40.0,
                                          width: 150,
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Deposit Slip",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Divider(height: 5,),
                                    InkWell(
                                      onTap: (){

                                          Share.share(
                                              request[index].proofOfPurchase,
                                              subject: 'Plus Minus: ${request[index]
                                                  .Title}\'s Proof Of Purchase');

                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 10.0),
                                        child: Container(
                                          height: 40.0,
                                          width: 150.0,
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Reciept",
                                              style: TextStyle(
                                                  color: Colors.white,

                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),



                              ],
                            ),
                          ),

                        ],
                      ),
                    ],
                  ),
                );
              },
              childCount: request.length,
            ),

            /// Setting Size for Grid Item
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 250.0,
              mainAxisSpacing: 7.0,
              crossAxisSpacing: 7.0,
              childAspectRatio: 0.605,
            ),
          ),
        ],
      ),
    );
  }
  String getTotalAmount(pos){


    return request[pos].ACTUAL_AMOUNT;
  }

  getGroupsFromSQL() async {

    groups = await db_helper.getGroupList('GR');

    for (int i = 0; i < groups.length; i++) {
      updateListView(groups[i]);
    }
  }


  updateListView(GROUP_INFORMATION gi){
    if(type == 0){
      // if we are dealing with transactions going in. current users personall requests.
      refUser = FirebaseDatabase.instance.reference().child('THIS_COMPANY').child(
          'PERSONAL_REQUESTS').child(StaticValues.splitEmailForFirebase(StaticValues.employeeNumber))
          .child(gi.GROUP_NAME).child(gi.DEPARTMENT);
    }else if (type == 1){
      refUser = FirebaseDatabase.instance.reference().child('THIS_COMPANY').child(
          'GROUP_REQUESTS').child(StaticValues.splitEmailForFirebase(gi.GROUP_ADMIN))
          .child(gi.GROUP_NAME).child(gi.DEPARTMENT);
    }else{
      refUser = FirebaseDatabase.instance.reference().child('THIS_COMPANY').child(
          'GROUP_REQUESTS').child(StaticValues.splitEmailForFirebase(gi.GROUP_ADMIN))
          .child(gi.GROUP_NAME).child(gi.DEPARTMENT);
    }
      var list = [];
    refUser.onChildAdded.listen((data){
      if( type == 2){
         list = data.snapshot.value;
      }
      Request re =Request.FromMap(data.snapshot.key,list,'T');
      re.GROUP_ADMIN = gi.GROUP_ADMIN;
      re.GROUP_NAME = gi.GROUP_NAME;
      re.DEPARTMENT = gi.DEPARTMENT;
      if(!request.contains(re) && re.STATUS =="ARCHIVED"){
        request.add(re);
        setState(() {

        });
      }
    });

  }
  ShowToast(String text ){
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

/// Class For Botton Custom
class buttonCustom extends StatelessWidget {
  String txt;
  Color color;
  GestureTapCallback ontap;

  buttonCustom({this.txt, this.color, this.ontap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: 45.0,
        width: 300.0,
        decoration: BoxDecoration(
          color: color,
        ),
        child: Center(
            child: Text(
              txt,
              style: TextStyle(color: Colors.white, fontFamily: "Sans"),
            )),
      ),
    );
  }



}






