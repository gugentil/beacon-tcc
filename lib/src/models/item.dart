
import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  String id;
  String itemSector;
  String itemImageUrl;
  String itemName;
  double itemOriginalPrice;
  int itemDiscountPercent;
  Timestamp timestamp;
  bool isSelected = false;

  Item({this.id, this.itemSector, this.itemImageUrl, this.itemName, this.itemOriginalPrice, this.itemDiscountPercent, this.timestamp});

  Map<String, dynamic> toMap() => {
    'id': id,
    'itemImageUrl': itemImageUrl,
    'itemSector': itemSector,
    'itemName': itemName,
    'itemPrice': itemOriginalPrice,
    'itemDiscountPercent': itemDiscountPercent,
    'timestamp': timestamp
  };

  double get discountedPrice => itemOriginalPrice - (itemOriginalPrice * (itemDiscountPercent / 100));

  factory Item.fromDocument(DocumentSnapshot document) {
    return Item(
      id: document.documentID,
      itemSector: document['sector'],
      itemImageUrl: document['imgUrl'],
      itemName: document['name'],
      itemOriginalPrice: document['originalPrice'].toDouble(),
      itemDiscountPercent: document['discount'],
      timestamp: document['timestamp'] ?? Timestamp.now(),
    );
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      itemSector: json['itemSector'],
      itemImageUrl: json['itemImageUrl'],
      itemName: json['itemName'],
      itemOriginalPrice: json['itemPrice'].toDouble(),
      itemDiscountPercent: json['itemDiscountPercent'],
      timestamp: json['timestamp'] ?? Timestamp.now(),
    );
  }
}