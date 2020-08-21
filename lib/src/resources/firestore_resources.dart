import 'package:beacontcc/src/models/item.dart';
import 'package:beacontcc/src/models/items_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreResources {
  Firestore _firestore = Firestore.instance;

  /// Retorna todos os produtos cadastrados em um beacon
  Stream<QuerySnapshot> beaconPromotionsProductsList(String beaconUUID) => _firestore
      .collection("beaconPromotions")
      .document(beaconUUID)
      .collection("products")
      .snapshots();

  /// Faz o checkout do carrinho de compras e registra cada item (produto), valor total
  /// e meio de pagamento em um novo documento dentro da subcoleção 'receipts' pertencente
  /// ao atual usuário authenticado
  Future<void> checkoutShoppingCartAndMakePurchase(String userUID, List<Item> items, double totalValue, String paymentOption) {

    List<Map<String, dynamic>> itemsMap = new List<Map<String, dynamic>>();

    items.forEach((item) {
      itemsMap.add(item.toMap());
    });

    ItemsList itemsList = ItemsList(totalValue, paymentOption, itemsMap, FieldValue.serverTimestamp());

    return _firestore
        .collection('users')
        .document(userUID)
        .collection('receipts')
        .document()
        .setData(itemsList.toMap());
  }

  /// Retorna todas as comprar (recibos) feitos pelo usuário
  Stream<QuerySnapshot> purchasesList(String userUID) => _firestore
      .collection("users")
      .document(userUID)
      .collection("receipts")
      .orderBy('timestamp', descending: true)
      .snapshots();

}