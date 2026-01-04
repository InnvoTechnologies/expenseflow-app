class Organization {
  final String id;
  final String name;
  final String slug;
  final String? logo;
  final String ownerUserId;
  const Organization({required this.id, required this.name, required this.slug, this.logo, required this.ownerUserId});
}
class OrganizationMember {
  final String id;
  final String userId;
  final String organizationId;
  final String role;
  final String status;
  final String accountType;
  const OrganizationMember({required this.id, required this.userId, required this.organizationId, required this.role, required this.status, required this.accountType});
}
