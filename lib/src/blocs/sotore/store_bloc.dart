import 'package:beacontcc/src/models/item.dart';
import 'package:beacontcc/src/resources/auth_resources.dart';
import 'package:beacontcc/src/resources/firestore_resources.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

/// Classe responsável por controlar tudo referente ao nosso carrinho de compras,
/// além de realizar o checkout do mesmo caso o usuário efetue uma compra.
class StoreBloc {
  final _firestoreResources = FirestoreResources();
  final _authResources = AuthenticationResources();
  final _totalItems = BehaviorSubject<int>();

  Stream<int> get totalItems => _totalItems.stream;
  Function(int) get changeTotalItems => _totalItems.sink.add;

  List<Item> _shoppingCart = List<Item>();
  Set<String> _shoppingCartItemsIds = Set<String>();

  /// Checa se o item (produto) em questão já foi adicionado no carrinho.
  bool isAlreadyInCart(Item item) => _shoppingCartItemsIds.contains(item.id);

  /// Adiciona um novo item (produto) no carrinho, ou remove se ele já existe no mesmo.
  void addOrRemoveItemToCart(item) {
    if(_shoppingCartItemsIds.add(item.id)) {
      _shoppingCart.add(item);
    } else {
      _shoppingCartItemsIds.remove(item.id);
      _shoppingCart.remove(item);
    }

    _totalItems.add(_shoppingCart.length);
  }

  /// Verifica se o nosso carrinho está Vazio.
  /// Retorna True caso estaja vazio, False caso contrário
  bool isShoppingCartEmpty() => _totalItems.value != null ? _totalItems.value <= 0 : true;

  /// Retorna a lista contendo todos os produtos do carrinho
  List<Item> getItemsAddedToCart() => _shoppingCart;

  /// Realiza o checkout de todos os itens (/produtos) do carrinho de compras, gerando assim um recibo
  /// para o usuário em nosso back-end (Cloud Firestore)
  Future<void> checkoutShoppingCartAndMakePurchase(List<Item> items, double totalValue, String paymentOption) async {
    String uuid = await _authResources.userUUID;
    return _firestoreResources.checkoutShoppingCartAndMakePurchase(uuid, items, totalValue, paymentOption);
  }

  /// Retorna a stream proveniente de nossa base de dados com todos os recibos de comprar feitas
  /// pelo usuário
  Stream<QuerySnapshot> purchasesList(String userUID) => _firestoreResources.purchasesList(userUID);


  /// Limpa o nosso carrinho de compras atual
  void clearItems() {
    _shoppingCart.clear();
    _shoppingCartItemsIds.clear();
    _totalItems.value = 0;
  }

  /// Fazer o fechamento de nossas streams para que, quando não mais utilizadas,
  /// possam ser destruídas pelo ciclo de vida da nossa aplicação, e assim eco-
  /// nomizar memória.
  void dispose() async {
    await _totalItems.drain();
    _totalItems.close();
  }

}