class UserModel {
  final int id;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String website;
  final String companyName;
  final String companyCatchPhrase;
  final String city;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.website,
    required this.companyName,
    required this.companyCatchPhrase,
    required this.city,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      website: json['website'],
      companyName: json['company']?['name'] ?? '',
      companyCatchPhrase: json['company']?['catchPhrase'] ?? '',
      city: json['address']?['city'] ?? '',
    );
  }
}
