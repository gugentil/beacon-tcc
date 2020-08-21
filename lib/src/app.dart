import 'package:beacontcc/src/blocs/beacon_promotions/beacon_promotions_bloc_provider.dart';
import 'package:beacontcc/src/blocs/beacons/beacons_bloc_provider.dart';
import 'package:beacontcc/src/blocs/sotore/store_bloc_provider.dart';
import 'package:beacontcc/src/root_page.dart';
import 'package:beacontcc/src/ui/auth/login_page.dart';
import 'package:beacontcc/src/ui/auth/register_page.dart';
import 'package:beacontcc/src/ui/checkout/checkout_page.dart';
import 'package:beacontcc/src/ui/checkout/receipt_page.dart';
import 'package:beacontcc/src/ui/home/navigation_page.dart';
import 'package:beacontcc/src/utils/color_utils.dart';
import 'package:flutter/material.dart';

class BeaconTCC extends StatelessWidget {

  /// Definição de um tema padrão para nosso app.
  /// Aqui fazemos o assignment de cores, fontes e propriedades
  /// padrões para nossos widgets.
  ThemeData buildTheme() {
    final ThemeData base = ThemeData.dark();
    return base.copyWith(
      accentColor: ColorUtils.ORANGE_ACCENT,
      primaryColor: ColorUtils.ORANGE_DARK,
      buttonColor: ColorUtils.ORANGE_ACCENT,
      scaffoldBackgroundColor: ColorUtils.DARK,
      cardColor: Colors.white,
      textSelectionColor: ColorUtils.ORANGE_ACCENT,
      errorColor: ColorUtils.RED_ACCENT,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(),
      ),

    );
  }


  /// Definição do Widget Raiz de nossa aplicação.
  /// Aqui controlamos todas as rotas do nosso app e definimos o nosso Tema.
  /// É o ponto inicial de uma aplicação Flutter.
  @override
  Widget build(BuildContext context) {
    final ThemeData myAppTheme = buildTheme();

    return BeaconsBlocProvider(
      child: BeaconPromotionsBlocProvider(
        child: StoreBlocProvider(
          child: MaterialApp(
            title: 'TCC Beacon',
            theme: myAppTheme,
            initialRoute: RootPage.routeName,
            routes: {
              RootPage.routeName: (context) => RootPage(),
              LoginPage.routeName: (context) => LoginPage(),
              RegisterPage.routeName: (context) => RegisterPage(),
              NavigationPage.routeName: (context) => NavigationPage(),
              CheckoutPage.routeName: (context) => CheckoutPage(),
              ReceiptPage.routeName: (context) => ReceiptPage(),
            },
          ),
        ),
      ),
    );
  }
}