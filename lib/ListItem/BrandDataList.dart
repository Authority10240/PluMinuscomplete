class Brand {
  final String id;
  final String name;
  final String img;
  final String desc;
  final items item;

  const Brand({
    this.img,
    this.id,
    this.name,
    this.desc,
    this.item,
  });
}

class items {
  final String itemName;
  final String itemPrice;
  final String itemRatting;
  final String itemSale;
  final String itemId;
  final String itemImg;

  const items(
      {this.itemName,
        this.itemPrice,
        this.itemRatting,
        this.itemSale,
        this.itemId,
        this.itemImg});
}

List<Brand> brandData = [
  const Brand(
      name: "View receipts/payments",
      id: "1",
      img: "assets/imgBrand/transactionIn.jpg",
      desc:" List of all Deposits",
      item: items(
          itemImg: "assets/imgBrand/brandNike.jpg",
          itemId: "1",
          itemName: "Nike Sport Shoes Running Man Blue Black",
          itemPrice: "\$ 100",
          itemRatting: "4.5",
          itemSale: "200 Sale")
  ),
  // const Brand(
  //     name: "Expenditures",
  //     id: "2",
  //     img: "assets/imgBrand/transactionOut.jpg",
  //     desc:"List of all Expenditures",
  //     item: items(
  //         itemImg: "assets/imgBrand/brandApple.jpg",
  //         itemId: "1",
  //         itemName: "Mackbook Pro SSD 500 GB",
  //         itemPrice: "\$ 1500",
  //         itemRatting: "4.5",
  //         itemSale: "250 Sale")
  // ),
 ];