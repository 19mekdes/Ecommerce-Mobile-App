class User {
  final int id;
  final String username;
  final String email;
  final String phone;
  final Name name;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      name: Name.fromJson(json['name']),
    );
  }

  String get fullName => '${name.firstname} ${name.lastname}';
}

class Name {
  final String firstname;
  final String lastname;

  Name({required this.firstname, required this.lastname});

  factory Name.fromJson(Map<String, dynamic> json) {
    return Name(
      firstname: json['firstname'],
      lastname: json['lastname'],
    );
  }
}
