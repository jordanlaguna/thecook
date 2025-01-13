class UserModel {
  final String uid;
  final String email;
  final String name;
  final String password;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.password,
  });
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'password': password,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
    );
  }
}
