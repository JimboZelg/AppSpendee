class CommunityUser {
  final String id;
  final String name;
  final String? email;
  final String? photoUrl;

  CommunityUser({
    required this.id,
    required this.name,
    this.email,
    this.photoUrl,
  });

  factory CommunityUser.fromMap(Map<String, dynamic> data, String documentId) {
    return CommunityUser(
      id: documentId,
      name: data['name'] ?? '',
      email: data['email'],
      photoUrl: data['photoUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
    };
  }

  CommunityUser copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
  }) {
    return CommunityUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
