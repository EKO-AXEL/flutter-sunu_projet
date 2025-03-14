import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/my_user.dart';


class UserService with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getUsersStream() {
    return _db.collection('users').snapshots();
  }

  Future<void> addUser(MyUserModel user) async {
    await _db.collection('master_pr_g19_db').doc('users').set(user.toMap());
    notifyListeners(); // Notifier les widgets écoutant ce provider
  }

  Future<MyUserModel?> getUserById(String uid) async {
    DocumentSnapshot doc = await _db.collection('master_pr_g19_db').doc('users').get();
    if (doc.exists) {
      return MyUserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }
}