import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProjectService with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addProject(Map<String, dynamic> projectData) async {
    // Convertir les dates en Timestamp
    if (projectData['start_date'] is DateTime) {
      projectData['start_date'] = Timestamp.fromDate(projectData['start_date']);
    }
    if (projectData['end_date'] is DateTime) {
      projectData['end_date'] = Timestamp.fromDate(projectData['end_date']);
    }

    await _firestore.collection('sunu-project').add(projectData);
    notifyListeners();
  }

  Stream<QuerySnapshot> getProjects() {
    return _firestore.collection('sunu-project').orderBy('start_date', descending: false).snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getProjectById(String projectId) {
    return _firestore.collection('sunu-project').doc(projectId).snapshots();
  }

  Future<void> updateProject(String projectId, Map<String, dynamic> updatedData) async {
    await _firestore.collection('sunu-project').doc(projectId).update(updatedData);
    notifyListeners();
  }

  Future<void> deleteProject(String projectId) async {
    await _firestore.collection('sunu-project').doc(projectId).delete();
    notifyListeners();
  }


  // Espace Services Membres

  Future<void> addMemberToProject(String projectId, String userId) async {
    await FirebaseFirestore.instance
        .collection('projects')
        .doc(projectId)
        .collection('members')
        .doc(userId)
        .set({
      'userId': userId,
      'addedAt': FieldValue.serverTimestamp(),
    });
    notifyListeners();
  }

  Stream<QuerySnapshot> getProjectMembers(String projectId) {
    return FirebaseFirestore.instance
        .collection('projects')
        .doc(projectId)
        .collection('members')
        .snapshots();
  }
}