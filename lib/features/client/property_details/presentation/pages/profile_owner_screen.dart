import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_real_estate/core/utils/images.dart';
import 'package:smart_real_estate/features/client/home/data/models/property/property_model.dart';
import 'package:smart_real_estate/features/client/property_details/presentation/manager/owner_properties/property_owner_properties._cubit.dart';
import 'package:smart_real_estate/features/client/property_details/presentation/manager/owner_properties/property_owner_properties._sate.dart';
import 'package:smart_real_estate/features/client/property_details/presentation/manager/user_profile/property_owner_profile_cubit.dart';
import 'package:smart_real_estate/features/client/property_details/presentation/manager/user_profile/property_owner_profile_state.dart';
import 'package:smart_real_estate/features/client/property_details/presentation/pages/property_details_screen.dart';

import '../../../../../core/utils/styles.dart';
import '../../../home/widgets/stand_property_widget.dart';

class ProfileOwnerScreen extends StatefulWidget {
  const ProfileOwnerScreen({super.key, required this.userId});
  final int userId;

  @override
  State<ProfileOwnerScreen> createState() => _ProfileOwnerScreenState();
}

class _ProfileOwnerScreenState extends State<ProfileOwnerScreen> {


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  void _fetchData() async {
    final getPropertyOwnerProfile = context.read<PropertyOwnerProfileCubit>();
    final getPropertyOwnerProperties = context.read<PropertyOwnerPropertiesCubit>();

    await Future.wait([
      getPropertyOwnerProfile.getPropertyOwnerProfile(widget.userId),
      getPropertyOwnerProperties.getPropertyOwnerProperties(widget.userId)
    ]);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 85.0,
                  width: double.infinity,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 50.0,
                          width: 50.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            color: Theme.of(context).cardColor,
                          ),
                          child: const Align(
                            alignment: Alignment.center,
                            child: Icon(Icons.arrow_back_ios_new_outlined, size: 20),
                          ),
                        ),
                      ),
                      const SizedBox(width: 100.0),
                      Text(Locales.string(context, "personal_profile"), style: fontMediumBold),
                    ],
                  ),
                ),
              ),
              
              /// image Section and details
              BlocBuilder<PropertyOwnerProfileCubit, PropertyOwnerProfileState>(
                builder: (context, state){
                  if(state is PropertyOwnerProfileLoading){
                    return const CircularProgressIndicator();
                  } else if(state is PropertyOwnerProfileLoaded){
                    return Column(
                      children: [
                        Text(state.profile.name.toString(), style: fontMediumBold,),
                        Text(state.profile.email.toString(), style: fontSmall,),
                        const SizedBox(height: 5.0,),
                        SizedBox(
                          height: 100.0,
                          width: 100.0,
                          child: Stack(
                            children: [
                              Container(
                                height: 95,
                                width: 95,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  image: DecorationImage(
                                      image: CachedNetworkImageProvider(state.profile.image == null ?Images.userImageIfNull:state.profile.image.toString()),
                                      fit: BoxFit.cover
                                  ),
                                ),
                              ),

                              Positioned(
                                bottom: 0,
                                right: 8.0,
                                child: Container(
                                  height: 25.0,
                                  width: 25.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: Theme.of(context).cardColor
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 20.0,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                height: 70.0,
                                width: (MediaQuery.of(context).size.width/3) - 10,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text( state.profile.soldProperty.toString(), style: fontMediumBold,),
                                    Text(
                                        Locales.string(context, "sold"),
                                        style: fontSmallBold
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 7.0,),
                              Container(
                                height: 70.0,
                                width: (MediaQuery.of(context).size.width/3) - 10,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(state.profile.countReview.toString(), style: fontMediumBold,),
                                    Text(
                                        Locales.string(context, "review"),
                                        style: fontSmallBold
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 7.0,),
                              Container(
                                height: 70.0,
                                width: (MediaQuery.of(context).size.width/3) - 10,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(state.profile.rating.toString(), style: fontMediumBold,),
                                    const Text(
                                        "⭐ ⭐ ⭐ ⭐ ⭐",
                                        style: fontSmallBold
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  } else if(state is PropertyOwnerProfileError){
                    return Center(
                      child: Text("There was an Error ${state.error}"),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),

              const SizedBox(height: 50.0,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: Theme.of(context).cardColor,
                  ),
                  child: Row(
                    children: [
                      const Padding(padding: EdgeInsets.symmetric(horizontal: 25.0)),
                      SvgPicture.asset(Images.phoneIcon, color: Theme.of(context).colorScheme.onSurface,),
                      const Spacer(flex: 1,),
                      SvgPicture.asset(Images.chatIcon, color: Theme.of(context).colorScheme.onSurface,),
                      const Padding(padding: EdgeInsets.symmetric(horizontal: 25.0)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20.0,),

              BlocBuilder<PropertyOwnerPropertiesCubit, PropertyOwnerPropertiesState>(
                  builder: (context, state){
                    if(state is PropertyOwnerProfileLoading){
                      return const CircularProgressIndicator();
                    } else if(state is PropertyOwnerPropertiesLoaded){
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  Locales.string(context, "found_no").replaceAll(
                                      "{no}",
                                      state.properties.count.toString()
                                  ),
                                  style: fontMediumBold,)
                              ],
                            ),
                          ),

                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.start,
                            spacing: 30.0,
                            runSpacing: 10.0,
                            children: List.generate(
                              state.properties.results!.length,
                                  (index) => StandPropertyWidget(
                                index: index,
                                propertyModel: state.properties,
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PropertyDetailsScreen(
                                              id: state.properties.results![index].id
                                          )
                                      )
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    } else if(state is PropertyOwnerPropertiesError){
                      return Center(
                        child: Text(state.message),
                      );
                    } else {
                      return const SizedBox();
                    }
                  }
              ),


            ],
          ),
        ),
      ),
    );
  }
}
