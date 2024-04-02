import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_real_estate/core/utils/images.dart';
import 'package:smart_real_estate/core/utils/styles.dart';
import 'package:smart_real_estate/features/client/high_places/domain/manager/property_state_cubit/property_state_state.dart';
import 'package:smart_real_estate/features/client/home/widgets/featured_property_widget.dart';

import '../domain/manager/property_state_cubit/property_state_cubit.dart';

class HighStateScreen extends StatefulWidget {
  const HighStateScreen({super.key,  required this.stateId, required this.name});
  final stateId;
  final String name;
  @override
  State<HighStateScreen> createState() => _HighStateScreenState();
}

class _HighStateScreenState extends State<HighStateScreen> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final propertyState = context.read<PropertyStateCubit>();

      await Future.wait([
        propertyState.getPropertyByState(stateId: widget.stateId),

      ]);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PropertyStateCubit, PropertyStateState>(
        builder: (context, state){
          if(state is SuccessPropertyStateState){
            return SafeArea(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // image section
                    _imagesSectionWidget(widget.stateId),
                    const SizedBox(height: 15.0,),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 10.0),
                      child: Text(widget.name.toString() , style: fontLargeBold,),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 10.0),
                      child: Text("عقاراتنا الموصى بها في ${widget.name}", style: fontMedium,),
                    ),
                    const SizedBox(height: 15.0,),
                    InkWell(
                      onTap: (){

                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                        child: Container(
                          height: 70.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Theme.of(context).cardColor,
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).shadowColor.withOpacity(0.2), // Use shadowColor from the theme with opacity
                                spreadRadius: 2, // Spread radius of the shadow
                                blurRadius: 4, // Blur radius of the shadow
                                offset: const Offset(0, 2), // Offset of the shadow
                              ),
                            ],
                          ),

                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.search),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  Locales.string(context, "search_state"),
                                  style: fontMedium.copyWith(color: Colors.grey),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0,),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 10.0),
                      child: Row(
                        children: [
                          Container(
                            height: 40.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Theme.of(context).cardColor
                            ),
                            child:  Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Center(
                                child: Text(
                                  Locales.string(context, "found_no").replaceAll("{no}", state.propertyModel.results!.length.toString()),
                                  style: fontMediumBold,
                                ),
                              ),
                            ),
                          ),
                          const Spacer(flex: 2,),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: List.generate(
                            state.propertyModel.results!.length,
                                (index) =>  Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2.5),
                              child: Center(
                                child: FeaturedPropertyWidget(
                                  propertyModel: state.propertyModel,
                                  index: index,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )

                  ],
                ),
              ),
            );
          } else if(state is LoadingPropertyStateState){
            return const CircularProgressIndicator();
          } else if(state is ErrorPropertyStateState){
            return Center(child: Text("error: ${state.error}"),);
          } else{
            return const SizedBox();
          }
        },

      )
    );
  }


  Widget _imagesSectionWidget(int id) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 375.0,
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: Locales.isDirectionRTL(context)? const BorderRadius.only(
                          bottomLeft: Radius.circular(25.0),
                          bottomRight: Radius.circular(50.0),
                          topLeft: Radius.circular(25.0),
                          topRight: Radius.circular(50.0),
                        ): const BorderRadius.only(
                          bottomLeft: Radius.circular(50.0),
                          bottomRight: Radius.circular(25.0),
                          topLeft: Radius.circular(50.0),
                          topRight: Radius.circular(25.0),
                        ),
                        image: const DecorationImage(
                          image: AssetImage(Images.onBoardingOne),
                          fit: BoxFit.cover,
                        )
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: Locales.isDirectionRTL(context)? const BorderRadius.only(
                                  bottomLeft: Radius.circular(25.0),
                                  bottomRight: Radius.circular(25.0),
                                  topLeft: Radius.circular(50.0),
                                  topRight: Radius.circular(25.0),
                                ): const BorderRadius.only(
                                  bottomLeft: Radius.circular(25.0),
                                  bottomRight: Radius.circular(25.0),
                                  topLeft: Radius.circular(25.0),
                                  topRight: Radius.circular(50.0),
                                ),
                                image: const DecorationImage(
                                  image: AssetImage(Images.onBoardingThree),
                                  fit: BoxFit.cover,
                                )
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: Locales.isDirectionRTL(context)? const BorderRadius.only(
                                  bottomLeft: Radius.circular(50.0),
                                  bottomRight: Radius.circular(25.0),
                                  topLeft: Radius.circular(25.0),
                                  topRight: Radius.circular(25.0),
                                ): const BorderRadius.only(
                                  bottomLeft: Radius.circular(25.0),
                                  bottomRight: Radius.circular(50.0),
                                  topLeft: Radius.circular(25.0),
                                  topRight: Radius.circular(25.0),
                                ),
                                image: const DecorationImage(
                                  image: AssetImage(Images.onBoardingOne),
                                  fit: BoxFit.cover,
                                )
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        Positioned(
          top: 20,
          right: Locales.isDirectionRTL(context)?20:null,
          left: Locales.isDirectionRTL(context)?null:20,
          child: SizedBox(
            height: 50,
            width: 50,
            child: InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              borderRadius: BorderRadius.circular(25),
              child: Container(
                width: 56,
                height: 56,

                decoration: ShapeDecoration(
                  color: Theme.of(context).cardColor.withOpacity(0.800000011920929),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: const Icon(Icons.arrow_back),
              ),
            ),
          ),
        ),
        Positioned(
          top: 20,
          right: Locales.isDirectionRTL(context)?null:20,
          left: Locales.isDirectionRTL(context)?20:null,
          child: SizedBox(
            height: 50,
            width: 50,
            child: InkWell(
              onTap: (){
              },
              borderRadius: BorderRadius.circular(25),
              child: Container(
                width: 56,
                height: 56,

                decoration: ShapeDecoration(
                  color: Theme.of(context).cardColor.withOpacity(0.800000011920929),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: Center(
                  child: SvgPicture.asset(Images.filterIcon, color: Theme.of(context).colorScheme.onSurface,),
                ),
              ),
            ),
          ),
        ),

        Positioned(
          bottom: 30,
          right: Locales.isDirectionRTL(context)?null:20,
          left: Locales.isDirectionRTL(context)?20:null,
          child: SizedBox(
            height: 50,
            width: 50,
            child: InkWell(
              onTap: (){
              },
              borderRadius: BorderRadius.circular(17),
              child: Container(
                width: 56,
                height: 56,

                decoration: ShapeDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.800000011920929),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: Center(
                  child: Text("#$id", style: fontMediumBold.copyWith(color: Colors.white),),
                ),
              ),
            ),
          ),
        )
      ]
    );
  }


}
