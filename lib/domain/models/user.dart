class User {
  final String id;
  final String email;
  final String name;
  final String image;
  final DateTime? emailVerified;
  final DateTime createdAt;
  final DateTime updatedAt;
  const User({required this.id, required this.email, required this.name, required this.image, this.emailVerified, required this.createdAt, required this.updatedAt});
}
