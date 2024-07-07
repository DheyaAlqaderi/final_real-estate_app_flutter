
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_real_estate/core/utils/styles.dart';
import 'package:smart_real_estate/features/client/home/data/models/property/property_model.dart';
import 'package:smart_real_estate/owner/home/domain/repositories/property_owner_repositories.dart';
import 'package:smart_real_estate/owner/home/presentation/widgets/owner_property_widget.dart';
import 'package:smart_real_estate/owner/owner_root_screen/presentation/pages/owner_root_screen.dart';

import '../../../../core/constant/app_constants.dart';
import '../../../../core/helper/local_data/shared_pref.dart';
import '../../../../features/client/profile/data/models/profile_model.dart';
import '../../../../features/client/profile/domain/repositories/profile_repository.dart';
import '../widgets/home_appbar.dart';

class OwnerHomeScreen extends StatefulWidget {
  const OwnerHomeScreen({super.key});

  @override
  State<OwnerHomeScreen> createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> {
  late ProfileRepository profileRepository;
  late OwnerPropertyRepository propertyDetailsApi;
  int? id;
  String? token;

  @override
  void initState() {
    super.initState();
    fetchId();
    profileRepository = ProfileRepository(Dio());
    propertyDetailsApi= OwnerPropertyRepository(Dio());
  }

  Future<void> fetchId() async {
    await SharedPrefManager.init();
    String? idf = await SharedPrefManager.getData(AppConstants.userId);
    String? mToken = await SharedPrefManager.getData(AppConstants.token);

    setState(() {
      id = idf != null ? int.parse(idf) : null;
      print("iddddddddddddddddd$id");
      token = mToken ?? " ";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const OwnerHomeAppbar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: FutureBuilder<ProfileModel?>(
          future: id != null ? profileRepository.getProfile(id!) : Future.value(null),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const SizedBox();
            } else if (snapshot.hasData) {
              var profile = snapshot.data!;
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
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
                    const SizedBox(height: 40,),

                    FutureBuilder<PropertyModel?>(
                      future:propertyDetailsApi.getPropertyOwnerByUserId(id!, 200, "token ${token!}"),
                      builder: (context,snapshot){
                        if(snapshot.hasError){
                          return const SizedBox();
                        }else if(snapshot.hasData){
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
                                    price: data[index].price!,
                                    address: data[index].address!,
                                    isFavorite: data[index].inFavorite!,
                                    rate: data[index].rate!,
                                    isActivate: data[index].isActive!,
                                    refresh: OwnerRootScreen(),
                                  )

                            ),
                          );
                        }else{
                          return const Center(child: CircularProgressIndicator());
                        }

                      },

                    )
                    ],),
              );


            } else {
              return SizedBox();
              //return const Center(child: CircularProgressIndicator());
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



