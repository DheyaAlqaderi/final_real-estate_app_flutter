import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:smart_real_estate/core/utils/images.dart';
import 'package:smart_real_estate/core/utils/styles.dart';
import 'package:smart_real_estate/features/client/profile/presentation/pages/profile_update_screen.dart';
import 'package:smart_real_estate/features/client/property_details/presentation/pages/property_details_screen.dart';
import 'package:smart_real_estate/owner/add_property/presentation/pages/first_add_property.dart';
import 'package:smart_real_estate/owner/notification/presentation/pages/notification_screen.dart';
import 'package:smart_real_estate/owner/owner_profile/presentation/widgets/owner_profile_appBar.dart';
import 'package:http/http.dart' as http;
import 'package:smart_real_estate/owner/setting/presentation/pages/setting_page.dart';
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
  late OwnerPropertyRepository ownerPropertyRepository;

  int? id;
  String? token;
  bool _isLoading=false;
  List<Map<String, dynamic>>? propertiesId;




  @override
  void initState() {

    super.initState();
    fetchId();
    ownerProfileRepository = OwnerProfileRepository(Dio());
    ownerPropertyRepository=OwnerPropertyRepository(Dio());

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
      appBar: OwnerProfileAppBar(
        setting: () {
          Get.to(SettingOwnerScreen());
        },
        edit: () {
          Get.to(const ProfileUpdateScreen());
        },
        title: "profile_title",
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: FutureBuilder<ProfileModel?>(
            future: id != null ? ownerProfileRepository.getProfile(id!) : Future.value(null),
            //future: ownerProfileRepository.getProfile(id!),
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
                                onTap: () async {

                                  var headers = {
                                    'Authorization': 'token $token',
                                    'Content-Type': 'application/json'
                                  };

                                  var request = http.Request('POST',
                                      Uri.parse('${AppConstants.baseUrl}api/property/update-list/'));


                                  request.body = json.encode({"property_list": propertiesId});

                                  request.headers.addAll(headers);

                                  http.StreamedResponse response = await request.send();

                                  if (response.statusCode == 200) {
                                    print(await response.stream.bytesToString());
                                  }
                                  else {
                                  print(response.reasonPhrase);
                                  }
                                },
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
                                onTap: (){
                                  Get.to(()=> const FirstAddProperty());
                                },
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
                        future:ownerPropertyRepository.getPropertyOwnerByUserId(id!, 200, "token ${token!}"),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const SizedBox();
                          } else if (snapshot.hasData) {
                            var data = snapshot.data!.results!;
                              propertiesId = data.map((id) => {
                                "id": id.id!,
                                "is_active": true
                              }).toList();
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
                                  address: data[index].address!['line1'],
                                  isFavorite: data[index].inFavorite!,
                                  rate: data[index].rate!,
                                  isActivate: data[index].isActive!,
                                  refresh: _refreshData,
                                  onTap: (){
                                    Get.to(()=> PropertyDetailsScreen(id: data[index].id, token: token,));
                                  },
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
