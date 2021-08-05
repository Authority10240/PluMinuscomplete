class Cards{
  String _CardNumber, _Expiry,_CVV, _name;

  Cards.display(this._CardNumber, this._name);

  get name => _name;

  set name(value) {
    _name = value;
  }

  Cards(this._CardNumber, this._Expiry, this._CVV);

  String get CardNumber => _CardNumber;

  set CardNumber(String value) {
    _CardNumber = value;
  }

  get Expiry => _Expiry;

  get CVV => _CVV;

  Cards.blank();

  set CVV(value) {
    _CVV = value;
  }

  set Expiry(value) {
    _Expiry = value;
  }
}