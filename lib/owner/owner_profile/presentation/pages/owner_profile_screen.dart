import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:smart_real_estate/core/utils/images.dart';
import 'package:smart_real_estate/core/utils/styles.dart';
import 'package:smart_real_estate/features/client/alarm/presentation/pages/add_alarm_screen.dart';
import 'package:smart_real_estate/features/client/profile/presentation/pages/profile_update_screen.dart';
import 'package:smart_real_estate/owner/owner_profile/presentation/widgets/owner_profile_appBar.dart';

import '../../../../core/constant/app_constants.dart';
import '../../../../core/helper/local_data/shared_pref.dart';
import '../../../../features/client/home/data/models/property/property_model.dart';
import '../../../../features/client/profile/data/models/profile_model.dart';
import '../../../home/domain/repositories/property_owner_repositories.dart';
import '../../../home/presentation/widgets/owner_property_widget.dart';
import '../../domain/repositories/owner_profile_repository.dart';

class OwnerProfileScreen extends StatefulWidget {
  const OwnerProfileScreen({super.key});

  @override
  State<OwnerProfileScreen> createState() => _OwnerProfileScreenState();
}

class _OwnerProfileScreenState extends State<OwnerProfileScreen> {
  late OwnerProfileRepository ownerProfileRepository;
  late OwnerPropertyRepository propertyData;

  int? id;
  String? token;

  @override
  void initState() {

    super.initState();
    fetchId();
    ownerProfileRepository = OwnerProfileRepository(Dio());
    propertyData=OwnerPropertyRepository(Dio());
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OwnerProfileAppBar(
        alarm: () {
          Get.to(const AddAlarmScreen());
        },
        edit: () {
          Get.to(const ProfileUpdateScreen());
        },
        title: "profile_title",
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder<ProfileModel?>(
          //future: id != null ? ownerProfileRepository.getProfile(id!) : Future.value(null),
          future: ownerProfileRepository.getProfile(id!),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const SizedBox();
            } else if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    // Image
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(snapshot.data!.image ?? AppConstants.noImageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    // Name
                    Text(
                      snapshot.data!.username!,
                      style: fontMediumBold,
                    ),
                    const SizedBox(height: 5),
                    // Email
                    Text(snapshot.data!.email!),
                    const SizedBox(height: 10),
                    // Row data
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildCounter(snapshot.data!.countReview!.toString(), 'التعليقات'),
                        buildCounter(snapshot.data!.soldProperty!.toString(), 'مباع'),
                        buildCounter(snapshot.data!.propertyCount!.toString(), 'القوائم'),
                      ],
                    ),
                    const SizedBox(height: 15),
                    // Active all list
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: const Color(0xFFF5F4F8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: (){},
                              child: Container(
                                height: 35,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: const Color(0xFFFFFFFF),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Text(
                                    Locales.string(context, 'price_improvement'),
                                    style: fontSmall,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: (){},
                              child: Container(
                                height: 35,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: const Color(0xFFFFFFFF),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Text(
                                    Locales.string(context, 'active_all'),
                                    style: fontSmall,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: (){},
                              child: Container(
                                height: 35,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: const Color(0xFFFFFFFF),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Text(
                                    Locales.string(context, 'transaction'),
                                    style: fontSmall,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              snapshot.data!.propertyCount!.toString(),
                              style: fontLarge,
                            ),
                            Text(
                              Locales.string(context, "favorite_list"),
                              style: fontLarge,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: (){},
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                child: SvgPicture.asset(
                                  Images.addNavIcon,
                                  alignment: Alignment.centerRight,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: (){},
                              child: Container(
                                width: 52,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Theme.of(context).cardColor,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset(
                                    Images.grideIcon,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    FutureBuilder<PropertyModel?>(
                      future:propertyData.getPropertyOwnerByUserId(id!, 200, "token ${token!}"),
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
                                price: data[index].price!,
                                address: data[index].address!,
                                isFavorite: data[index].inFavorite!,
                                rate: data[index].rate!,
                                isActivate: data[index].isActive!,
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
              );
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
          height: 75,
          width: 107,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFECEDF3),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                count ,
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