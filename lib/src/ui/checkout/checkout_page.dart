import 'package:beacontcc/src/blocs/sotore/store_bloc.dart';
import 'package:beacontcc/src/blocs/sotore/store_bloc_provider.dart';
import 'package:beacontcc/src/models/arguments/checkout_arguments.dart';
import 'package:beacontcc/src/models/item.dart';
import 'package:beacontcc/src/ui/checkout/receipt_page.dart';
import 'package:beacontcc/src/utils/color_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CheckoutPage extends StatefulWidget {
  static const String routeName = 'checkout_page';

  const CheckoutPage({Key key}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _selectedMethod;
  int _currValue = 0;

  StoreBloc _storeBloc;

  @override
  void didChangeDependencies() {
    _storeBloc = StoreBlocProvider.of(context);
    super.didChangeDependencies();
  }

  double getTotalPrice(List<Item> items) {
    return items.fold(0, (sum, item) => sum + item.discountedPrice);
  }

  void showErrorMessage(String message) {
    final snackbar = SnackBar(content: Text(message), duration: new Duration(seconds: 2));
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    CheckoutArguments arguments = ModalRoute.of(context).settings.arguments;
    List<Item> items = arguments.items;

    double totalPrice = getTotalPrice(items);
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[

          Column(
            children: <Widget>[
              Flexible(
                flex: 15,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 35.0),
                        child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Icon(Icons.close, size: 40.0, color: Colors.white,)
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(top: 2.0, left: 10),
                        child: Text(
                          "Carrinho de compras",
                          style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      ),

                      Container(
                        width: MediaQuery.of(context).size.width*.95,
                        height: MediaQuery.of(context).size.height*.4,
                        margin: EdgeInsets.only(top: 0.0, left: 10),
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: items.length,
                          itemBuilder: (context, position) {
                            return CheckoutCard(
                              imageUrl: items[position].itemImageUrl,
                              productName: items[position].itemName,
                              productValue: items[position].discountedPrice.toString(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Flexible(
                flex: 6,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 5.0, left: 10),
                        child: Text(
                          "Meio de pagamento",
                          style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Radio(
                            value: 1,
                            groupValue: _currValue,
                            onChanged: (value) {
                              setState(() {
                                _currValue = value;
                                _selectedMethod = "Credito";
                              });
                            },
                          ),
                          Text(
                            "Credito",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          ),

                          Radio(
                            value: 2,
                            groupValue: _currValue,

                            onChanged: (value) {
                              setState(() {
                                _currValue = value;
                                _selectedMethod = "Debito";
                              });
                            },
                          ),
                          Text(
                            "Debito",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          ),

                          Radio(
                            value: 3,
                            groupValue: _currValue,
                            onChanged: (value) {
                              setState(() {
                                _currValue = value;
                                _selectedMethod = "Dinheiro";
                              });
                            },
                          ),
                          Text(
                            "Dinheiro",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              Flexible(
                flex: 3,
                child: Container(
                  height: MediaQuery.of(context).size.height*.3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 15.0),
                        child: Text(
                          "R\$ ${totalPrice.toStringAsFixed(2)}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 26.0,
                              color: Colors.green,
                          ),
                        ),
                      ),


                      Container(
                        height: 40.0,
                        width: MediaQuery.of(context).size.width*.5,
                        margin: EdgeInsets.only(left: 18.0),
                        child: RaisedButton(
                          onPressed: () async {
                            if(_selectedMethod != null) {
                              CheckoutArguments receiptArguments = CheckoutArguments(
                                  totalPrice,
                                  _selectedMethod,
                                  items,
                              );
                              await _storeBloc.checkoutShoppingCartAndMakePurchase(items, totalPrice, _selectedMethod);
                              await Navigator.of(context).pushReplacementNamed(ReceiptPage.routeName, arguments: receiptArguments);
                              _storeBloc.clearItems();
                            } else {
                              // show must select payment method error message
                              showErrorMessage("Você deve escolher um meio de pagamento!");
                            }

                          },
                          child: Text("Checkout"),
                          color: ColorUtils.ORANGE_ACCENT,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}

class CheckoutCard extends StatelessWidget {
  final String imageUrl;
  final String productName;
  final String productValue;

  const CheckoutCard({
    Key key,
    @required this.imageUrl,
    @required this.productName,
    @required this.productValue,
  }): super (key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(18.0),
          margin: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
          decoration: const BoxDecoration(
            color: ColorUtils.COLOR_WHITE_FA,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5.0, // soften the shadow
                spreadRadius: 2.0, //extend the shadow
              )
            ],
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(8), bottom: Radius.circular(8)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  color: Colors.blue,
                  height: 100.0,
                  width: 80.0,
                  child: Image(fit: BoxFit.fill, image: CachedNetworkImageProvider(imageUrl))
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(top: 5.0, left: 5.0),
                    width: 160.0,
                    child: Text(
                      productName,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: Colors.black38
                      ),
                    ),
                  ),

                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(top: 5.0, left: 5.0),
                    width: 160.0,
                    child: Text(
                      "R\$ $productValue",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.green
                      ),
                    ),
                  ),

                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(top: 5.0, left: 5.0),
                    width: 160.0,
                    child: Text(
                      "Qnt. 1",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: Colors.black38
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}