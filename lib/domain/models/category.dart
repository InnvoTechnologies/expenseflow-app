enum CategoryType { income, expense }
class Category {
  final String id;
  final String name;
  final CategoryType type;
  final int color;
  final String? parentId;
  final String userId;
  final String? organizationId;
  const Category({required this.id, required this.name, required this.type, required this.color, this.parentId, required this.userId, this.organizationId});
}
