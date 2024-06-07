import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smart_real_estate/core/constant/app_constants.dart';
import 'package:smart_real_estate/core/utils/images.dart';
import 'package:smart_real_estate/core/utils/styles.dart';
import 'package:smart_real_estate/features/client/profile/data/models/profile_model.dart';
import 'package:smart_real_estate/features/client/profile/presentation/pages/profile_update_screen.dart';
import 'package:smart_real_estate/features/client/profile/presentation/widgets/profile_appbar.dart';

import '../../../../../core/helper/local_data/shared_pref.dart';
import '../../../setting/presentation/pages/setting_page.dart';
import '../../domain/repositories/profile_repository.dart';
import '../widgets/user_data_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileRepository profileRepository;

  bool isGoogleLinked = false;
  bool isFaceBookLinked = false;
   int? id;

  @override
  void initState() {

    super.initState();
    fetchId();
    profileRepository = ProfileRepository(Dio());
  }

  Future<void> fetchId() async {
    await SharedPrefManager.init();
    String? idf = (await SharedPrefManager.getData(AppConstants.userId));
    setState(() {
      id =  int.parse(idf!);
    });

  }
  Future<void> _handleGoogleBtnClick() async {
    try {
      // Trigger the Google Authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        return;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the new credential
      await FirebaseAuth.instance.signInWithCredential(credential);

      setState(() {
        isFaceBookLinked = true;
      });
    } catch (error) {
      print(error);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileAppBarWidget(
        editIcon: Images.editIcon,
        onTapBack: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context)=>const SettingScreen(),));
          print("onTapback");
        },
        onTapEdit: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context)=>const ProfileUpdateScreen(),));
          print("onTapEdit");
        },
        title: "personal_profile",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: FutureBuilder<ProfileModel>(
          future: profileRepository.getProfile(id!),
          builder: (context, snapshot){
            if(snapshot.hasError){
              return const SizedBox();
            } else if(snapshot.hasData){
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// image
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(snapshot.data!.image!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5,),
                    /// text user_name
                    Text(snapshot.data!.username!, style: fontMediumBold,),

                    const SizedBox(height: 30),
                    /// text full_name
                    UserDataWidget(
                      userData: snapshot.data!.name!,
                      iconUserData: Images.smallProfile,
                    ),
                    const SizedBox(height: 15,),
                    /// phone_number
                    UserDataWidget(
                        userData: snapshot.data!.phoneNumber!,
                        iconUserData: Images.phoneIcon),
                    const SizedBox(height: 15,),
                    /// email
                    UserDataWidget(
                        userData: snapshot.data!.email!,
                        iconUserData: Images.smallEmailIcon),

                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: (){
                          //   if(isGoogleLinked != true){
                          //     _handleGoogleBtnClick();
                          //   }
                            setState(() {
                              isGoogleLinked = !isGoogleLinked;

                            });

                          },
                          child: Container(
                            width: (MediaQuery.sizeOf(context).width / 2) - 21,
                            height: 85,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: isGoogleLinked?Theme.of(context).primaryColor:Theme.of(context).cardColor
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  const SizedBox(width: 10,),
                                  SvgPicture.asset(Images.googleIcon),
                                  Text(
                                      !isGoogleLinked?"Link":"isLinked",
                                    style: fontMedium.copyWith(color: !isGoogleLinked?Theme.of(context).primaryColor:Theme.of(context).cardColor),
                                  ),
                                  const SizedBox(width: 10,)
                                ],
                              ),
                            ),
                          ),
                        ),

                        InkWell(
                          onTap: (){
                            setState(() {
                              // if(isFaceBookLinked != true){
                              //   // FirebaseAuth instance = FirebaseAuth()/;
                              //
                              //   profileRepository;
                              // }
                              isFaceBookLinked = !isFaceBookLinked;
                            });
                          },
                          child: Container(
                            width: (MediaQuery.sizeOf(context).width /2) - 21,
                            height: 85,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: isFaceBookLinked
                                    ?Theme.of(context).primaryColor
                                    :Theme.of(context).cardColor

                            ),
                            child: Center(
                              child: Row(

                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  const SizedBox(width: 10,),
                                  SvgPicture.asset(Images.facebookIcon),
                                  Text(
                                      !isFaceBookLinked?"Link":"isLinked",
                                    style: fontMedium.copyWith(color: !isFaceBookLinked?Theme.of(context).primaryColor:Theme.of(context).cardColor),

                                  ),
                                  const SizedBox(width: 10,)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )

                  ],
                ),
              );
            } else {
              return const SizedBox();
            }
          }
        ),
      ),
    );
  }
}
