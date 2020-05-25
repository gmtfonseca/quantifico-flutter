import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String organization;
  final String name;
  final String email;

  const User({
    this.organization,
    this.name,
    this.email,
  });

  User.fromJson(Map json)
      : organization = json['organizacao']?.toString(),
        name = json['nome']?.toString(),
        email = json['email']?.toString();

  @override
  List<Object> get props => [
        organization,
        name,
        email,
      ];

  @override
  String toString() {
    return 'User{organization: $organization, name: $name, email: $email}';
  }
}
