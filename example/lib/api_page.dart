import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hook_state/hook_state.dart';
import 'package:value_selectable/value_selectable.dart';

final userIDState = ValueNotifier(1);

final userState = AsyncValueSelector<User?>(
  null,
  (get) async {
    final userID = get(userIDState);
    final response = await Dio().get('https://jsonplaceholder.typicode.com/users/$userID');

    return User.fromJson(response.data);
  },
);

class ApiPage extends StatefulWidget {
  const ApiPage({super.key});

  @override
  State<ApiPage> createState() => _ApiPageState();
}

class _ApiPageState extends State<ApiPage> with HookStateMixin {
  @override
  Widget build(BuildContext context) {
    final user = useValueListenable(userState);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Api Page'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                userIDState.value++;
              },
              child: const Text('Change User'),
            ),
            if (user != null) ...[
              Text('ID: ${user.id}'),
              Text('Name: ${user.name}'),
              Text('Username: ${user.username}'),
              Text('Email: ${user.email}'),
            ],
          ],
        ),
      ),
    );
  }
}

class User {
  final int id;
  final String name;
  final String username;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
    );
  }
}
