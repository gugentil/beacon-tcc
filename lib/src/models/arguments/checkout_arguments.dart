import '../item.dart';

class CheckoutArguments {
  double totalValue;
  String paymentOption;
  List<Item> items;

  CheckoutArguments(this.totalValue, this.paymentOption, this.items);
}