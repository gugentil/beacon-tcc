import 'package:beacontcc/src/resources/auth_resources.dart';
import 'package:beacontcc/src/ui/auth/login_page.dart';
import 'package:beacontcc/src/ui/home/navigation_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RootPage extends StatefulWidget {
  static const String routeName = 'root_page';

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {

  final AuthenticationResources _authRes = AuthenticationResources();
  Stream<FirebaseUser> _currentUser;

  @override
  void initState() {
    _currentUser = _authRes.onAuthStateChange;
    super.initState();
  }

  void myPopCallback(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  @override
  Widget build(BuildContext context) {

    /// Stream responsável por controlar o estado de authenticação do nosso usuário
    /// Se ele Não estiver logado, mostramos a página de Login, caso contrário direcionamos
    /// para a página principal do app.
    /// Isso garante que nenhum usuário sem antes realizar uma authenticação com sucesso possa
    /// acessar os conteúdos da plataforma.
    return StreamBuilder<FirebaseUser>(
      stream: _currentUser,
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {

        return snapshot.hasData ? NavigationPage() : LoginPage();
      },
    );
  }
}