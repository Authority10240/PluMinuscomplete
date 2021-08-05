class BankModel{
  String _BankName ='', _accountNumber ='', _branchCode ='',
      _cardNumber ='', _expirationDate ='', _accountCVV ='',
  _accountBalance = '0.00';

  String get BankName => _BankName;

  set BankName(String value) {
    _BankName = value;
  }

  BankModel.fromMapObject(Map<dynamic,dynamic> map){
    this.BankName = map['BANK_NAME'];
    this.branchCode = map['BRANCH_CODE'];
    this.accountNumber = map['ACCOUNT_NUMBER'];
    this.accountCVV = map['ACCOUNT_CVV'];
    this.expirationDate = map['EXPIRATION_DATE'];
    this.cardNumber = map['CARD_NUMBER'];
    this.accountBalance = map['ACCOUNT_BALANCE'];
  }

  Map<dynamic, dynamic>ToMapObject(){

    Map<dynamic,dynamic> map = Map();

    map['BANK_NAME'] = this.BankName;
    map['BRANCH_CODE'] = this.branchCode;
    map['ACCOUNT_NUMBER'] = this.accountNumber;
    map['ACCOUNT_CVV'] = this.accountCVV;
    map['EXPIRATION_DATE'] = this.expirationDate;
    map['CARD_NUMBER'] = this.cardNumber;
    map['ACCOUNT_BALANCE'] = this._accountBalance;

    return map;

  }

  BankModel(this._BankName,this._accountNumber, this._branchCode, this._cardNumber,
      this._expirationDate, this._accountCVV, this._accountBalance);

  get accountBalance => _accountBalance;

  set accountBalance(value) {
    _accountBalance = value;
  }

  BankModel.blank();

  get accountCVV => _accountCVV;

  set accountCVV(value) {
    _accountCVV = value;
  }

  get expirationDate => _expirationDate;

  set expirationDate(value) {
    _expirationDate = value;
  }

  get cardNumber => _cardNumber;

  set cardNumber(value) {
    _cardNumber = value;
  }

  get branchCode => _branchCode;

  set branchCode(value) {
    _branchCode = value;
  }

  String get accountNumber => _accountNumber;

  set accountNumber(String value) {
    _accountNumber = value;
  }


}