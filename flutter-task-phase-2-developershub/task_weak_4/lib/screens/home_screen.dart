import 'dart:convert'; // Required for jsonDecode
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Use 'as http' for clarity

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Store the fetched users in a list
  List<dynamic> users = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Rest Api Call"), centerTitle: true),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          final email = user['email'];
          return ListTile(
            title: Text("${user['firstName']} ${user['lastName']}"),
            subtitle: Text(email),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchUsers,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> fetchUsers() async {
    const url = "https://dummyjson.com/users";
    final uri = Uri.parse(url);
    final res = await http.get(uri);

    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      setState(() {
        users = json['users']; 
      });
      print("Fetch Users Successful: ${users.length} users found.");
    } else {
      print("Failed to load users");
    }
  }
}
