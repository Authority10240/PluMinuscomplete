import 'dart:async';
import 'dart:core';
import 'package:path/path.dart';
import "package:sqflite/sqflite.dart";
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:treva_shop_flutter/DataModels/GROUP_INFORMATION.dart';

class DBHelper{


  static Database db_instance;


  Future<Database> get db async {
    if (db_instance == null) {
      db_instance = await initDB();
    }

    return db_instance;
  }
  Future<Database> initDB() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'Entacom.db');
    var db = await openDatabase(path, version: 1, onCreate: onCreateFunc);

    return db;
  }

  void onCreateFunc(Database db, int version) async {
    //child table to store different chidren
    await db.execute(
        'CREATE TABLE $GROUP_TABLE( $DEPARTMENT TEXT, '
            '$GROUP_NAME TEXT , $GROUP_ADMIN TEXT, $GROUP_TYPE TEXT, '
            '$GROUP_PASSWORD TEXT,'
            ' PRIMARY KEY($DEPARTMENT, $GROUP_NAME, $GROUP_ADMIN));');

  }

  ////Database column name
  final GROUP_TABLE = 'GROUP_TABLE';
  final DEPARTMENT = 'DEPARTMENT';
  final GROUP_NAME = 'GROUP_NAME';
  final GROUP_ADMIN = 'GROUP_ADMIN';
  final GROUP_TYPE = 'GROUP_TYPE';
  final GROUP_PASSWORD = 'GROUP_PASSWORD';


  Future <int> addNewGroup(GROUP_INFORMATION group, ) async{
    Database database = await db;

    var result =

    await database.insert(GROUP_TABLE, group.toMap());
    return result;
  }

  Future<List<Map<String, dynamic>>> getGroups(String groupType) async{
    var db_connection = await db;
    var result = await db_connection.query(GROUP_TABLE);
    return result;
  }


  Future <List<GROUP_INFORMATION>> getGroupList(String groupType)async{
    var groupMapList = await getGroups(groupType);

    List<GROUP_INFORMATION> groupList = List<GROUP_INFORMATION>();

    for(int i = 0 ; i < groupMapList.length; i++){
      groupList.add(GROUP_INFORMATION.fromMapObject(groupMapList[i]));

    }
    return groupList;
  }



}

