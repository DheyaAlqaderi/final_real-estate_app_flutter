

import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smart_real_estate/core/utils/styles.dart';

import '../../../../core/constant/app_constants.dart';
import '../../../../core/helper/local_data/shared_pref.dart';
import '../../../../features/client/favorite/presentation/widgets/favorite_widget_list.dart';
import '../../../../features/client/profile/data/models/profile_model.dart';
import '../../../../features/client/profile/domain/repositories/profile_repository.dart';
import '../../../../features/client/property_details/data/remote_api/property_details_api.dart';
import '../widgets/home_appbar.dart';

class OwnerHomeScreen extends StatefulWidget {
  const OwnerHomeScreen({super.key});

  @override
  State<OwnerHomeScreen> createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> {
  late ProfileRepository profileRepository;
  late PropertyDetailsApi propertyDetailsApi;
  int? id;

  @override
  void initState() {
    super.initState();
    fetchId();
    profileRepository = ProfileRepository(Dio());
    propertyDetailsApi= PropertyDetailsApi(Dio());
  }

  Future<void> fetchId() async {
    await SharedPrefManager.init();
    String? idf = await SharedPrefManager.getData(AppConstants.userId);
    setState(() {
      id =  int.parse(idf!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OwnerHomeAppbar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: FutureBuilder<ProfileModel?>(
          future: profileRepository.getProfile(id!),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const SizedBox();
            } else if (snapshot.hasData) {
              var profile = snapshot.data!;
              return Column(
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
                          'القوائم النشطة'),
                      buildCounter(profile.soldProperty?.toString() ?? '0', 'القوائم غير النشطة'),
                    ],
                  ),
                  SizedBox(height: 40,),

                //   Container(
                //
                //
                //
                //
                //
                //      child:ListView.builder(
                //       itemCount: list,
                //       itemBuilder: (context, index) {
                //         return Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
                //           child: FavoriteListWidget(
                //           id: data[index].prop!.id!,
                //           imagePath: data[index].prop!.image!.isEmpty
                //               ? " "
                //               : data[index].prop!.image!.first.image!,
                //           title: data[index].prop!.name!,
                //           price: data[index].prop!.price!,
                //           address: data[index].prop!.address!,
                //           isFavorite: data[index].prop!.inFavorite!,
                //           rate: data[index].prop!.rateReview!,
                //           onTapDelete: () async {
                //             await favoriteRepository.deleteFavorite(
                //               "token $token",
                //               data[index].prop!.id!,
                //             );
                //             // reload the widget
                //             setState(() {
                //               // Remove the item from the data list
                //               data.removeAt(index);
                //               list = data.length;
                //             });
                //           },
                //         ),
                //       );
                //     },
                //   ),
                //
                //
                //
                //
                 ],);


            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
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
                style: fontSmallBold,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: fontSmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}



