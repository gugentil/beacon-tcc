import 'package:beacontcc/src/ui/home/promotions_page.dart';
import 'package:beacontcc/src/ui/home/receipts_page.dart';
import 'package:beacontcc/src/ui/home/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class NavigationPage extends StatefulWidget {
  static const String routeName = 'navigation_page';

  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {

  int _currentIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: <Widget>[
            PromotionsPage(),
            ReceiptsPage(),
            Settings()
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              MaterialCommunityIcons.tag_text_outline
            ),
            backgroundColor: Colors.white,
            title: Text("Promoções")
          ),

          BottomNavigationBarItem(
              icon: Icon(
                  MaterialCommunityIcons.notebook
              ),
              backgroundColor: Colors.white,
              title: Text("Comprovantes")
          ),

          BottomNavigationBarItem(
              icon: Icon(
                  MaterialCommunityIcons.settings
              ),
              backgroundColor: Colors.white,
              title: Text("Configurações")
          ),
        ],
      ),
    );
  }
}
