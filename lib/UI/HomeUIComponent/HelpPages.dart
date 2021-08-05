import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:treva_shop_flutter/UI/BottomNavigationBar.dart';
import 'package:treva_shop_flutter/UI/PlaceHolders/EmptyHome.dart';

class Help extends StatefulWidget {
  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> {
  int page = 1;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(backgroundColor: Colors.white,
    appBar: AppBar(
      title: Text('Help',
        style: _fontDescriptionStyle,),
      centerTitle: true,
      backgroundColor: Colors.white,)
      ,body:getPage() , floatingActionButton: Container(margin: EdgeInsets.only(left: 40),height: 65,decoration: BoxDecoration(gradient:LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color.fromRGBO(125, 125, 125, 100),
          const Color.fromRGBO(125, 125, 125, 100),
        ],),
        borderRadius: BorderRadius.circular(100),
      ),child: Row(
        children: [

          GestureDetector(onTap: (){
            setState(() {
              page  = 1;
            });
          },
            child:Container(padding: EdgeInsets.only(left: size.width/16),child:Icon( Icons.looks_one_rounded,color: getColor(1),)),),
          GestureDetector(onTap: (){
            setState(() {
              page  = 2;
            });
          },
            child: Container(padding: EdgeInsets.only(left:  size.width/16),child:Icon(Icons.looks_two_rounded,color: getColor(2))),),
          GestureDetector(onTap: (){
            setState(() {
              page  = 3;
            });
          },child:Container(padding: EdgeInsets.only(left:  size.width/16),child: Icon(Icons.looks_3_rounded,color: getColor(3)),),),
          GestureDetector(onTap: (){
            setState(() {
              page  = 4;
            });
          },
            child:Container(padding: EdgeInsets.only(left:  size.width/16),child:Icon(Icons.looks_4_rounded,color: getColor(4))),),
          GestureDetector(onTap: (){
            setState(() {
              page  = 5;
            });
          },
            child: Container(padding: EdgeInsets.only(left:  size.width/16),child:Icon(Icons.looks_5_rounded,color: getColor(5))),),
          GestureDetector(onTap: (){
            setState(() {
              page  = 6;
            });
          },child:Container(padding: EdgeInsets.only(left:  size.width/16),child: Icon(Icons.looks_6_rounded,color: getColor(6)),),),
          GestureDetector(onTap: (){
            setState(() {
              page  = 7;
            });
          },
            child:Container(padding: EdgeInsets.only(left:  size.width/16),child:Text('End',style: TextStyle(color: getColor(7)),)),),

        ],
      ),),);
  }

  Widget getPage(){
    var currPage;
    switch(page){
      case 1: currPage = page1();
      break;
      case 2: currPage = page2();
      break;
      case 3: currPage = page3();
      break;
      case 4: currPage = page4();
      break;
      case 5: currPage = page5();
      break;
      case 6: currPage = page6();
      break;
      case 7: currPage = page7();
      break;

    }

    return currPage;
  }

  Widget page1(){
    return ListView(
      children: [
        Container(child: ListTile(title:Text('Step 1:',style: TextStyle(fontFamily: "Gotik",color: Colors.white,fontSize: 35),textAlign: TextAlign.center,),),margin: EdgeInsets.all(20), decoration: BoxDecoration(gradient:LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color.fromRGBO(150, 150, 150, 100),
            const Color.fromRGBO(100, 100, 100, 100),
          ],),
          borderRadius: BorderRadius.circular(100),
        ),),
        Container(padding: EdgeInsets.only(left: 20 ,right:20),
          child:Card(shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(10)),child: Container(padding: EdgeInsets.all(25),child:Text('On the HOME tab, click on the right hand icon which displays “Groups”. Depending '
    'on whether you have been designated as a group admin or a group member, you will be '
   'requested to “Create Group” or “Join Group”:',style: _fontTextStyle,),),),),
    Container(decoration:BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),padding: EdgeInsets.only(bottom: 10,left: 20,right: 20 ,top:10,),
            child:Card(child: Column(
              children: [
                Container(decoration:BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.circular(10)),padding: EdgeInsets.only(bottom: 10,left: 20,right: 20 ,top:10,),margin: EdgeInsets.only(top: 20 , left: 20,right: 20 ,bottom :10),
                  child:  Row(
                    children: <Widget>[
                      Icon(Icons.create,size: 40, color: Colors.white,),
                      Text('Create Group   ',style: TextStyle(color: Colors.white),)
                    ],
                  ),),
                Container(decoration:BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),padding: EdgeInsets.only(bottom: 10,left: 20,right: 20 ,top:10,),margin: EdgeInsets.only(  left: 20,right: 20 ,bottom :10),
                  child:

                  Text('On the HOME tab, click on the right hand icon which displays “Groups”. Depending '
                      'on whether you have been designated as a group admin or a group member, you will be '
                      'requested to “Create Group” or “Join Group”:',style: _fontTextStyle,),)

              ],
            ),)),

        Container(decoration:BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),padding: EdgeInsets.only(bottom: 10,left: 20,right: 20 ,top:10,),
            child:Card(child: Column(
              children: [
                Container(decoration:BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.circular(10)),padding: EdgeInsets.only(bottom: 10,left: 20,right: 20 ,top:10,),margin: EdgeInsets.only(top: 20 , left: 20,right: 20 ,bottom :10),
                  child:  Row(
                    children: <Widget>[
                      Icon(Icons.add,size: 40, color: Colors.white,),
                      Text('Join Group   ',style: TextStyle(color: Colors.white),)
                    ],
                  ),),
                Container(decoration:BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),padding: EdgeInsets.only(bottom: 10,left: 20,right: 20 ,top:10,),margin: EdgeInsets.only(  left: 20,right: 20 ,bottom :10),
                  child:

                  Text('This section is dedicated to employees that fall under a particular '
                    'department to join into groups that have been created.',style: _fontTextStyle,),),


              ],
            ),)),

        Container(padding: EdgeInsets.only(left: 20 ,right:20),
          child:Card(shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(10)),child: Container(padding: EdgeInsets.all(25),child:Text('Note - It is possible to be a group admin in one or multiple department(s) and a'
              ' member(s) in another department all on the app.*'
            ,style: _fontNoteStyle,),),),),

        Container(padding: EdgeInsets.only(left: 20 ,right:20),
          child:Card(shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(10)),child: Container(padding: EdgeInsets.all(25),child:Text('In order to “Create Group” the group admin will click on the mentioned icon under “Groups”'
            ' then the “Group Information” tab will display that needs to be populated with the relevant'
            ' information. Click “Next” then the next screen on display is “Banking Information”click on the'
            ' “Bank Name” a drop down list of available banks , the enter the “ Account Number” in the'
            ' space provided. Click on Finish. You will get a message that reads: “Group Creation'
           ' Successful”'
              '\n\n'
              'To “Join Group” an employee will click the “Groups” tab then click “Join Group” under the'
          '“Add Group” you will be requested to enter administrator’s email address and click on '
          ' the”Search Admin” box then once the desired group name and group department listed under '
          ' that email address appears in the search, click on “Join Group”. alternatively under the “Add '
            ' Group” click on the “Scan” a QR code will be generated that can be scanned directly from the '
            ' group administrator’s phone.'
            '\n\n'
            'Once the groups have been set up as an administrator you will be able to view the List '
    '& Requests of group members as well as the available balance which at default will be '
    'R nil (R0.00). As a group member you will be able to view List & Requests as well as '
    'Make Requests. In case the admin forgets the group password he/she is able to click '
    'on the Grey area below their email address to recover the password.'
            ,style: _fontTextStyle,),),),),

    GestureDetector(onTap: (){
      setState(() {
        page = 2;
      });
    },child:
    Container(decoration:BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.circular(10)),padding: EdgeInsets.only(bottom: 10,left: 20,right: 20 ,top:10,),margin: EdgeInsets.only(top: 10 , left: 20,right: 20 ,bottom :100),
    child:  Row(
    children: <Widget>[
      Icon(Icons.forward,size: 40, color: Colors.white,),
      Text('Next   ',style: TextStyle(color: Colors.white),)
    ],
    ),),),




        
    ],
    );

  }
  Widget page2(){
    return ListView(
      children: [
        Container(child: ListTile(title:Text('Step 2:',style: TextStyle(fontFamily: "Gotik",color: Colors.white,fontSize: 35),textAlign: TextAlign.center,),),margin: EdgeInsets.all(20), decoration: BoxDecoration(gradient:LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color.fromRGBO(150, 150, 150, 100),
            const Color.fromRGBO(100, 100, 100, 100),
          ],),
          borderRadius: BorderRadius.circular(100),
        ),),
        Container(padding: EdgeInsets.only(left: 20 ,right:20),
          child:Card(shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(10)),child: Container(padding: EdgeInsets.all(25),child:Text('Once the groups have been successfully been generated. It is the administrator’s '
    'job to ensure that funds for petty cash expenditure are requested to the the financial manager, according to the budget dedicated to that particular department.Once funds have been made '
    'available through the designated bank account dedicated for petty cash control, admin has to '
    'then go enter the amount on the PlusMinus system and upload the proof of receipt sent by '
    'financial manager/depositor onto the system. In order to do so, go to the “Home Tab” on the '
    'left hand scroll on the side to display the side menu that includes: “ Balances, Requests, About and Help”, Click on “Balances”a fingerprint authentication will pop up. Alternatively you '
    'can set up a manual pin (5 digits maximum) that will lead you to the “Statement Year” that '
    'needs to be selected, followed by the month and date.Upon reaching the screen that reads '
    '‘’Digital System Balance Enquiry”, click on ‘’Add Amount”, from there list the transaction as '
    'well as the amount displayed on the deposit slip/notice of payment from the financial manager '
    'and add it as it is. Upon returning to the “Groups” tab the Available Balance will be updated to '
    'the amount that matches the amount displayed on the bank statement for the account '
    'dedicated for petty cash purposes.',style: _fontTextStyle,),),),),

        GestureDetector(onTap: (){
          setState(() {
            page = 3;
          });
        },child:
        Container(decoration:BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.circular(10)),padding: EdgeInsets.only(bottom: 10,left: 20,right: 20 ,top:10,),margin: EdgeInsets.only(top: 10 , left: 20,right: 20 ,bottom :100),
          child:  Row(
            children: <Widget>[
              Icon(Icons.forward,size: 40, color: Colors.white,),
              Text('Next   ',style: TextStyle(color: Colors.white),)
            ],
          ),),),


      ],
    );

  }
  Widget page3(){
    return ListView(
      children: [
        Container(child: ListTile(title:Text('Step 3:',style: TextStyle(fontFamily: "Gotik",color: Colors.white,fontSize: 35),textAlign: TextAlign.center,),),margin: EdgeInsets.all(20), decoration: BoxDecoration(gradient:LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color.fromRGBO(150, 150, 150, 100),
            const Color.fromRGBO(100, 100, 100, 100),
          ],),
          borderRadius: BorderRadius.circular(100),
        ),),

        Container(padding: EdgeInsets.only(left: 20 ,right:20),
          child:Card(shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(10)),child: Container(padding: EdgeInsets.all(25),child:Text('In this next step, a group member makes a request to the group administrator for '
    'relevant petty cash related expenses for office use. Click on “Make A Request”, on the next '
    'screen noted as “Items List” this is the section whereby you enter the general name of the '
    'category of items you wish to request money to purchase for the office, upon completing '
    'that ,the next screen is listed as “Add Item” which you will be requested to enter each item '
    'and below add the quantity and ‘ projected price’ and click on add item. Repeat the process '
    'per item until the list is complete, and click on “Finished”, the request is sent to the group '
    'admin subject to approval/rejection.',style: _fontTextStyle,),),),),

        Container(padding: EdgeInsets.only(left: 20 ,right:20),
          child:Card(shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(10)),child: Container(padding: EdgeInsets.all(25),child:Text('* At this current stage we advise against using the VAT slide bar (15%), as we are still'
    'working to improve the accuracy of the VAT module during these early stages.*'
              ,style: _fontNoteStyle,),),),),

        GestureDetector(onTap: (){
          setState(() {
            page = 4;
          });
        },child:
        Container(decoration:BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.circular(10)),padding: EdgeInsets.only(bottom: 10,left: 20,right: 20 ,top:10,),margin: EdgeInsets.only(top: 10 , left: 20,right: 20 ,bottom :100),
          child:  Row(
            children: <Widget>[
              Icon(Icons.forward,size: 40, color: Colors.white,),
              Text('Next   ',style: TextStyle(color: Colors.white),)
            ],
          ),),),
      ],

    );

  }
  Widget page4(){
    return ListView(
      children: [
        Container(child: ListTile(title:Text('Step 4:',style: TextStyle(fontFamily: "Gotik",color: Colors.white,fontSize: 35),textAlign: TextAlign.center,),),margin: EdgeInsets.all(20), decoration: BoxDecoration(gradient:LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color.fromRGBO(150, 150, 150, 100),
            const Color.fromRGBO(100, 100, 100, 100),
          ],),
          borderRadius: BorderRadius.circular(100),
        ),),

        Container(padding: EdgeInsets.only(left: 20 ,right:20),
          child:Card(shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(10)),child: Container(padding: EdgeInsets.all(25),child:Text('Once the group administrator approves the request sent, the group member can '
            'then go and collect the bank card that is designated for the petty cash system. He/she then '
            'must purchase the quoted items, the take a picture of the invoice or subsequently upload the '
            'purchase invoice onto the PlusMinus system, which will then appear on the administrator’s '
            'side. This does not however substitute the practice of producing the proof of purchase '
            'to the administrator. This practice makes it merely convenient for old data to be stored '
            'whereas slips can fade away'
            ,style: _fontTextStyle,),),),),

        GestureDetector(onTap: (){
          setState(() {
            page = 5;
          });
        },child:
        Container(decoration:BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.circular(10)),padding: EdgeInsets.only(bottom: 10,left: 20,right: 20 ,top:10,),margin: EdgeInsets.only(top: 10 , left: 20,right: 20 ,bottom :100),
          child:  Row(
            children: <Widget>[
              Icon(Icons.forward,size: 40, color: Colors.white,),
              Text('Next   ',style: TextStyle(color: Colors.white),)
            ],
          ),),),
      ],
    );
  }
  Widget page5(){
    return ListView(
      children: [
        Container(child: ListTile(title:Text('Step 5:',style: TextStyle(fontFamily: "Gotik",color: Colors.white,fontSize: 35),textAlign: TextAlign.center,),),margin: EdgeInsets.all(20), decoration: BoxDecoration(gradient:LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color.fromRGBO(150, 150, 150, 100),
            const Color.fromRGBO(100, 100, 100, 100),
          ],),
          borderRadius: BorderRadius.circular(100),
        ),),

        Container(padding: EdgeInsets.only(left: 20 ,right:20),
          child:Card(shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(10)),child: Container(padding: EdgeInsets.all(25),child:Text('The group administrator then checks the received proof of payment ( invoice) and '
    'inserts the amount as an expense in the balances tab by “Adding Amount” and description '
    'which will be displayed on the Balances ( Statement) tab.'
            ,style: _fontTextStyle,),),),),
        Container(padding: EdgeInsets.only(left: 20 ,right:20),
          child:Card(shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(10)),child: Container(padding: EdgeInsets.all(25),child:Text('NB * Group Administrator must make use of the ‘ Insert bank charges’ to ensure that '
              'the system balances with the actual bank statement on a DAILY BASIS,these charges'
              'are banking charges such as : deposit fees, transaction admin fees, etc.*'
            ,style: _fontNoteStyle,),),),),

        GestureDetector(onTap: (){
          setState(() {
            page = 6;
          });
        },child:
        Container(decoration:BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.circular(10)),padding: EdgeInsets.only(bottom: 10,left: 20,right: 20 ,top:10,),margin: EdgeInsets.only(top: 10 , left: 20,right: 20 ,bottom :100),
          child:  Row(
            children: <Widget>[
              Icon(Icons.forward,size: 40, color: Colors.white,),
              Text('Next   ',style: TextStyle(color: Colors.white),)
            ],
          ),),),
      ],
    );

  }
  Widget page6(){
    return ListView(
      children: [
        Container(child: ListTile(title:Text('Step 6/7:',style: TextStyle(fontFamily: "Gotik",color: Colors.white,fontSize: 35),textAlign: TextAlign.center,),),margin: EdgeInsets.all(20), decoration: BoxDecoration(gradient:LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color.fromRGBO(150, 150, 150, 100),
            const Color.fromRGBO(100, 100, 100, 100),
          ],),
          borderRadius: BorderRadius.circular(100),
        ),),

        Container(padding: EdgeInsets.only(left: 20 ,right:20),
          child:Card(shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(10)),child: Container(padding: EdgeInsets.all(25),child:Text('Once the administrator is satisfied that the system is in balance with the bank '
    'statements at the end of the month or at the ideal date for reporting, click the download arrow '
    'on the top right hand of the screen and download the statement for the selected month '
    '( reporting runs on a monthly basis) in a format that best suits your needs. \n\n'
              'A full audit file ( statements and receipts ) can be downloaded and sent the '
    'respective financial body ( financial manager, accountants, auditors). '
            ,style: _fontTextStyle,),),),),

        GestureDetector(onTap: (){
          setState(() {
            page = 7;
          });
        },child:
        Container(decoration:BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.circular(10)),padding: EdgeInsets.only(bottom: 10,left: 20,right: 20 ,top:10,),margin: EdgeInsets.only(top: 10 , left: 20,right: 20 ,bottom :100),
          child:  Row(
            children: <Widget>[
              Icon(Icons.forward,size: 40, color: Colors.white,),
              Text('Next   ',style: TextStyle(color: Colors.white),)
            ],
          ),),),


      ],
    );
  }
  Widget page7(){
return ListView(
  children: [
    Container(child: ListTile(title:Text('Before You Go:',style: TextStyle(fontFamily: "Gotik",color: Colors.white,fontSize: 35),textAlign: TextAlign.center,),),margin: EdgeInsets.all(20), decoration: BoxDecoration(gradient:LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        const Color.fromRGBO(150, 150, 150, 100),
        const Color.fromRGBO(100, 100, 100, 100),
      ],),
      borderRadius: BorderRadius.circular(100),
    ),),
    Container(padding: EdgeInsets.only(left: 20 ,right:20),
      child:Card(shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(10)),child: Container(padding: EdgeInsets.all(25),child:Text(
        'Disclaimer: Note that the Help information is subject to change with updates and '
        'changes to the PLUSMINUS system. For any technical support, kindly email '
        'info@conceptage.co.za .'
        ,style: _fontTextStyle,),),),),

    GestureDetector(onTap: (){
      Navigator.pop(context);
    },child:
    Container(decoration:BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.circular(10)),padding: EdgeInsets.only(bottom: 10,left: 20,right: 20 ,top:10,),margin: EdgeInsets.only(top: 10 , left: 20,right: 20 ,bottom :100),
      child:  Row(
        children: <Widget>[
          Icon(Icons.forward,size: 40, color: Colors.white,),
          Text('Finish   ',style: TextStyle(color: Colors.white),)
        ],
      ),),),
  ],

);

  }

  Color getColor(int pgNum){
    Color clr = Colors.white;



    if(pgNum == page){
      clr = Colors.black12;
    }
    return clr;
  }

  var _fontDescriptionStyle = TextStyle(
      fontFamily: "Gotik",
      fontSize: 20.0,
      color: Colors.black26,
      fontWeight: FontWeight.w400

  );

  var _fontTextStyle = TextStyle(
      fontFamily: "Gotik",
      fontSize: 15.0,
      color: Colors.black26,
      fontWeight: FontWeight.w400

  );

  var _fontNoteStyle = TextStyle(
      fontFamily: "Gotik",
      fontSize: 13.0,
      color: Colors.black26,
      fontWeight: FontWeight.bold

  );
}
