import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> signInWithGoogle();
  Future<void> signOut();
  Future<UserEntity?> getCurrentUser();
  Future<List<UserEntity>> getAllUsers();
  Future<void> updateProfile(String userId, String profile);
}
