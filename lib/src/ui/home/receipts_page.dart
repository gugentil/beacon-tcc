import 'package:beacontcc/src/blocs/sotore/store_bloc.dart';
import 'package:beacontcc/src/blocs/sotore/store_bloc_provider.dart';
import 'package:beacontcc/src/models/arguments/checkout_arguments.dart';
import 'package:beacontcc/src/models/item.dart';
import 'package:beacontcc/src/resources/auth_resources.dart';
import 'package:beacontcc/src/ui/checkout/receipt_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReceiptsPage extends StatefulWidget {
  @override
  _ReceiptsPageState createState() => _ReceiptsPageState();
}

class _ReceiptsPageState extends State<ReceiptsPage> {

  StoreBloc _storeBloc;
  final _authResources = AuthenticationResources();

  Future<String> userUidFuture;

  @override
  void didChangeDependencies() {
    _storeBloc = StoreBlocProvider.of(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    userUidFuture = _authResources.userUUID;

    super.initState();
  }
  @override
  void dispose() {
    _storeBloc.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Meus Comprovantes",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height*.035,),

              FutureBuilder(
                future: userUidFuture,
                builder: (context, AsyncSnapshot<String> uuid) {
                  if(!uuid.hasData || uuid.connectionState == ConnectionState.waiting)
                    return Center(
                      child: Container(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(),
                      ),
                    );

                  return StreamBuilder(
                    stream: _storeBloc.purchasesList(uuid.data),
                    builder: (context, AsyncSnapshot<QuerySnapshot> purchases) {

                      if(purchases.hasData) {
                        List<DocumentSnapshot> docs = purchases.data.documents;



                        if(docs.isNotEmpty) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[

                              Container(
                                width: MediaQuery.of(context).size.width*.95,
                                height: MediaQuery.of(context).size.height*.7,
                                margin: EdgeInsets.only(top: 0.0, left: 10),
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: docs.length,
                                  itemBuilder: (context, position) {
                                    double price = docs[position]['totalValue'];
                                    int totalItems = docs[position]['items'] != null ? docs[position]['items'].length : 0;
                                    double totalPrice = docs[position]['totalValue'] ?? 0.0;
                                    String paymentOption = docs[position]['paymentOption'] ?? "";
                                    List<Item> items = List();

                                    List<dynamic> itemsRaw = docs[position]['items'];
                                    itemsRaw.forEach((element) {
                                      items.add(Item.fromJson(element));
                                    });

                                    return GestureDetector(
                                      onTap: () async {
                                        CheckoutArguments receiptArguments = CheckoutArguments(
                                          totalPrice,
                                          paymentOption,
                                          items,
                                        );

                                        await Navigator.of(context).pushNamed(ReceiptPage.routeName, arguments: receiptArguments);
                                      },
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[

                                          Padding(
                                            padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0, bottom: 10),
                                            child: Card(
                                              child: Padding(
                                                padding: EdgeInsets.all(15),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[

                                                    Container(
                                                      child: Text(
                                                          "R\$ ${price.toStringAsFixed(2).toString()}",
                                                          style: TextStyle(
                                                              color: Colors.black45,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 18.0)
                                                      ),
                                                    ),

                                                    Container(
                                                      child: Text(
                                                          "$totalItems produto${totalItems > 1 ? "s" : ""}",
                                                          style: TextStyle(
                                                              color: Colors.black45,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 18.0)
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[

                              Container(
                                margin: EdgeInsets.only(top: 30.0, left: 20.0, bottom: 20.0, right: 20.0),
                                child: Text(
                                    "Você ainda não realizou uma compra...",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 21.0)
                                ),
                              ),

                              Container(
                                margin: EdgeInsets.only(top: 35.0, left: 20.0, bottom: 20.0, right: 20.0),
                                child: Text(
                                    "Estamos buscando por promoções próximas de você ;D ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 21.0)
                                ),
                              ),
                            ],
                          );
                        }

                      } else {
                        return Container();
                      }
                    },
                  );
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}
