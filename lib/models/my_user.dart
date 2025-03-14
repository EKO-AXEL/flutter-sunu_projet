class MyUserModel {
  String? _uid;
  String? _email;
  String? _password;
  String? _nom;
  String? _prenom;

  String? get uid => _uid;
  String? get email => _email;
  String? get password => _password;
  String? get nom => _nom;
  String? get prenom => _prenom;

  set setPrenom(String prenom) {
    _prenom = prenom;
  }

  set setNom(String nom) {
    _nom = nom;
  }

  set setEmail(String email) {
    _email = email;
  }

  MyUserModel(this._uid, this._nom, this._prenom);

  MyUserModel.fromMap(Map<String, dynamic> data, String documentId)
      : _uid = documentId,
        _nom = data['nom'],
        _prenom = data['prenom'];

  // Convertir un MyUserModel en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nom': nom,
      'prenom': prenom,
    };
  }
}