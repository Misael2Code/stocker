import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasource/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource datasource;
  final FirebaseFirestore firestore;

  AuthRepositoryImpl(this.datasource, this.firestore);

  @override
  Future<UserEntity?> signInWithGoogle() async {
    final user = await datasource.signIn();

    if (user == null) return null;

    final docRef = firestore.collection('users').doc(user.uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      await docRef.set({
        'uid': user.uid,
        'name': user.displayName ?? '',
        'email': user.email ?? '',
        'profile': 'user',
      });
    }

    final data = (await docRef.get()).data()!;

    return UserEntity(
      id: user.uid,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      photoUrl: user.photoURL ?? '',
      profile: data['profile'] ?? 'user',
    );
  }

  @override
  Future<void> signOut() async {
    await datasource.signOut();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) return null;

    final doc = await firestore.collection('users').doc(firebaseUser.uid).get();

    final data = doc.data();

    if (data == null) return null;

    final profile = data['profile'];

    return UserEntity(
      id: firebaseUser.uid,
      name: (data['name'] ?? '').toString(),
      email: (data['email'] ?? '').toString(),
      photoUrl: firebaseUser.photoURL ?? '',
      profile: profile is String ? profile : 'user',
    );
  }

  @override
  Future<List<UserEntity>> getAllUsers() async {
    final snapshot = await firestore.collection('users').get();

    return snapshot.docs.map((doc) {
      final data = doc.data();

      return UserEntity(
        id: doc.id,
        name: data['name'] ?? '',
        email: data['email'] ?? '',
        photoUrl: '',
        profile: data['profile'] ?? 'user',
      );
    }).toList();
  }

  @override
  Future<void> updateProfile(String userId, String profile) async {
    await firestore.collection('users').doc(userId).update({
      'profile': profile,
    });
  }
}
