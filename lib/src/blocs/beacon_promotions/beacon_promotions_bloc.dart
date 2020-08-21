
import 'package:beacontcc/src/resources/firestore_resources.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BeaconPromotionsBloc {
  final _firestoreResource = FirestoreResources();

  /// Retorna uma stream com todos os produtos registrados em um determinado beacon
  Stream<QuerySnapshot> productsListForBeaconId(String beaconUUID) => _firestoreResource.beaconPromotionsProductsList(beaconUUID);
}