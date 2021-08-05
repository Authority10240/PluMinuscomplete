
import 'BankModel.dart';
import 'MemberModel.dart';
import 'GroupModel.dart';

class GROUP_INFORMATION{
  String _DEPARTMENT='' , _GROUP_NAME='', _GROUP_ADMIN ='' , _GROUP_TYPE ='', _GROUPPASSWORD= '';


  get GROUP_TYPE => _GROUP_TYPE;

  set GROUP_TYPE(value) {
    _GROUP_TYPE = value;
  }

  String get DEPARTMENT => _DEPARTMENT;

  GroupModel groupModel = GroupModel.blank();

  get GROUP_ADMIN => _GROUP_ADMIN;

  set GROUP_ADMIN(value) {
    _GROUP_ADMIN = value;
  }

  BankModel bankModel = BankModel.blank();
  MemberModel admin = MemberModel.Blank();
  MemberModel Adviser = MemberModel.Blank();


  GROUP_INFORMATION.fullGroup(this.groupModel, this.bankModel , this.admin);
  set DEPARTMENT(String value) {
    _DEPARTMENT = value;
  }

  get GROUP_NAME => _GROUP_NAME;

  set GROUP_NAME(value) {
    _GROUP_NAME = value;
  }


  Map<String,dynamic> toMap(){

    var map = Map<String, dynamic>();


    map['DEPARTMENT'] = DEPARTMENT;
    map['GROUP_NAME'] = GROUP_NAME;
    map['GROUP_ADMIN'] = GROUP_ADMIN;
    map['GROUP_TYPE'] = GROUP_TYPE;
    map['GROUP_PASSWORD'] = GROUPPASSWORD;

    return map;
  }

  GROUP_INFORMATION.fromMapObject(Map<String,dynamic> map){
    DEPARTMENT = map['DEPARTMENT'];
    GROUP_NAME = map['GROUP_NAME'];
    GROUP_ADMIN = map['GROUP_ADMIN'];
    GROUP_TYPE = map['GROUP_TYPE'];
    GROUPPASSWORD = map['GROUP_PASSWORD'];
  }

  GROUP_INFORMATION(this._DEPARTMENT, this._GROUP_NAME, this._GROUP_ADMIN, this._GROUP_TYPE);
  GROUP_INFORMATION.blank();

  get GROUPPASSWORD => _GROUPPASSWORD;

  set GROUPPASSWORD(value) {
    _GROUPPASSWORD = value;
  }
}