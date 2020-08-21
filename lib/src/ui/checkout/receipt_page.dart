import 'package:beacontcc/src/models/arguments/checkout_arguments.dart';
import 'package:beacontcc/src/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ReceiptPage extends StatefulWidget {
  static const String routeName = 'receipt_page';

  @override
  _ReceiptPageState createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  @override
  Widget build(BuildContext context) {

    CheckoutArguments arguments = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      backgroundColor: ColorUtils.COLOR_GREEN_MAIN,
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[

          Positioned(
            top: 45,
            left: 15,
            child: Container(
              padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 15),
              width: MediaQuery.of(context).size.width*.9,
              height: MediaQuery.of(context).size.height*.75,
              margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 20.0),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width*.9,
                    margin: EdgeInsets.only(top: 2.0, left: 10),
                    child: Text(
                      "Seus produtos com desconto estão garantidos!",
                      style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.green
                      ),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 20.0, right: 25.0),
                    alignment: Alignment.center,
                    height: 100.0,
                    child: Icon(
                      MaterialCommunityIcons.gift_outline,
                      color: ColorUtils.COLOR_GREEN_MAIN,
                      size: 100,
                    ),
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width*.9,
                    margin: EdgeInsets.only(top: 15.0, left: 10),
                    child: Text(
                      "Siga para o caixa da loja e mostre sua nota para um atendente",
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54
                      ),
                    ),
                  ),


                  Container(
                    width: MediaQuery.of(context).size.width*.8,
                    height: 160.0,
                    margin: const EdgeInsets.only(left: 15.0, right: 15.0, top: 0.0),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: arguments.items.length,
                      itemBuilder: (context, position) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 25,
                              margin: EdgeInsets.only(top: 15.0, left: 10),
                              child: Text(
                                "1x.",
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54
                                ),
                              ),
                            ),

                            Container(
                              width: 120,
                              margin: EdgeInsets.only(top: 15.0, left: 10),
                              child: Text(
                                arguments.items[position].itemName,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54
                                ),
                              ),
                            ),

                            Container(
                              width: 70,
                              margin: EdgeInsets.only(top: 15.0, left: 10),
                              child: Text(
                                "R\$ ${arguments.items[position].discountedPrice}",
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),



                ],
              ),
            ),
          ),

          Positioned.fill(
            bottom: 25,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 40.0,
                width: MediaQuery.of(context).size.width*.7,
                margin: EdgeInsets.only(right: 0, left: 0, top: 25),
                child: RaisedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  child: Text("Entendi!", style: TextStyle(color: Colors.black87),),
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}