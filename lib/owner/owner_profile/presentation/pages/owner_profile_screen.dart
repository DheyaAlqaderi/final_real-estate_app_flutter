import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:smart_real_estate/core/utils/styles.dart';
import 'package:smart_real_estate/features/client/alarm/presentation/pages/add_alarm_screen.dart';
import 'package:smart_real_estate/features/client/profile/presentation/pages/profile_update_screen.dart';
import 'package:smart_real_estate/owner/owner_profile/presentation/widgets/counter_design.dart';
import 'package:smart_real_estate/owner/owner_profile/presentation/widgets/owner_profile_appBar.dart';

import '../../../../core/constant/app_constants.dart';
import '../../../../core/helper/local_data/shared_pref.dart';
import '../../../../features/client/profile/data/models/profile_model.dart';
import '../../domain/repositories/owner_profile_repository.dart';

class OwnerProfileScreen extends StatefulWidget {
  const OwnerProfileScreen({super.key});

  @override
  State<OwnerProfileScreen> createState() => _OwnerProfileScreenState();
}

class _OwnerProfileScreenState extends State<OwnerProfileScreen> {
  late OwnerProfileRepository ownerProfileRepository;
  int? id;
  String? token;

  @override
  void initState() {

    super.initState();
    fetchId();
    ownerProfileRepository = OwnerProfileRepository(Dio());
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
      appBar: OwnerProfileAppBar(
        alarm: (){Get.to(AddAlarmScreen());},
        edit: (){Get.to(ProfileUpdateScreen());},),

      body:Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          //padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: FutureBuilder<ProfileModel?>(
            future: id != null ? ownerProfileRepository.getProfile(id!) : Future.value(null),
            builder: (context, snapshot){
              if(snapshot.hasError){
                return const SizedBox();
              } else if(snapshot.hasData){
                return SingleChildScrollView(
                  child: Column(
                     crossAxisAlignment: CrossAxisAlignment.center,
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                     SizedBox(height: 20,),
                    //image
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
                    const SizedBox(height: 5,),
                      //name
                      Text(snapshot.data!.username!,style: fontMediumBold,),

                      SizedBox(height: 5,),
                     //email
                       Text(snapshot.data!.email!),

                       SizedBox(height: 5,),
                       //Row
                       Column(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           CounterDesign(count: snapshot.data!.countReview!,label: 'التعليقات',),
                           CounterDesign(count: snapshot.data!.soldProperty!, label: 'مباع'),
                           CounterDesign(count: (snapshot.data!.propertyCount! ), label: 'القوائم'),
                         ],
                       ),













                              ],),
                );
            }else{return SizedBox();}
            }


              ),
        ),
      )


    );
  }
}
