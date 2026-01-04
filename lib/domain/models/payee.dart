class Payee {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? description;
  final String userId;
  final String? organizationId;
  const Payee({required this.id, required this.name, this.email, this.phone, this.description, required this.userId, this.organizationId});
}
