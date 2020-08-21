import 'package:cloud_firestore/cloud_firestore.dart';

class ItemsList {
  double totalValue;
  String paymentOption;
  List<Map<String, dynamic>> items;
  FieldValue timestamp;

  ItemsList(this.totalValue, this.paymentOption, this.items, this.timestamp);

  Map<String, dynamic> toMap() => {
    'totalValue': totalValue,
    'paymentOption': paymentOption,
    'items': items,
    'timestamp': timestamp,
  };
}