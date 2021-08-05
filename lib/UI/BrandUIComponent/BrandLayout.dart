import 'package:flutter/material.dart';
import 'package:treva_shop_flutter/UI/BrandUIComponent/BrandDetail.dart';
import 'package:treva_shop_flutter/ListItem/BrandDataList.dart';
import 'package:treva_shop_flutter/UI/HomeUIComponent/Search.dart';

class brand extends StatefulWidget {
  @override
  _brandState createState() => _brandState();
}

class _brandState extends State<brand> {
  @override
  Widget build(BuildContext context) {
    /// Component appbar
    var _appbar = AppBar(
      backgroundColor: Color(0xFFFFFFFF),
      elevation: 0.0,
      title: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Text(
          "Manage Transactions",
          style: TextStyle(
              fontFamily: "Gotik",
              fontSize: 20.0,
              color: Colors.grey,
              fontWeight: FontWeight.w700),
        ),
      ),

    );

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Scaffold(
        /// Calling variable appbar
          appBar: _appbar,
          body: Container(
            color: Colors.white,
            child: CustomScrollView(
              /// Create List Menu
              slivers: <Widget>[
                SliverPadding(
                  padding: EdgeInsets.only(top: 0.0),
                  sliver: SliverFixedExtentList(
                      itemExtent: 145.0,
                      delegate: SliverChildBuilderDelegate(
                        /// Calling itemCard Class for constructor card
                              (context, index) => itemCard.number(brandData[index],index),
                          childCount: brandData.length)),
                ),
              ],
            ),
          )),
    );
  }

  SelectDates(BuildContext context){
    return showDialog(context: context,
    barrierDismissible: false,
    builder: (BuildContext context){
       return AlertDialog(
          elevation: 7,
         title: Text('Select Duration'),
         content: Column(
            children: <Widget>[
                         InkWell(

                         )
            ],
         ));


    });
  }
}

/// Constructor for itemCard for List Menu
class itemCard extends StatelessWidget {
  /// Declaration and Get data from BrandDataList.dart
   Brand brand;
   int type;
  itemCard(this.brand);
  itemCard.number(this.brand,this.type);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
                pageBuilder: (_, __, ___) => new brandDetail(brand,type),
                transitionDuration: Duration(milliseconds: 600),
                transitionsBuilder:
                    (_, Animation<double> animation, __, Widget child) {
                  return Opacity(
                    opacity: animation.value,
                    child: child,
                  );
                }),
          );
        },
        child: Container(
          height: 130.0,
          width: 400.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          child: Hero(
            tag: 'hero-tag-${brand.id}',
            child: Material(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  image: DecorationImage(
                      image: AssetImage(brand.img), fit: BoxFit.cover),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFABABAB).withOpacity(0.3),
                      blurRadius: 1.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    color: Colors.black12.withOpacity(0.1),
                  ),
                  child: Center(
                    child: Text(
                      brand.name,
                      style: TextStyle(
                        color: Colors.white,

                        fontSize: 35.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
