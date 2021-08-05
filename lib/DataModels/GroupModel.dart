import 'BankModel.dart';
import 'MemberModel.dart';
class GroupModel{
  String _groupName ='',_groupDepartment='', _groupID='', _groupOwnerID='', _group_password='', _confirmpassword, _cpassword2;

  get confirmpasswrod => _confirmpassword;

  set confirmpasswrod(value) {
    _confirmpassword = value;
  }

  get confirmpassword => _confirmpassword;

  set confirmpassword(value) {
    _confirmpassword = value;
  }

  get group_password => _group_password;

  set group_password(value) {
    _group_password = value;
  }

  MemberModel _groupAdmin , _groupAdviser;
  BankModel _bankModel;

  GroupModel(this._groupName, this._groupDepartment, this._groupAdmin,
      this._groupAdviser, this._bankModel, this._members, this._groupID,
      this._groupOwnerID, this._group_password);

  get groupID => _groupID;

  set groupID(value) {
    _groupID = value;
  }

  String get groupName => _groupName;

  set groupName(String value) {
    _groupName = value;
  }


  List<MemberModel> _members;

  GroupModel.blank(){
    this._bankModel = new BankModel.blank();
    this._groupAdmin = new MemberModel.Blank();
    this._groupAdviser = new MemberModel.Blank();
    this._members = new List();
  }

  get groupDepartment => _groupDepartment;

  set groupDepartment(value) {
    _groupDepartment = value;
  }

  List<MemberModel> get members => _members;

  set members(List<MemberModel> value) {
    _members = value;
  }

  BankModel get bankModel => _bankModel;

  set bankModel(BankModel value) {
    _bankModel = value;
  }

  get groupAdviser => _groupAdviser;

  set groupAdviser(value) {
    _groupAdviser = value;
  }

  MemberModel get groupAdmin => _groupAdmin;

  set groupAdmin(MemberModel value) {
    _groupAdmin = value;
  }

  get groupOwnerID => _groupOwnerID;

  set groupOwnerID(value) {
    _groupOwnerID = value;
  }
  GroupModel.fromMap(Map map){
  }

  Map<String,dynamic>toMap(GroupModel gm){
    Map<String, dynamic> map = new Map();

   // map['BANK_MODEL'] = gm._bankModel;
   // map = gm._groupAdmin.;
  //  map['GROUP_ADVISER'] = gm._groupAdviser;
  //  map['GROUP_MEMBERS'] = gm._members;


    //Group description Information
    map['GROUP_NAME'] = gm._groupName;
    map['GROUP_DEPARTMENT'] = gm._groupDepartment;
    map['GROUP_ID'] = gm.groupName[0] + gm.groupDepartment[0] +
        gm.groupAdmin.memberName[0] + gm.groupAdmin.memberSurname[0];
    map['GROUP_ADMIN'] = gm._groupAdmin.memberName + ' ' + gm._groupAdmin.memberSurname;
    map['GROUP_PASSWROD'] = gm.group_password;


    return map;
  }

  Map<String,dynamic> toBankMap(GroupModel gm){
    //banking details information

    Map<String, dynamic> map = new Map();

    map['BANK_NAME'] = gm._bankModel.BankName;
    map['CARD_NUMBER'] = gm._bankModel.cardNumber;
    map['EXPIRATION_DATE'] = gm._bankModel.expirationDate;
    map['ACCOUNT_CVV'] = gm._bankModel.accountCVV;
    map['ACCOUNT_NUMBER'] = gm._bankModel.accountNumber;
    map['BRANCH_CODE'] = gm._bankModel.branchCode;
    map['ACCOUNT_BALANCE'] = gm.bankModel.accountBalance;

    return map;
  }
  
  Map<String, dynamic> toAdminMap(GroupModel gm){
    Map<String, dynamic> map = new Map();

    //Group admin details
    map['MEMBER_EMPLOYEE_NUMBER'] = gm._groupAdmin.memberEmployeeNumber;
    map['MEMBER_SURNAME'] = gm._groupAdmin.memberSurname;
    map['MEMBER_NAME'] = gm._groupAdmin.memberName;
    map['MEMBER_PICTURE_ASSET'] = gm._groupAdmin.memberPictureAsset;
    map['MEMBER_OCCUPATION'] = gm._groupAdmin.memberOccupation;


    return map;
  }

  GroupModel fromMap(Map<String,dynamic> map){

    GroupModel gm = new GroupModel.blank();

    gm.groupID = map['GROUP_ID'];
    gm.groupName = map['GROUP_NAME'];
    gm.groupDepartment = map['GROUP_DEPARTMENT'];
    gm.groupAdmin = map['GROUP_ADMIN'];
    gm.group_password = map['GROUP_PASSWORD'];


  }

  Map<String,dynamic>toMapObject(){
    Map<String, dynamic> map = new Map();

    map['GROUP_ADMIN'] = this.groupAdmin ;
    map['GROUP_DEPATMENT'] = this.groupDepartment;
    map['GROUP_NAME'] = this.groupName;
    map['GROUP_ID'] = this.groupID;

    return map;
  }





  GroupModel.fromMapObject(Map<dynamic,dynamic> map){

    GroupModel gm = new GroupModel.blank();

    this.groupID = map['GROUP_ID'];
    this.groupName = map['GROUP_NAME'];
    this.groupDepartment = map['GROUP_DEPARTMENT'];
    this.group_password = map['GROUP_PASSWROD'];



  }

  get cpassword2 => _cpassword2;

  set cpassword2(value) {
    _cpassword2 = value;
  }

}


