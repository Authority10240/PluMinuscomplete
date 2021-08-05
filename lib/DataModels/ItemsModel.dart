class Items{
  String Description ='' ;
  int quantity =0;
  double price=0, vat =0;
  String status = 'P';

 Items();
  Map toMap(){
    Map map = Map();

    map['DESCRIPTION'] = this.Description;
    map['QUANTITY'] = this.quantity;
    map['PRICE'] = this.price;
    map['STATUS'] = this.status;
    try {
      map['VAT'] = this.vat;
    }catch(e){
      map['VAT'] = 0;
    }
    return map;
  }

  Items.fromMap(Map map){
    this.Description = map['DESCRIPTION'];
    this.quantity = map['QUANTITY'];
    this.status = map['STATUS'];
    this.price =  double.parse((map['PRICE'].toString()));
    try {
      this.vat = double.parse((map['VAT'].toString()));
    }catch(e){
      this.vat =0;
    }
  }


}

