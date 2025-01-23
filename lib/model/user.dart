class UserModel {
  final String uid;
  final String email;
  final String name;
  final String? password;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    this.password,
  });

  UserModel.empty()
      : uid = '',
        email = '',
        name = '',
        password = null;

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      if (password != null) 'password': password,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'], // Puede ser null
    );
  }
}
