import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

/// Classe responsável por toda a parte de authenticação de nossos usuários com o Firebase provider
class AuthenticationResources {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Retorna uma stream que emite um novo evento sempre que o estado de authenticação de nosso
  /// usuário mudar. Logado ou Deslogado, por exemplo.
  Stream<FirebaseUser> get onAuthStateChange => _firebaseAuth.onAuthStateChanged;

  /// Retorna o UUID de nosso usuário logado na plataforma.
  Future<String> get userUUID async {
    FirebaseUser currentUser = await _firebaseAuth.currentUser();
    return currentUser != null ? currentUser.uid : null;
  }

  /// Loga o usuário com email e senha
  Future<int> loginWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      return 1;
    } on PlatformException catch (e) {
      print("Platform Exception: Authentication: " +
          e.toString());
      return -1;
    } catch (e) {
      print("Exception: Error: " + e.toString());
      return -2;
    }
  }

  /// Cadastra um novo usuário com email e senha
  Future<int> signUpWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

      return 1;
    } on PlatformException catch (e) {
      print(
          "Platform Exception: Authentication: " +
              e.toString());
      return -1;
    } catch (e) {
      print("Exception: Authentication: " + e.toString());

      return -2;
    }
  }

  /// Desloga o usuário da plataforma
  Future<void> get signOut async {
    _firebaseAuth.signOut();
  }
}