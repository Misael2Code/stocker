import 'package:flutter/material.dart';
import 'package:stocker/features/auth/domain/entities/user_entity.dart';
import 'package:stocker/features/auth/presentation/controller/auth_controller.dart';

class UserManagementPage extends StatefulWidget {
  final AuthController controller;

  const UserManagementPage({super.key, required this.controller});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  List<UserEntity> users = [];
  List<UserEntity> filtered = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await widget.controller.getAllUsers();

    setState(() {
      users = result;
      filtered = result;
      isLoading = false;
    });
  }

  void _filter(String value) {
    setState(() {
      filtered =
          users
              .where(
                (u) =>
                    u.name.toLowerCase().contains(value.toLowerCase()) ||
                    u.email.toLowerCase().contains(value.toLowerCase()),
              )
              .toList();
    });
  }

  Future<void> _update(UserEntity user, bool isAdmin) async {
    final newProfile = isAdmin ? 'admin' : 'user';

    await widget.controller.updateProfile(user.id, newProfile);

    final index = users.indexWhere((u) => u.id == user.id);

    if (index != -1) {
      setState(() {
        users =
            users
                .map(
                  (u) => u.id == user.id ? u.copyWith(profile: newProfile) : u,
                )
                .toList();

        filtered =
            filtered
                .map(
                  (u) => u.id == user.id ? u.copyWith(profile: newProfile) : u,
                )
                .toList();
      });
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          newProfile == 'admin'
              ? '${user.name} agora é Administrador'
              : '${user.name} agora é Usuário comum',
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Gerenciar usuários"),
        foregroundColor: colors.inversePrimary,
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: _filter,
              decoration: const InputDecoration(
                hintText: "Buscar usuário...",
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),

          if (isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator())),

          if (!isLoading)
            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (_, index) {
                  final user = filtered[index];

                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(user.name.isNotEmpty ? user.name[0] : '?'),
                    ),
                    title: Text(user.name),
                    subtitle: Text(user.email),

                    trailing: PopupMenuButton(
                      icon: const Icon(Icons.more_vert),
                      itemBuilder:
                          (_) => [
                            PopupMenuItem(
                              child: StatefulBuilder(
                                builder: (context, setStatePopup) {
                                  var isAdmin = user.profile == 'admin';

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Text("Administrador"),
                                          const Spacer(),
                                          Switch(
                                            value: isAdmin,
                                            onChanged: (value) async {
                                              Navigator.pop(context);
                                              await _update(user, value);

                                              setState(() {});
                                              setStatePopup(() {});
                                            },
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 8),

                                      const Text(
                                        "Admins podem gerenciar empresas e usuários.",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
