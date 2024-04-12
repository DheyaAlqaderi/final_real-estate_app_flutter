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
      body: Column(
        children: [
          const SizedBox(height: 300,),
          Text(token.toString())
        ],
      ),
    );
  }
}

