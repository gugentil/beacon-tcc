import 'dart:math';
import 'package:beacontcc/src/models/beaconModel.dart';
import 'package:rxdart/rxdart.dart';

class BeaconsBloc {

  final _beaconsFound = BehaviorSubject<List<BeaconModel>>();
  final _beaconsDistance = BehaviorSubject<List<BeaconModel>>();

  Stream<List<BeaconModel>>  get beaconsFound => _beaconsFound.stream;
  Function(List<BeaconModel>) get changeBeaconsFound => _beaconsFound.sink.add;

  Stream<List<BeaconModel>> get beaconsDistance => _beaconsDistance.stream;
  Function(List<BeaconModel>) get changeBeaconDistance => _beaconsDistance.sink.add;

  /// Função responsável por adicionar novos beacons encontrados no range do device.
  /// Novos eventos são emitidos a cada beacon adicionado em nossas Streams, para assim
  /// adaptarmos a nossa UI de forma reativa.
  ///
  /// Aqui são utilizadas duas Streams independêntes, uma para controlar quais beacons
  /// foram encontrados, e outra para apenas atualizar suas informações, como a sua
  /// distância até o dispositivo do cliente.
  void addBeaconFound(BeaconModel beaconToAdd) {
    // Lista atual de beacons
    List<BeaconModel> currentList = _beaconsFound.value;

    // Cria uma lista vazia caso não tenhamos nenhum evento emitido
    if(currentList == null) {
      currentList = List();
    }

    // Verifica se já existe um beacon com o mesmo id
    BeaconModel foundBeacon = currentList.firstWhere((element) => element.id == beaconToAdd.id, orElse: () => null);

    if(foundBeacon == null) {
      // Se o beacon não existir, adiciona ele na lista
      currentList.add(beaconToAdd);

      // Stream responsável por controlar nossos beacons
      changeBeaconsFound(currentList);

      // Stream responsável por controlar a distância de nossos beacons
      changeBeaconDistance(currentList);
    } else {
      // Se o beacon já existe, então apenas atualizamos os seus dados.
      double previousDistance = calculateDistance(foundBeacon.beacon.txPower, foundBeacon.beacon.rssi);
      double currentDistance = calculateDistance(beaconToAdd.beacon.txPower, beaconToAdd.beacon.rssi);

      if(currentDistance.abs() > (previousDistance.abs() + 1.50) || currentDistance.abs() < (previousDistance.abs() - 1.50)) {
        // Caso a variação de distância esteja num range de mains ou menos 1.500, então realizamos o update para o usuário
        foundBeacon.beacon = beaconToAdd.beacon;
        changeBeaconDistance(currentList);
      }
    }
  }

  /// Calcula a distância entre o beacon e o device com base nos valores
  /// de txPower e rssi recebidos pela conexão bluetooth
  double calculateDistance(txPower, rssi) {
    if (rssi == 0) {
      return -1;
    }

    var ratio = rssi * 1 / txPower;
    if (ratio < 1.0) {
      return pow(ratio, 10);
    } else {
      return ((0.89976) * pow(ratio, 7.7095) + 0.111);
    }
  }

  void dispose() async {
    _beaconsFound.close();
    await _beaconsFound.drain();
    _beaconsDistance.close();
    await _beaconsDistance.drain();
  }
}