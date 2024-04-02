import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_real_estate/core/utils/styles.dart';
import 'package:smart_real_estate/features/client/category_property/domain/manager/main_category/subCategory/property_subCategory_cubit.dart';
import 'package:smart_real_estate/features/client/category_property/domain/manager/main_category/subCategory/property_subCategory_state.dart';
import 'package:smart_real_estate/features/client/category_property/domain/manager/property_cubit/property_cubit.dart';
import 'package:smart_real_estate/features/client/category_property/widget/subCategory_widget.dart';

import '../../../../core/utils/images.dart';
import '../../home/widgets/stand_property_widget.dart';
import '../domain/manager/property_cubit/property_state.dart';

class CategoryPropertyScreen extends StatefulWidget {
  const CategoryPropertyScreen({super.key, required this.id, required this.haveChildren});
  final bool haveChildren;
  final id;

  @override
  State<CategoryPropertyScreen> createState() => _CategoryPropertyScreenState();
}

class _CategoryPropertyScreenState extends State<CategoryPropertyScreen> {

  @override
  void initState() {
    super.initState();

    if(widget.haveChildren){
      WidgetsBinding.instance.addPostFrameCallback((_) async{
        final subCategory = context.read<PropertySubCategoryCubit>();
        final getPropertyByMainCategory = context.read<PropertyCubit>();

        await Future.wait([
          subCategory.getSubCategory(parentId: widget.id),
          getPropertyByMainCategory.getPropertyByMainCategory(mainCategory: widget.id)
        ]);

      });
    } else{
      WidgetsBinding.instance.addPostFrameCallback((_) async{
        final subCategory = context.read<PropertySubCategoryCubit>();
        final getPropertyBySubCategory = context.read<PropertyCubit>();
        await Future.wait([
          subCategory.getSubCategory(parentId: widget.id),
          getPropertyBySubCategory.getPropertyBySubCategory(subCategory: widget.id)
        ]);

      });
    }


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: SvgPicture.asset(Images.qurterWithCurveCircle),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: SvgPicture.asset(Images.qurterCircle),
          ),

          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: RefreshIndicator(
              onRefresh: () async {  },
              child: SafeArea(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      const SizedBox(height: 100,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text("العقار", style: fontLargeBold,),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(Images.filterIcon, color: Theme.of(context).colorScheme.onSurface,),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20,),
                      BlocBuilder<PropertySubCategoryCubit, PropertySubCategoryState>(
                        builder: (context, state) {
                          if (state is LoadingSubCategoryState) {
                            return const SizedBox();
                          } else if (state is SuccessSubCategoryState) {
                            final hasCategories = widget.haveChildren;
                            return hasCategories? Wrap(
                              crossAxisAlignment: WrapCrossAlignment.start,
                              spacing: 3.0,
                              runSpacing: 5.0,
                              children: List.generate(
                                state.categoryModel.results.length,
                                    (index) =>  SubCategoryCircleWidget(
                                      categoryModel: state.categoryModel,
                                      index: index,
                                      onTap: () async{

                                        await context.read<PropertyCubit>()
                                            .getPropertyBySubCategory(
                                            subCategory: state.categoryModel.results[index].id);
                                      },
                                    ),
                              ),
                            ): const SizedBox();
                          } else if (state is ErrorSubCategoryState) {
                            return const Center(child: SizedBox());
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),

                      const SizedBox(height: 20,),


                      BlocBuilder<PropertyCubit, PropertyState>(
                        builder: (context, state) {
                          if (state is LoadingPropertyState) {
                            return const SizedBox();
                          } else if (state is SuccessPropertyState) {
                            return Wrap(
                              crossAxisAlignment: WrapCrossAlignment.start,
                              spacing: 30.0,
                              runSpacing: 10.0,
                              children: List.generate(
                                state.propertyModel.results!.length,
                                    (index) => StandPropertyWidget(
                                      index: index,
                                      propertyModel: state.propertyModel,
                                    ),
                              ),
                            );
                          } else if (state is ErrorPropertyState) {
                            return const Center(child: SizedBox());
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),



                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
