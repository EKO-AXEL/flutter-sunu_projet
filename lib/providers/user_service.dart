import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/my_user.dart';


class UserService with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getUsersStream() {
    return _db.collection('users').snapshots();
  }

  Future<void> addUser(MyUserModel user, String uid) async {
    await _db.collection('users').doc(uid).set(user.toMap());
    notifyListeners(); // Notifier les widgets écoutant ce provider
  }

  Future<MyUserModel?> getUserById(String uid) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        // Vérifier que les données ne sont pas null avant de les convertir en Map
        if (doc.data() != null) {
          return MyUserModel.fromMap(doc.data() as Map<String, dynamic>);
        } else {
          print("Les données du document sont null.");
          return null;
        }
      } else {
        print("Aucun document trouvé avec l'UID : $uid");
        return null;
      }
    } catch (e) {
      print("Erreur lors de la récupération de l'utilisateur : $e");
      return null;
    }
  }
}