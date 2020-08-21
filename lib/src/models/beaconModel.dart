import 'package:flutter_beacon/flutter_beacon.dart';

/// Modelo para gerenciar nossos beacons. Aqui podemos atribuir um id composto
/// pelo `proximityUUID`, `major` e `minor` de cada beacon. Isso nos dá maior
/// flexibilidade ao comparar nossos beacons, ou fazer o update de suas propriedades
/// ao receber novas informações da conexão bluetooth (Como valores de txPower e
/// rssi para cáculo de distância, por exemplo).
class BeaconModel {
  String id;
  Beacon beacon; // modelo padrão do beacon proporcionado pela biblioteca flutter_beacon

  BeaconModel({this.id, this.beacon});
}