class UserEntity {
  final String id;
  final String name;
  final String email;
  final String photoUrl;
  final String profile;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.profile,
  });

  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    String? profile,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      profile: profile ?? this.profile,
    );
  }
}
