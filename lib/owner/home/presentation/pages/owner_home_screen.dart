
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_real_estate/core/utils/styles.dart';
import 'package:smart_real_estate/features/client/home/data/models/property/property_model.dart';
import 'package:smart_real_estate/owner/home/domain/repositories/property_owner_repositories.dart';
import 'package:smart_real_estate/owner/home/presentation/widgets/owner_property_widget.dart';
import 'package:smart_real_estate/owner/owner_root_screen/presentation/pages/owner_root_screen.dart';

import '../../../../core/constant/app_constants.dart';
import '../../../../core/helper/local_data/shared_pref.dart';
import '../../../../features/client/profile/data/models/profile_model.dart';
import '../../../../features/client/profile/domain/repositories/profile_repository.dart';
import '../../../../features/client/property_details/presentation/pages/property_details_screen.dart';
import '../widgets/home_appbar.dart';

import 'dart:async';



class OwnerHomeScreen extends StatefulWidget {
  const OwnerHomeScreen({Key? key}) : super(key: key);

  @override
  State<OwnerHomeScreen> createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> {
  late ProfileRepository profileRepository;
  late OwnerPropertyRepository propertyDetailsApi;
  int? id;
  String? token;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchId();
    profileRepository = ProfileRepository(Dio());
    propertyDetailsApi = OwnerPropertyRepository(Dio());
  }

  Future<void> fetchId() async {
    await SharedPrefManager.init();
    String? idf = await SharedPrefManager.getData(AppConstants.userId);
    String? mToken = await SharedPrefManager.getData(AppConstants.token);

    setState(() {
      id = idf != null ? int.parse(idf) : null;
      token = mToken ?? " ";
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    await fetchId();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Owner Home')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: FutureBuilder<ProfileModel?>(
            future: id != null ? profileRepository.getProfile(id!) : Future.value(null),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const SizedBox();
              } else if (snapshot.hasData) {
                var profile = snapshot.data!;
                return _buildContent(profile);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ProfileModel profile) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildCounter(profile.countReview?.toString() ?? '0', 'التعليقات'),
                buildCounter(
                  (profile.propertyCount != null && profile.soldProperty != null)
                      ? (profile.propertyCount! - profile.soldProperty!).toString()
                      : '0',
                  'القوائم النشطة',
                ),
                buildCounter(profile.soldProperty?.toString() ?? '0', 'القوائم غير النشطة'),
              ],
            ),
            const SizedBox(height: 40),
            FutureBuilder<PropertyModel?>(
              future: propertyDetailsApi.getPropertyOwnerByUserId(id!, 200, "token ${token!}"),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const SizedBox();
                } else if (snapshot.hasData) {
                  var data = snapshot.data!.results!;
                  return Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    spacing: 20.0,
                    runSpacing: 10.0,
                    children: List.generate(
                      data.length,
                          (index) => OwnerPropertyWidget(
                        id: data[index].id!,
                        imagePath: data[index].image!.isEmpty ? " " : data[index].image!.first.image!,
                        title: data[index].name!,
                        price: data[index].price ?? "null",
                        address: data[index].address!,
                        isFavorite: data[index].inFavorite!,
                        rate: data[index].rate!,
                        isActivate: data[index].isActive!,
                        onTap: () {
                          Get.to(() => PropertyDetailsScreen(id: data[index].id));
                        }, refresh: OwnerRootScreen(),
                      ),
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCounter(String count, String label) {
    return Column(
      children: [
        Container(
          height: 107,
          width: 107,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: const Color(0xFF252B5C),
              width: 3,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                count,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
