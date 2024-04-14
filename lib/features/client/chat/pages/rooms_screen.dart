import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_real_estate/core/helper/local_data/shared_pref.dart';

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({super.key});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  late String token = '';

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final loadedToken = await SharedPrefManager.getData("token");
    setState(() {
      token = loadedToken ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          // Check if collection is empty
          if (snapshot.data?.docs.isEmpty ?? true) {
            return const Text('No users found.');
          }
          // Display user data
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
              document.data() as Map<String, dynamic>;
              return ListTile(
                title: Text('User ID: ${data['userId']}'),
                subtitle: Text('Email: ${data['email']}'),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

