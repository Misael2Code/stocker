import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthController {
  final AuthRepository repository;

  AuthController(this.repository);

  Future<UserEntity?> login() async {
    return await repository.signInWithGoogle();
  }

  Future<UserEntity?> getCurrentUser() async {
    return await repository.getCurrentUser();
  }

  Future<List<UserEntity>> getAllUsers() async {
    return await repository.getAllUsers();
  }

  Future<void> updateProfile(String userId, String profile) async {
    await repository.updateProfile(userId, profile);
  }
}
