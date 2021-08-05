import 'package:flutter/material.dart';

class order extends StatefulWidget {
  @override
  _orderState createState() => _orderState();
}

class _orderState extends State<order> {

  static var _txtCustom = TextStyle(
    color: Colors.black54,
    fontSize: 15.0,
    fontWeight: FontWeight.w500,
    fontFamily: "Gotik",
  );

  /// Create Big Circle for Data Order Not Success
  var _bigCircleNotYet = Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: Container(
      height: 20.0,
      width: 20.0,
      decoration: BoxDecoration(
        color: Colors.lightGreen,
        shape: BoxShape.circle,
      ),
    ),
  );

  /// Create Circle for Data Order Success
  var _bigCircle = Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: Container(
      height: 20.0,
      width: 20.0,
      decoration: BoxDecoration(
        color: Colors.lightGreen,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          Icons.check,
          color: Colors.white,
          size: 14.0,
        ),
      ),
    ),
  );

  /// Create Small Circle
  var _smallCircle = Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: Container(
      height: 3.0,
      width: 3.0,
      decoration: BoxDecoration(
        color: Colors.lightGreen,
        shape: BoxShape.circle,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,
        title: Text(
          "My Requests",
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20.0,
              color: Colors.grey,
              fontFamily: "Gotik"),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xFF6991C7)),
        elevation: 0.0,
      ),

    );
  }
}

/// Constructor Data Orders
class qeueuItem extends StatelessWidget {
  @override
  static var _txtCustomOrder = TextStyle(
    color: Colors.black45,
    fontSize: 13.5,
    fontWeight: FontWeight.w600,
    fontFamily: "Gotik",
  );

  String icon, txtHeader, txtInfo, time;
  double paddingValue;

  qeueuItem(
      {this.icon, this.txtHeader, this.txtInfo, this.time, this.paddingValue});

  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 13.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.asset(icon),
              Padding(
                padding: EdgeInsets.only(
                    left: 8.0,
                    right: mediaQueryData.padding.right + paddingValue),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(txtHeader, style: _txtCustomOrder),
                    Text(
                      txtInfo,
                      style: _txtCustomOrder.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 12.0,
                          color: Colors.black38),
                    ),
                  ],
                ),
              ),
              Text(
                time,
                style: _txtCustomOrder..copyWith(fontWeight: FontWeight.w400),
              )
            ],
          ),
        ],
      ),
    );
  }
}
