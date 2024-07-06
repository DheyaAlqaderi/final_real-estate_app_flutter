import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

import '../../../../core/constant/app_constants.dart';
import '../../../../core/helper/local_data/shared_pref.dart';


class SecondAddressAddProperty extends StatefulWidget {
  const SecondAddressAddProperty({super.key});

  @override
  State<SecondAddressAddProperty> createState() => _SecondAddressAddPropertyState();
}

class _SecondAddressAddPropertyState extends State<SecondAddressAddProperty> {
  String? userId;
  String? userToken;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  /// load user data token and id
  Future<void> _loadUserData() async {
    final loadedUserId = await SharedPrefManager.getData(AppConstants.userId);
    final loadedUserToken = await SharedPrefManager.getData(AppConstants.token);

    print(loadedUserId.toString());
    setState(() {
      userId = loadedUserId ?? '';
      userToken = loadedUserToken ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomDropdown<Job>(
          hintText: 'Select job role',
          items: _list,
          onChanged: (value) {
            log('changing value to: $value');
          },
        )
      ),
    );
  }
}

class Job with CustomDropdownListFilter {
  final String name;
  final IconData icon;
  const Job(this.name, this.icon);

  @override
  String toString() {
    return name;
  }

  @override
  bool filter(String query) {
    return name.toLowerCase().contains(query.toLowerCase());
  }
}

const List<Job> _list = [
  Job('Developer', Icons.developer_mode),
  Job('Designer', Icons.design_services),
  Job('Consultant', Icons.account_balance),
  Job('Student', Icons.school),
];

// class MultiSelectSearchDropdown extends StatelessWidget {
//   const MultiSelectSearchDropdown({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return
//   }
// }