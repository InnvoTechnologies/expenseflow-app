class Payee {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? address;
  final String? description;
  final String userId;
  final String? organizationId;

  const Payee({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.address,
    this.description,
    required this.userId,
    this.organizationId,
  });

  factory Payee.fromJson(Map<String, dynamic> json) => Payee(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String?,
        phone: json['phone'] as String?,
        address: json['address'] as String?,
        description: json['description'] as String?,
        userId: json['userId'] as String,
        organizationId: json['organizationId'] as String?,
      );
}
