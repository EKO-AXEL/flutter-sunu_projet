class MyUserModel {
  String? _email;
  String? _lastname;
  String? _firstname;

  String? get email => _email;
  String? get lastname => _lastname;
  String? get firstname => _firstname;

  set setFirstname(String firstname) {
    _firstname = firstname;
  }

  set setLastname(String lastname) {
    _lastname = lastname;
  }

  set setEmail(String email) {
    _email = email;
  }

  MyUserModel(this._email, this._lastname, this._firstname);

  MyUserModel.fromMap(Map<String, dynamic> data)
      : _email = data['email'],
        _lastname = data['lastname'],
        _firstname = data['firstname'];

  // Convertir un MyUserModel en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'lastname': lastname,
      'firstname': firstname,
    };
  }
}