class Session {
  final String id;
  final String userId;
  final String token;
  final DateTime expiresAt;
  final String ipAddress;
  final String userAgent;
  const Session({required this.id, required this.userId, required this.token, required this.expiresAt, required this.ipAddress, required this.userAgent});
}
