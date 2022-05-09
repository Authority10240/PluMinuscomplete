import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:treva_shop_flutter/BackEnd/DBHelper.dart';
import 'package:treva_shop_flutter/DataModels/GROUP_INFORMATION.dart';
import 'dart:async';
import 'package:treva_shop_flutter/DataModels/Request.dart';
import 'package:treva_shop_flutter/DataModels/StaticValues.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:csv/csv.dart';
import 'package:share/share.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;




class BalanceSheet extends StatefulWidget {
  @override
  _BalanceSheetState createState() => _BalanceSheetState( year,  month, card, name , department, transaction: this.transaction);
  BalanceSheet( this.year, this.month, this.card, this.name, this.department,
      {this.transaction , this.type});
  int type;
  String year="", month="" , card = "", department="", name="" , date = "";
  bool transaction;

}

class _BalanceSheetState extends State<BalanceSheet> {


  @override
  String month ="", year="", card="",feeAmount="", department ='', name='', date="" , feeName='';
  double amount = 0.00, totalAmount = 0.00;
  double balance = 0.00, totalVat = 0.00;
  double total = 0;
  List<Request> request;
  DBHelper dbHelper = DBHelper();
  List<GROUP_INFORMATION> groups = List() ;
  DatabaseReference ref, refUser, refUser2;
  bool transaction;
  var pdf = pw.Document();
  Widget build(BuildContext context) {

    if(request == null){
      request = List();
      updateListView();


      WidgetsBinding.instance.addPostFrameCallback((_) {
        showProgressIndicator(context);
        startTime();
      });
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,title: Text('Balance', style: TextStyle(color: Colors.grey, fontFamily: "Gotik"),),
        actions: <Widget>[
          FlatButton(onPressed: (){
            FileFormat();
          }, child: Icon(Icons.file_download, color: Colors.grey,))
        ],
       // leading: FlatButton(child: Icon(Icons.arrow_back, color: Colors.grey,),),
      ),


      body: ListView(children: <Widget>[

        Container
      (
    child: Column(
    children: <Widget>[
    Row(
    children: <Widget>[
    SizedBox(width: MediaQuery.of(context).size.width/16,height: 50,),
    Column(children: <Widget>[
    Center(
    child: Text('PlusMinus Petty Cash', style: TextStyle(fontFamily: "Gotik"),),
    ),
    ],),
    SizedBox(width: MediaQuery.of(context).size.width/6,),
    Column( children: <Widget>[
    Center(
    child: Text('Date : ' + DateTime.now().year.toString() + '/'
    +DateTime.now().month.toString() + '/'
    + DateTime.now().day.toString(), style: TextStyle(fontFamily: "Gotik") , ),
    )
    ],

    ),
    ],
    ),
    Row(
    children: <Widget>[
    SizedBox(width: MediaQuery.of(context).size.width/5.5,),
    Container(
    child: Center(
    child: Text('PlusMinus', style: TextStyle(fontSize: 50, fontFamily: "Gotik",
    fontWeight: FontWeight.w700),)
    ,
    ),
    ),
    ],
    ),
    Row(
    children: <Widget>[
    SizedBox(width: MediaQuery.of(context).size.width/4,),
    Container(
    child: Center(
    child: Text('Digital System Balance Enquiry'),
    ),
    ),
    ],
    ),
    SizedBox(height: MediaQuery.of(context).size.height/16,),
    Row(
    children: <Widget>[


    ],
    ),
    SizedBox(height: MediaQuery.of(context).size.height/100,),

    SizedBox(height: MediaQuery.of(context).size.height/100,),
    Row(
    children: <Widget>[
    Container( padding: EdgeInsets.only(left: 10,right: 10),
    child: Text('Account Number: ${card}', textAlign: TextAlign.left,)
    ),
    ],
    ),
    SizedBox(height: MediaQuery.of(context).size.height/100,),
    Row(
    children: <Widget>[
    Container( padding: EdgeInsets.only(left: 10,right: 10),
    child: Text('Administrator: ${StaticValues.userName[0]} ${StaticValues.userSurname}', textAlign: TextAlign.left,)
    ),
    ],
    ),
      SizedBox(height: MediaQuery.of(context).size.height/100,),
      Container(
          child: Text('Date: ${getMonthName(month)} $year')
      ),
    SizedBox(height: MediaQuery.of(context).size.height/100,),
    SizedBox(height: MediaQuery.of(context).size.height/100,),
    FlatButton(color: Colors.grey,
      child: Text('Add Amount',

        style: TextStyle(color: Colors.black),),
      onPressed: (){
      if(DateTime.now().month.toString() == month ) {
        CreateAmount(context);
      }else{
        Fluttertoast.showToast(
            msg: "Cannot add banking fee to previous month statements",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blueGrey,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
      },),
    FlatButton(color: Colors.grey,
      child: Text('Insert Bank Charge',
        style: TextStyle(color: Colors.black),),
    onPressed: (){
      if(DateTime.now().month.toString() == month) {
        CreateFee(context);
      }else{
        Fluttertoast.showToast(
            msg: "Cannot add banking charge to previous month statements",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blueGrey,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    },),

    SizedBox(height: MediaQuery.of(context).size.height/100,),
    SizedBox(height: MediaQuery.of(context).size.height/100,),
    Row(
    children: <Widget>[
    Container(width: MediaQuery.of(context).size.width-15,

    ),
    ],
    ),
      Container(padding:EdgeInsets.only(left: 10, right: 10),height: 400,child:getTableRows(), ),

    Row(
    children: <Widget>[
    Padding(padding: EdgeInsets.all(0)

    ),
    ],
    ),
    Column(
    children: <Widget>[
      Container(
        child: Center(
          child: Text('Closing Balance: R${request!= null && request.isNotEmpty
              ? request[request.length-1].AVAILABLE_BALANCE
              : 0.00}.', style: TextStyle(fontWeight: FontWeight.bold),),
        ),
      ),
    SizedBox(height: 5,),


    ],
    )
    ],
    ) ,

      ),],)
    );

  }

  addBankingFee(Request req){
    if(DateTime.now().month.toString() == month) {
      DatabaseReference refFee = FirebaseDatabase.instance.reference().child(
          "THIS_COMPANY").child("STATEMENTS").child(
          StaticValues.splitEmailForFirebase(StaticValues.employeeNumber))
          .child(year).child(month).child('${card}_${department}_${name}');
      refFee.child(getDateTime()+req.Title).set(req.toMap());
      setState(() {
      });
    }else{
      Fluttertoast.showToast(
          msg: "Cannot add banking fee to previous statements",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueGrey,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  Widget textFormField(String name, int pos, TextInputType type, int length){
    return   Padding(
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
            hintColor: Colors.grey,
          ),
          child: TextField(
            decoration: InputDecoration(
                border: InputBorder.none,
                label: Text(name),
                labelStyle: TextStyle(
                    fontSize: 15.0,
                    letterSpacing: 0.3,
                    color: Colors.black38,
                    fontWeight: FontWeight.w600)),
            onChanged: (value){
              switch(pos){
                case 1 : feeAmount = value;
                break;
                case 2 : date = value;
                break;
                case 3: feeName = value;
                break;
              }

            },
          ),
        ),
      ),

    );
  }
  CreateAmount(BuildContext context) {
    String amount='' ;
    return showDialog(

        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(

            title: Text('Add Amount.',),
            elevation: 7.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Enter Deposit Details'),
                  SizedBox(height: 5,),
                  textFormField('Reference', 3,TextInputType.text,9),
                  SizedBox(height: 10),
                  textFormField('Amount', 1,TextInputType.number,9),
                  SizedBox(height: 10),
                  textFormField('Date', 2, TextInputType.number,2),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Add Amount', style: TextStyle(color: Colors.black)),
                onPressed: () {

                    Request req = Request();
                    req.TRANSACTION_TYPE = 'A';
                    req.AVAILABLE_BALANCE = totalAmount.toStringAsFixed(2);
                    req.REQUESTED_AMOUNT = totalAmount.toStringAsFixed(2);
                    req.GROUP_ADMIN = StaticValues.employeeNumber;
                    req.REQUESTER = "BANK";
                    req.ACTUAL_AMOUNT_DATE = getAdditionDate();
                    req.Title = feeName;
                    req.ACTUAL_AMOUNT = feeAmount;
                    req.date = getDate();
                    addBankingFee(req);
                    Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('Cancel', style: TextStyle(color: Colors.black)),
                onPressed: () {

                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
    );
  }

  startTime() async {
    return new Timer(Duration(milliseconds: 2500), checkGroupList);
  }

  checkGroupList(){
    Navigator.pop(context);
  }



  showProgressIndicator(BuildContext context){
    return showDialog(context: context, barrierDismissible: false, builder: (BuildContext contect){
      return Container(width: 50 , child: Column(children: <Widget>[
        SizedBox(height: MediaQuery.of(context).size.height/2,),
        CircularProgressIndicator(),

      ],),);
    });
  }

  CreateFee(BuildContext context) {
    String amount='' ;
    return showDialog(

        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(

            title: Text('Add Banking Fee.',),
            elevation: 7.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Enter Fee Name'),

                  SizedBox(height: 5,),
                  textFormField('Reference', 3,TextInputType.text,9),
                  SizedBox(height: 10,),
                  textFormField('Amount', 1,TextInputType.number,9),
                  SizedBox(height: 10,),
                  textFormField('Day', 2,TextInputType.number,9),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Add Fee', style: TextStyle(color: Colors.black)),
                onPressed: () {
                  Request req = Request();
                  req.TRANSACTION_TYPE = 'F';
                  req.AVAILABLE_BALANCE = totalAmount.toStringAsFixed(2);
                  req.REQUESTED_AMOUNT = totalAmount.toStringAsFixed(2);
                  req.GROUP_ADMIN = StaticValues.employeeNumber;
                  req.REQUESTER ="BANK";
                  req.ACTUAL_AMOUNT_DATE = getAdditionDate();
                  req.Title = feeName;
                  req.ACTUAL_AMOUNT = feeAmount;
                  req.date = getDate();
                  addBankingFee(req);
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('Cancel', style: TextStyle(color: Colors.black)),
                onPressed: () {

                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
    );
  }

  String getDate(){
    return DateTime.now().year.toString()+'/'+
        DateTime.now().month.toString()+'/'+ DateTime.now().day.toString() ;
  }
   List<DropdownMenuItem<String>> getListItems(){
    List<DropdownMenuItem<String>> datalist = new List<DropdownMenuItem<String>>();
    datalist[1] = new DropdownMenuItem(value: "All",);
    datalist[2] = new DropdownMenuItem(value: "Reconsiled");
    datalist[3] = new DropdownMenuItem(value: "Unreconsiled");

    return datalist;
  }
ListView getTableRows(){

      double totalToShow = 0.00,
          balanceToShow = 0.00,
      amount = 0.00;
      totalVat = 0.00;
      totalAmount = 0.00;
      total = 0.00;
    return ListView.builder(
        padding: EdgeInsets.all(5),
        itemCount: request.length,
        itemBuilder: (BuildContext context, int index ){
          int reverseIndex = index;

          if(request[reverseIndex].TRANSACTION_TYPE == "A") {
            amount = double.parse(request[reverseIndex].ACTUAL_AMOUNT);
          }else if(request[reverseIndex].TRANSACTION_TYPE == "F") {
            amount = double.parse(request[reverseIndex].ACTUAL_AMOUNT_PAID);
          }
          if(request[reverseIndex].TRANSACTION_TYPE == "A") {
            return this.transaction == false? Card(child: ListTile(
              title: Text("Transaction:${request[reverseIndex].Title}",
                style: TextStyle(fontSize: 12),),
              trailing: Text("Date:${request[reverseIndex].date} \n"
                  "Available amount: R${request[reverseIndex].AVAILABLE_BALANCE}",
                  style: TextStyle(fontSize: 12)),
              subtitle: Text("R${amount}0", style: TextStyle(fontSize: 12)),
            )): Card(child: ListTile(
              leading: Text("Date \n${request[reverseIndex].date}"),
              title: Text("Transaction \n${request[reverseIndex].Title}"),
              trailing: FlatButton( onPressed: ()=> downloadFile(request[reverseIndex].proofOfPaynent,
                  "${request[reverseIndex].Title} - ${request[reverseIndex].date}")  ,child: Card(child:  Container(padding: EdgeInsets.all(10),child: Text("Download Reciept")),)),),
            );
          }else{

            return  this.transaction == false ? Card(child: ListTile(
              title: Text("Transaction:${request[reverseIndex].Title}",
                style: TextStyle(fontSize: 12),),
              trailing: Text("Date:${request[reverseIndex].date} \n"
                  "Available amount: R${request[reverseIndex].AVAILABLE_BALANCE}"
                  , style: TextStyle(fontSize: 12)),
              subtitle: Text("-R${amount}0", style: TextStyle(fontSize: 12)),

            )) :Card(child: ListTile(
              leading: Text("Date \n${request[reverseIndex].date}"),
              title: Text("Transaction \n${request[reverseIndex].Title}"),
              trailing: FlatButton(onPressed:()=> downloadFile(request[reverseIndex].proofOfPaynent ,
                  "${request[reverseIndex].Title} - ${request[reverseIndex].date}"
              ), child: Card(child:  Container(padding: EdgeInsets.all(10),child: Text("Download P.O.P")),)),),
            );
          }
        },);
}

downloadFile(String url, String name){
    if(url != null && url != "") {
      Share.share(url, subject: name);
    }else{
      Fluttertoast.showToast(msg: 'Transaction has no document. ');
    }

}



String getCorrectDate(Request req){

    if(req.ACTUAL_AMOUNT_DATE.isEmpty){
      return req.date;
    }else{
      return req.ACTUAL_AMOUNT_DATE;
    }

}

String minusAmount(int pos){
    totalAmount =  totalAmount - double.parse(request[pos].ACTUAL_AMOUNT);

    return totalAmount.toStringAsFixed(2);
}

  updateActualAmount(Request req){
    DatabaseReference refMain = FirebaseDatabase.instance.reference().child('THIS_COMPANY')
        .child('GROUPS').child(StaticValues.splitEmailForFirebase(req.GROUP_ADMIN)).child(name).child(department).child('BANK_MODEL');
    refMain.update({
      'ACCOUNT_BALANCE': totalAmount.toStringAsFixed(2)
    });

    setState(() {

    });
  }

  FileFormat(){
     showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Choose File Format"),
            elevation: 7.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Please select file export format'),
                  Column(
                    children: <Widget>[
                      FlatButton(onPressed: (){CreateCSVFile();}, child: Text('CSV')),
                      FlatButton(onPressed: (){writeToPdf();}, child: Text('PDF')),
                      FlatButton(onPressed: (){Navigator.pop(context);}, child: Text('Cancel'))
                    ],
                  )
                ],
              )),
            );


                  }

    );
}

CreateCSVFile() async{
  if(request.length > 0) {
    List<List<dynamic>> rows = List<List<dynamic>>();
    List<dynamic> row = List();

    // add the heading to the CSV
    row.add('Date');
    row.add('Transaction'); // was reference
    row.add('Amount'); // was deposit
    row.add('Balance');//was cost

    //row.add('Proof Of Purchase');
    //row.add('Requester');
    rows.add(row);
    //adding the headings
    double amount = 0.00,
        totalAmount = 0.00;
    double balance = 0.00;
    List<TableRow> tbl = List();
    for (int i = 0 ; i < request.length; i++) {
      totalAmount = 0.00;
      row = List();

        request[i].TRANSACTION_TYPE == 'A'?
          amount = double.parse(request[i].ACTUAL_AMOUNT)
        :
          amount = double.parse(request[i].ACTUAL_AMOUNT_PAID);

      row.add(request[i].date);
      row.add(request[i].Title);
      row.add(amount.toString());
      row.add(request[i].AVAILABLE_BALANCE);
    //  row.add(request[i].proofOfPurchase);
     // row.add(request[i].REQUESTER);

      rows.add(row);
    }


//store file in documents folder

    //String dir = (await getExternalStorageDirectory()).absolute.path +
      //  "/PlusMinus/Balance Sheets/";
    //File f = new File(
      //  dir + "${StaticValues.employeeNumber}_${getDateTime()}.csv");
    //f.create();
// convert rows to String and write as csv file
    String csv = const ListToCsvConverter().convert(rows);

    writeCounter(csv);
    Navigator.pop(context);
  }
}

  Future<String> get _localPath async {
    String directory = (await getExternalStorageDirectory()).absolute.path;

    return directory;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    File f = File('$path/BalanceSheets/${getFileDateString() + name }.csv');
    bool exists = f.existsSync();
    if(!exists){
      f.createSync(recursive: true);
    }
    return f;
  }
  Future<void> openFile(String file) async{
    final message = await OpenFile.open(file);

    setState(() {

    });
  }

  String getFileDateString(){
    String day = DateTime.now().day.toString();
    String month = DateTime.now().month.toString();
    String year = DateTime.now().year.toString();

    return day + month + year;
  }

  Future<String> writeCounter(String csv) async {
    final file = await _localFile;
    file.writeAsString(csv);
    // Write the file.
    openFile(file.path);
    return file.path;

  }



String getDateTime(){
    return "${DateTime.now().year}_${DateTime.now().month}_$date ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}";
}
  updateListView()async{
    groups = await dbHelper.getGroupList('');


      ref = FirebaseDatabase.instance.reference()
          .child('THIS_COMPANY').child('STATEMENTS').child(StaticValues.splitEmailForFirebase(StaticValues.employeeNumber))
          .child(year).child(month).child('${card}_${department}_${name}');
      ref.onChildAdded.listen((data){
        var req = data.snapshot.value;
        if(!request.contains(req)) {
          request.add(Request.Statement(req));
          setState(() {

          });
        }
      });


  }
  String getTotalBalance(){
total = 0;
    for(int i = 0; i < request.length;i++){
      if(request[i].GROUP_ADMIN == StaticValues.employeeNumber){
        for( int j = 0 ; j < request[i].items.length; j++){
          total = (request[i].items[j].price * request[i].items[j].quantity);
        }
      }
      setState(() {

      });
    }

    return total.toStringAsFixed(2);
  }

  _BalanceSheetState(this.year, this.month, this.card, this.name, this.department, {this.transaction });

  String getMonthName(String month){
    String newMonth = "";
    switch(month){
      case '1': newMonth = "January";
      break;
      case '2': newMonth = "February";
      break;
      case '3': newMonth = "March";
      break;
      case '4': newMonth = "April";
      break;
      case '5': newMonth = "May";
      break;
      case '6': newMonth = "June";
      break;
      case '7': newMonth = "July";
      break;
      case '8': newMonth = "August";
      break;
      case '9': newMonth = "September";
      break;
      case '10': newMonth = "October";
      break;
      case '11': newMonth = "November";
      break;
      case '12': newMonth = "December";
      break;


    }
    return newMonth;
  }

  getAdditionDate(){
    return DateTime.now().year.toString()+'/'+
        DateTime.now().month.toString()+'/'+ date;
  }

  writeToPdf() async{
    pdf = pw.Document();
    pdf.addPage(
        pw.Page( orientation: pw.PageOrientation.portrait ,build: (pw.Context context) { return pw.Column(
          children: [
            pw.Container( padding: pw.EdgeInsets.only(bottom: 20),child:
            pw.Column(
              children: [
                pw.Text('PlusMinus Petty Cash'),
                pw.Text('Date : ${getDate()}'),
              ]
            ),
            ),
            pw.Container( padding: pw.EdgeInsets.only(bottom: 20),child: pw.Column(
              children: [
                pw.Text('PlusMinus',style: pw.TextStyle(fontSize: 50)),
                pw.Text('Digital Balance Enquiry System',style: pw.TextStyle(fontSize: 20)),
              ]
            ) ),
            pw.Container(child: pw.Table(defaultColumnWidth: pw.FixedColumnWidth(250),children: [
              pw.TableRow(children: [
                pw.Container(child:pw.Text('Date', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11))),
                pw.Container(child:pw.Text('Transaction', style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 11))),
                pw.Container(child:pw.Text('Amount', style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 11))),
                pw.Container(child:pw.Text('Balance', style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 11))),
    ]),

    ])),
      pw.Container(child: pw.Table(defaultColumnWidth: pw.FixedColumnWidth(250),children: getData()))

          ]
        );}));

    savepdf();
  }

  savepdf() async{
    final path = await _localPath;
    final file = File('$path/BalanceSheets/${getFileDateString() + name }.pdf');
    await file.writeAsBytes(await pdf.save() );
    openFile(file.path);
  }

  List<pw.TableRow> getData(){
    List<pw.TableRow>  tbl = [];

    for (int i = 0  ; i < request.length; i++) {
      request[i].TRANSACTION_TYPE == 'A' ?
      amount = double.parse(request[i].ACTUAL_AMOUNT)
          :
      amount = double.parse(request[i].ACTUAL_AMOUNT_PAID);
      tbl.add(pw.TableRow(
          children: [
            pw.Text('${request[i].date}', style: pw.TextStyle(fontSize: 10)),
            pw.Text('${request[i].Title} ', style: pw.TextStyle(fontSize: 10)),

            pw.Text(
              'R' + double.parse(amount.toString())
                  .toStringAsFixed(2),
              style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold, fontSize: 10),),

            pw.Text('R${request[i].AVAILABLE_BALANCE}'),
          ]
      ));
      //add columns to table
    }
    return tbl;
  }
}
