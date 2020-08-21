import 'dart:async';
import 'dart:io';

import 'package:beacontcc/src/blocs/beacon_promotions/beacon_promotions_bloc.dart';
import 'package:beacontcc/src/blocs/beacon_promotions/beacon_promotions_bloc_provider.dart';
import 'package:beacontcc/src/blocs/beacons/beacons_bloc.dart';
import 'package:beacontcc/src/blocs/beacons/beacons_bloc_provider.dart';
import 'package:beacontcc/src/blocs/sotore/store_bloc.dart';
import 'package:beacontcc/src/blocs/sotore/store_bloc_provider.dart';
import 'package:beacontcc/src/models/arguments/checkout_arguments.dart';
import 'package:beacontcc/src/models/beaconModel.dart';
import 'package:beacontcc/src/models/item.dart';
import 'package:beacontcc/src/ui/checkout/checkout_page.dart';
import 'package:beacontcc/src/utils/color_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:flutter_icons/flutter_icons.dart';

class PromotionsPage extends StatefulWidget {

  @override
  _PromotionsPageState createState() => _PromotionsPageState();
}

class _PromotionsPageState extends State<PromotionsPage> with WidgetsBindingObserver {

  final StreamController<BluetoothState> _btStateController = StreamController();
  StreamSubscription<BluetoothState> _streamBluetooth;

  bool authorizationStatusOk = false;
  bool locationServiceEnabled = false;
  bool bluetoothEnabled = false;

  BeaconPromotionsBloc _beaconPromotionsBloc;
  BeaconsBloc _beaconsBloc;

  StoreBloc _storeBloc;

  List<Region> beaconsRegionsToListenList = [
    Region(
        identifier: "iBeacon",
        proximityUUID: 'FDA50693-A4E2-4FB1-AFCF-C6EB07647825'
    ),
  ];

  @override
  void didChangeDependencies() {
    _storeBloc = StoreBlocProvider.of(context);
    _storeBloc.clearItems();
    _beaconPromotionsBloc = BeaconPromotionsBlocProvider.of(context);
    _beaconsBloc = BeaconsBlocProvider.of(context);
    listeningState();
    checkAllRequirements();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  listeningState() async {
    print('Listening to bluetooth state');
    _streamBluetooth = flutterBeacon
        .bluetoothStateChanged()
        .listen((BluetoothState state) async {
      _btStateController.add(state);
    });
  }

  Future<bool> checkAllRequirements() async {
    final bluetoothState = await flutterBeacon.bluetoothState;
    final bluetoothEnabled = bluetoothState == BluetoothState.stateOn;
    final authorizationStatus = await flutterBeacon.authorizationStatus;
    final authorizationStatusOk =
        authorizationStatus == AuthorizationStatus.allowed ||
            authorizationStatus == AuthorizationStatus.always;
    final locationServiceEnabled =
    await flutterBeacon.checkLocationServicesIfEnabled;

    setState(() {
      this.authorizationStatusOk = authorizationStatusOk;
      this.locationServiceEnabled = locationServiceEnabled;
      this.bluetoothEnabled = bluetoothEnabled;
    });

    if(!authorizationStatusOk || !locationServiceEnabled || !bluetoothEnabled)
      return false;
    return true;
  }

  @override
  void dispose() {
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Olá,",
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                  ),

                  StreamBuilder(
                    stream: _storeBloc.totalItems,
                    builder: (context, AsyncSnapshot<int> totalItems) {
                      return GestureDetector(
                        onTap: () {
                          if(_storeBloc.isShoppingCartEmpty()) {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("Você deve adicionar produtos para o seu carrinho",),
                              action: SnackBarAction(
                                label: 'OK',
                                onPressed: () {
                                },
                              ),
                            ));
                          } else {
                            CheckoutArguments arguments = CheckoutArguments(0, "", _storeBloc.getItemsAddedToCart());
                            Navigator.of(context).pushNamed(CheckoutPage.routeName, arguments: arguments);
                          }
                        },
                        child: Card(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    MaterialCommunityIcons.cart_arrow_down,
                                    size: 25,
                                    color: ColorUtils.ORANGE_ACCENT,
                                  ),

                                  SizedBox(width: 5,),
                                  Text(
                                    totalItems.data != null ? totalItems.data.toString() :  "0",
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: ColorUtils.ORANGE_ACCENT
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  ),
                ],
              ),
              SizedBox(height: 15,),

              Card(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Para buscar por promoções você deve ativar: ",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black45
                              ),
                            ),

                            TextSpan(
                              text: "Wifi",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  color: Colors.black87
                              ),
                            ),

                            TextSpan(
                              text: ", ",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black45
                              ),
                            ),

                            TextSpan(
                              text: "GPS",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  color: Colors.black87
                              ),
                            ),

                            TextSpan(
                              text: ", ",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black45
                              ),
                            ),

                            TextSpan(
                              text: "Bluetooth",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  color: Colors.black87
                              ),
                            ),
                          ]
                        ),
                      ),

                      SizedBox(height: 10,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                            !authorizationStatusOk ? IconButton(
                                icon: Icon(Icons.portable_wifi_off),
                                color: Colors.red,
                                onPressed: () async {
                                  bool approved = await flutterBeacon.requestAuthorization;
                                  setState(() {
                                    authorizationStatusOk = approved;
                                  });
                                }) : IconButton(
                                icon: Icon(Icons.portable_wifi_off),
                                color: Colors.green,
                                onPressed: () async {
                                }),



                          !locationServiceEnabled ? IconButton(
                                icon: Icon(Icons.location_off),
                                color: Colors.red,
                                onPressed: () async {
                                  if (Platform.isAndroid) {
                                    await flutterBeacon.openLocationSettings;
                                  }
                                }) : IconButton(
                              icon: Icon(Icons.location_on),
                              color: Colors.green,
                              onPressed: () async {
                              }),

                          StreamBuilder<BluetoothState>(
                            stream: _btStateController.stream,
                            initialData: BluetoothState.stateUnknown,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final state = snapshot.data;

                                if (state == BluetoothState.stateOn) {
                                  return IconButton(
                                    icon: Icon(Icons.bluetooth_connected),
                                    onPressed: () async {
                                    },
                                    color: Colors.green,
                                  );
                                }

                                if (state == BluetoothState.stateOff) {
                                  return IconButton(
                                    icon: Icon(Icons.bluetooth),
                                    onPressed: () async {
                                      if (Platform.isAndroid) {
                                        try {
                                          await flutterBeacon.openBluetoothSettings;
                                        } on PlatformException catch (e) {
                                          print(e);
                                        }
                                      }
                                    },
                                    color: Colors.red,
                                  );
                                }

                                return IconButton(
                                  icon: Icon(Icons.bluetooth_disabled),
                                  onPressed: () {},
                                  color: Colors.grey,
                                );
                              }

                              return SizedBox.shrink();
                            },
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),


              StreamBuilder(
                stream: flutterBeacon.bluetoothStateChanged(),
                builder: (context, AsyncSnapshot<BluetoothState> btState) {
                  switch (btState.data) {
                    case BluetoothState.stateOn:
                      return FutureBuilder(
                        future: flutterBeacon.initializeScanning,
                        builder: (context, initialized) {
                          if(initialized.hasData && initialized.data != null) {
                            flutterBeacon.ranging(beaconsRegionsToListenList).listen((rangingResult) {
                                List<Beacon> beacons = rangingResult.beacons;
                                if(beaconsRegionsToListenList.isNotEmpty || beacons.isNotEmpty) {

                                  rangingResult.beacons.forEach((beacon) {
                                    BeaconModel beaconFound = BeaconModel(
                                      id: "${beacon.minor}&${beacon.proximityUUID}&${beacon.major}",
                                      beacon: beacon
                                    );
                                    _beaconsBloc.addBeaconFound(beaconFound);
                                  });
                                }
                              });

                              return StreamBuilder(
                                stream: _beaconsBloc.beaconsFound,
                                builder: (context, AsyncSnapshot<List<BeaconModel>> beaconsFound) {
                                  if(beaconsFound.data != null && beaconsFound.data.isNotEmpty) {
                                    return Expanded(
                                      child: Container(
                                          margin: EdgeInsets.only(top: 25.0, left: 7.0),
                                          width: MediaQuery.of(context).size.width,
//                                        height: MediaQuery.of(context).size.height*.60,
                                          child:  ListView.builder(
                                            itemCount: beaconsFound.data.length,
                                            itemBuilder: (context, index) {

                                              return StreamBuilder(
                                                stream: _beaconPromotionsBloc.productsListForBeaconId(beaconsFound.data[index].id),
                                                builder: (context, AsyncSnapshot<QuerySnapshot> productsPromotions) {
                                                  if(productsPromotions.hasData && productsPromotions.connectionState != ConnectionState.waiting) {
                                                    if(productsPromotions.data.documents.length > 0) {

                                                      String sector = productsPromotions.data.documents[0]['sector'];

                                                      List<DocumentSnapshot> docs = productsPromotions.data.documents;
                                                      List<Item> items = List<Item>();

                                                      docs.forEach((doc) {
                                                        items.add(Item.fromDocument(doc));
                                                      });

                                                      return Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          StreamBuilder(
                                                            stream: _beaconsBloc.beaconsDistance,
                                                            builder: (context, AsyncSnapshot<List<BeaconModel>> beaconsDistances) {

                                                              if(!beaconsDistances.hasData || beaconsDistances.connectionState == ConnectionState.waiting)
                                                                return Container(
                                                                  width: 20,
                                                                  height: 20,
                                                                  child: CircularProgressIndicator(),
                                                                );

                                                              double distance = _beaconsBloc.calculateDistance(beaconsDistances.data[index].beacon.txPower, beaconsDistances.data[index].beacon.rssi);
                                                              return Container(
                                                                child: Text(
                                                                  sector != null ? "$sector (${distance.abs() <= 2.00 ? "No local" : "~${distance.toStringAsFixed(2)} metros"})" : "",
                                                                  style: TextStyle(
                                                                      color: Colors.white,
                                                                      fontWeight: FontWeight.bold,
                                                                      fontSize: 25
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),

                                                          Container(
                                                            padding: EdgeInsets.all(2.0),
                                                            width: MediaQuery.of(context).size.width,
                                                            height: MediaQuery.of(context).size.height*.35,
                                                            child: ListView.builder(
                                                              scrollDirection: Axis.horizontal,
                                                              itemCount: items.length,
                                                              itemBuilder: (context, index) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    showDialog(
                                                                      context: context,
                                                                      builder: (context) {
                                                                        return Dialog(
                                                                          backgroundColor: Colors.white,
                                                                          child: Padding(
                                                                            padding: EdgeInsets.all(15),
                                                                            child: Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: <Widget>[
                                                                                GestureDetector(
                                                                                  onTap: () {
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  child: Align(
                                                                                    alignment: Alignment.centerLeft,
                                                                                    child: Icon(
                                                                                      Icons.close,
                                                                                      size: 40,
                                                                                      color: Colors.black54,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                SizedBox(height: 25,),

                                                                                Container(
                                                                                  width: 220,
                                                                                  height: 140,
                                                                                  child: CachedNetworkImage(
                                                                                    imageUrl: items[index].itemImageUrl,
                                                                                    imageBuilder: (context, imageProvider) => Container(
                                                                                      decoration: BoxDecoration(
                                                                                        image: DecorationImage(
                                                                                          image: imageProvider,
                                                                                          fit: BoxFit.cover,),
                                                                                      ),
                                                                                    ),
                                                                                    placeholder: (context, url) => Align(
                                                                                      alignment: Alignment.topCenter,
                                                                                      child: SizedBox(
                                                                                        width: 180.0,
                                                                                        height: 5.0,
                                                                                        child: new LinearProgressIndicator(),
                                                                                      ),
                                                                                    ),
                                                                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                                                                  ),
                                                                                ),
                                                                                SizedBox(height: 25,),

                                                                                Padding(
                                                                                  padding: EdgeInsets.all(6.0),
                                                                                  child: Text(
                                                                                    items[index].itemName ?? "",
                                                                                    style: TextStyle(
                                                                                      color: Colors.black87,
                                                                                      fontSize: 20
                                                                                    ),
                                                                                    maxLines: 3,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                  ),
                                                                                ),

                                                                                Padding(
                                                                                  padding: EdgeInsets.all(6.0),
                                                                                  child: Text(
                                                                                    "R\$ ${items[index].itemOriginalPrice.toStringAsFixed(2) ?? ""}",
                                                                                    style: TextStyle(
                                                                                        color: Colors.red,
                                                                                        fontSize: 25,
                                                                                        decoration: TextDecoration.lineThrough
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                Padding(
                                                                                  padding: EdgeInsets.all(6.0),
                                                                                  child: Text(
                                                                                    "R\$ ${items[index].discountedPrice.toStringAsFixed(2) ?? "0"}",
                                                                                    style: TextStyle(
                                                                                        color: Colors.green,
                                                                                        fontSize: 35,
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                Container(
                                                                                  width: 200,
                                                                                  child: RaisedButton(
                                                                                    child: Text(_storeBloc.isAlreadyInCart(items[index]) ? "- Remover do carrinho" : "+ Adicionar no carrinho"),
                                                                                    color: _storeBloc.isAlreadyInCart(items[index]) ? Colors.grey : ColorUtils.ORANGE_ACCENT,
                                                                                    onPressed: () {
                                                                                      _storeBloc.addOrRemoveItemToCart(items[index]);
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                  ),
                                                                                ),

                                                                              ],
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }
                                                                    );
                                                                  },
                                                                  child: Container(
                                                                    width: 180,
                                                                    height: 100,
                                                                    padding: EdgeInsets.all(5),
                                                                    child: Card(
                                                                      child: Column(
                                                                        children: <Widget>[
                                                                          Container(
                                                                            width: 100,
                                                                            height: 100,
                                                                            child: CachedNetworkImage(
                                                                              imageUrl: items[index].itemImageUrl,
                                                                              imageBuilder: (context, imageProvider) => Container(
                                                                                decoration: BoxDecoration(
                                                                                  image: DecorationImage(
                                                                                    image: imageProvider,
                                                                                    fit: BoxFit.cover,),
                                                                                ),
                                                                              ),
                                                                              placeholder: (context, url) => Align(
                                                                                alignment: Alignment.topCenter,
                                                                                child: SizedBox(
                                                                                  width: 180.0,
                                                                                  height: 5.0,
                                                                                  child: new LinearProgressIndicator(),
                                                                                ),
                                                                              ),
                                                                              errorWidget: (context, url, error) => Icon(Icons.error),
                                                                            ),
                                                                          ),

                                                                          Padding(
                                                                            padding: EdgeInsets.all(6.0),
                                                                            child: Text(
                                                                              items[index].itemName ?? "",
                                                                              style: TextStyle(
                                                                                color: Colors.black54
                                                                              ),
                                                                              maxLines: 2,
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                          ),

                                                                          SizedBox(height: 5,),
                                                                          Padding(
                                                                            padding: EdgeInsets.all(3.0),
                                                                            child: Text(
                                                                              "Promoção: ${items[index].itemDiscountPercent ?? 0} %",
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color: Colors.green
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    } else {

                                                      return Container(
                                                        child: Text("Nao existem promoções disponíveis para este setor :/"),
                                                      );
                                                    }
                                                  }

                                                  return Container();
                                                },
                                              );
                                            },
                                          )
                                      ),
                                    );
                                  }

                                  return authorizationStatusOk ? Container(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Procurando por promoções...",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 22
                                            ),
                                          ),

                                          SizedBox(height: 10,),

                                          Text(
                                            "Não se preocupe, assim que encontrarmos boas promoções vamos te mostrar aqui mesmo!",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 15
                                            ),
                                          ),

                                          SizedBox(height: 50,),

                                          Center(
                                            child: Icon(
                                              MaterialCommunityIcons.tag_text_outline,
                                              color: Colors.white,
                                              size: 80,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ) : Card(
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        child: Row(
                                          children: <Widget>[
                                            Icon(
                                              MaterialCommunityIcons.alert,
                                              size: 28,
                                              color: Colors.orangeAccent,
                                            ),

                                            SizedBox(width: 5,),
                                            Container(
                                              width: MediaQuery.of(context).size.width*.7,
                                              child: Text(
                                                "Você deve aceitar as permissões antes de buscar por promoções...",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black45
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                  );
                                },
                              );

                          }

                          return Center(
                            child: Container(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                      );
                    case BluetoothState.stateOff:
                      return Card(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                MaterialCommunityIcons.alert,
                                size: 28,
                                color: Colors.orangeAccent,
                              ),

                              SizedBox(width: 5,),
                              Container(
                                width: MediaQuery.of(context).size.width*.7,
                                child: Text(
                                  "Você deve habilitar o Bluetooth para ver promoções...",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black45
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      );
                      break;
                    default:
                      return Container();
                  }
                },
              ),
            ],
          ),
        ),
      ),

//      _beacons == null || _beacons.isEmpty
//          ? Center(child: CircularProgressIndicator())
//          : ListView(
//        children: ListTile.divideTiles(
//            context: context,
//            tiles: _beacons.map((beacon) {
//              return ListTile(
//                title: Text(beacon.proximityUUID),
//                subtitle: new Row(
//                  mainAxisSize: MainAxisSize.max,
//                  children: <Widget>[
//                    Flexible(
//                        child: Text(
//                            'Major: ${beacon.major}\nMinor: ${beacon.minor}',
//                            style: TextStyle(fontSize: 13.0)),
//                        flex: 1,
//                        fit: FlexFit.tight),
//                    Flexible(
//                        child: Text(
//                            'Accuracy: ${beacon.accuracy}m\nRSSI: ${beacon.rssi}',
//                            style: TextStyle(fontSize: 13.0)),
//                        flex: 2,
//                        fit: FlexFit.tight)
//                  ],
//                ),
//              );
//            })).toList(),
//      ),
    );
  }
}
