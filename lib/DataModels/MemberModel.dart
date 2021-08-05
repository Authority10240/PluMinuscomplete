class MemberModel{
  String _memberName ='', _memberSurname='', _memberOccupation='', _memberPictureAsset ='' ,
      _memberEmployeeNumber ='';

  MemberModel(this._memberName, this._memberSurname, this._memberOccupation,
      this._memberPictureAsset, this._memberEmployeeNumber);

  String get memberName => _memberName;

  set memberName(String value) {
    _memberName = value;
  }

  MemberModel.Blank();

  get memberSurname => _memberSurname;

  get memberEmployeeNumber => _memberEmployeeNumber;

  set memberEmployeeNumber(value) {
    _memberEmployeeNumber = value;
  }

  get memberPictureAsset => _memberPictureAsset;

  set memberPictureAsset(value) {
    _memberPictureAsset = value;
  }

  get memberOccupation => _memberOccupation;

  set memberOccupation(value) {
    _memberOccupation = value;
  }

  set memberSurname(value) {
    _memberSurname = value;
  }

  MemberModel.fromMapObjectI(Map<dynamic,dynamic> map){
    this.memberEmployeeNumber = map['MEMBER_EMPLOYEE_NUMBER'];
    this.memberName = map['MEMBER_NAME'];
    this.memberOccupation = map['MEMBER_OCCUPATION'];
    this.memberSurname = map['MEMBER_SURNAME'];
    this.memberPictureAsset = map['MEMBER_PICTURE_ASSET'];
  }

  Map<dynamic,dynamic>toMap(){

    Map<dynamic, dynamic> map = Map();
    map['MEMBER_EMPLOYEE_NUMBER'] = this.memberEmployeeNumber;
    map['MEMBER_NAME'] = this.memberName;
    map['MEMBER_SURNAME'] = this.memberSurname;
    map['MEMBER_OCCUPATION'] = this.memberOccupation;
    map['MEMBER_PICTURE_ASSET'] = this.memberPictureAsset;

    return map;
  }
}