import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sunu_projet/models/my_user.dart';

class AuthenticationService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _uid;
  String? get uid => _uid;

  User? _user;
  MyUserModel? _myUserModel;

  MyUserModel? get myUserModel => _myUserModel;
  User? get user => _user;

 Stream<User?> get authStateChanges => _auth.authStateChanges();

 AuthenticationService() {
   _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
   });
 }

 void setMyUserConnected(MyUserModel? myUserModel) {
   _myUserModel = myUserModel;
   notifyListeners();
 }

 Future<void> signInWithEmailAndPassword({
      required String email,
      required String password,
  }) async {
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
        _uid = userCredential.user?.uid;
        notifyListeners();
      } catch (e) {
        print("Erreur lors de la création de l'utilisateur : $e");
      }
      return null;
   }

  Future<String?> createUserWithEmailAndPassword({
    required String email,
    required String password,

  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _uid = userCredential.user?.uid; // Stocke l'UID
      notifyListeners(); // Notifie les écouteurs que l'état a changé
    } catch (e) {
      print("Erreur lors de la création de l'utilisateur : $e");
    }
    return null;
  }

 // Déconnexion
 Future<void> signOut() async {
    await _auth.signOut();
  }
}