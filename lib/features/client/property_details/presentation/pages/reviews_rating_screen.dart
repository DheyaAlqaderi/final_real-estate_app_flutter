import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_real_estate/core/constant/app_constants.dart';
import 'package:smart_real_estate/core/utils/images.dart';
import 'package:smart_real_estate/core/utils/styles.dart';
import 'package:smart_real_estate/features/client/property_details/presentation/manager/property_details/property_details_cubit.dart';
import 'package:smart_real_estate/features/client/property_details/presentation/manager/property_details/property_details_state.dart';
import 'package:smart_real_estate/features/client/property_details/presentation/manager/reviews/reviews_cubit.dart';
import 'package:smart_real_estate/features/client/property_details/presentation/manager/reviews/screen_review/review_property_rateNo_cubit.dart';
import 'package:smart_real_estate/features/client/property_details/presentation/manager/reviews/screen_review/review_property_rateNo_state.dart';
import 'package:smart_real_estate/features/client/property_details/presentation/widgets/property_details_widgets/property_review_rating_widget.dart';
import 'package:smart_real_estate/features/client/property_details/presentation/widgets/reviews_rating_widgets/review_selcted_widget.dart';

import '../manager/reviews/reviews_state.dart';

class ReviewsRatingScreen extends StatefulWidget {
  const ReviewsRatingScreen({
    super.key,
    required this.propertyId,
  });

  final int propertyId;

  @override
  State<ReviewsRatingScreen> createState() => _ReviewsRatingScreenState();
}

class _ReviewsRatingScreenState extends State<ReviewsRatingScreen> {
  late List<bool> chipSelected;
  late List<int> numbers;
  late List<bool> defaultChipSelected;
  late int rateNo;

  @override
  void initState() {
    super.initState();
    numbers = [1, 2, 3, 4, 5];
    chipSelected = List.generate(5, (index) => false);
    defaultChipSelected = List.generate(1, (index) => false);
    setState(() {
      rateNo = 0;
      defaultChipSelected[0] = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  void _fetchData() async {
    final getReviewsAll = context.read<ReviewsPropertyCubit>();
    final getReviewsById = context.read<ReviewsPropertyByRateNoCubit>();
    final getPropertyDetails = context.read<PropertyDetailsCubit>();

    await Future.wait([
      getPropertyDetails.getPropertyDetails(
          widget.propertyId, "0a53a95704d2b4e2bf439563e02bd290c0fa0eb4"),
    ]);

    if (rateNo == 0) {
      await Future.wait([
        getReviewsAll.getReviewsProperty(widget.propertyId),
      ]);
    } else {
      await Future.wait([
        getReviewsById.fetchReviewsPropertyByRateNo(
            widget.propertyId, rateNo),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              _buildAppBar(),

              // Property view
              _buildPropertyView(),

              // Row rate star from 1 - 5
              _buildRateStar(),

              // Reviews
              _buildReviews(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
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
            Text(Locales.string(context, "review"), style: fontMediumBold),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyView() {
    return BlocBuilder<PropertyDetailsCubit, PropertyDetailsState>(
      builder: (context, state) {
        if (state is PropertyDetailsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is PropertyDetailsSuccess) {
          final propertyDetails = state.propertyDetails;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Container(
              height: 130.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Theme.of(context).cardColor,
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Container(
                      height: 120.0,
                      width: 168.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                      "${AppConstants.baseUrl3}${propertyDetails.image![0].image}",
                                    ),
                                    fit: BoxFit.cover)),
                          ),

                          // Heart icon
                          Positioned(
                            top: 10.0,
                            right: 10.0,
                            child: Container(
                              height: 25.0,
                              width: 25.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  color: Theme.of(context).cardColor),
                              child: Center(
                                child: SvgPicture.asset(
                                  Images.heartIcon,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            propertyDetails.name.toString(),
                            style: fontMediumBold,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3.0),
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.yellow, size: 16),
                              const SizedBox(width: 4.0),
                              Text(propertyDetails.rate.toString(),
                                  style: fontSmallBold),
                            ],
                          ),
                          const SizedBox(height: 3.0),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined,
                                  size: 16),
                              const SizedBox(width: 4.0),
                              Expanded(
                                child: Text(
                                  propertyDetails.address!.line1.toString(),
                                  style: fontSmallBold,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (state is PropertyDetailsError) {
          return Center(
            child: Text('Error: ${state.error}'),
          );
        } else {
          return const SizedBox(); // Return an empty widget if state is not recognized
        }
      },
    );
  }

  Widget _buildRateStar() {
    return Column(
      children: [
        const SizedBox(height: 20.0),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(
                height: 47.0,
                width: 85.0,
                child: ActionChip(
                  label: Text(
                    "⭐ الكل",
                    style: fontMediumBold.copyWith(
                      color: defaultChipSelected[0]
                          ? Colors.white
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: defaultChipSelected[0]
                      ? const Color(0xFF234F68)
                      : Theme.of(context).cardColor,
                  onPressed: () {
                    setState(() {
                      rateNo = 0;
                    });

                    if (!defaultChipSelected[0]) {
                      context
                          .read<ReviewsPropertyCubit>()
                          .getReviewsProperty(widget.propertyId);
                    }

                    setState(() {
                      // Deselect all chips
                      defaultChipSelected =
                          List.filled(defaultChipSelected.length, false);
                      // Deselect all chips except the default chip
                      chipSelected = List.filled(chipSelected.length, false);
                      // Select the default chip
                      defaultChipSelected[0] = true;

                      if (kDebugMode) {
                        print(rateNo.toString());
                      }
                    });
                  },
                ),
              ),
              ...List.generate(
                numbers.length,
                    (index) => ReviewSelectedWidget(
                  chipSelected: chipSelected,
                  onChipClick: () {
                    setState(() {
                      setState(() {
                        rateNo = numbers[index];
                      });

                      if (!chipSelected[index]) {
                        context
                            .read<ReviewsPropertyByRateNoCubit>()
                            .fetchReviewsPropertyByRateNo(
                            widget.propertyId, rateNo);
                      }

                      chipSelected =
                          List.filled(chipSelected.length, false);
                      chipSelected[index] = true;
                      if (kDebugMode) {
                        print(rateNo.toString());
                      }
                      defaultChipSelected[0] = false;
                    });
                  },
                  index: index,
                  numbers: numbers,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviews() {
    return Column(
      children: [
        const SizedBox(height: 20.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(Locales.string(context, "review"), style: fontMediumBold),
              Container(
                height: 29.0,
                width: 29.0,
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(50.0)),
                child: const Center(
                  child: Icon(Icons.add, size: 16),
                ),
              )
            ],
          ),
        ),
        (rateNo == 0)
            ? BlocBuilder<ReviewsPropertyCubit, ReviewsPropertyState>(
          builder: (context, state) {
            if (state is ReviewsPropertyLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ReviewsPropertyLoaded) {
              if (state.reviewModel.results!.isEmpty) {
                return const Center(
                  child: Text("No Reviews"),
                );
              } else {
                return Column(
                  children: [
                    ...List.generate(
                      state.reviewModel.results!.length,
                          (index) => PropertyReviewAndRatingWidget(
                        rating: -1,
                        reviewModel: state.reviewModel,
                        index: index,
                        propertyId: widget.propertyId,
                      ),
                    ),
                  ],
                );
              }
            } else if (state is ReviewsPropertyError) {
              return Center(
                child: Text(state.message),
              );
            } else {
              return const SizedBox(); // Return an empty widget if state is not recognized
            }
          },
        )
            : BlocBuilder<ReviewsPropertyByRateNoCubit, ReviewsPropertyByRateNoState>(
          builder: (context, state) {
            switch (state.status) {
              case ReviewsPropertyByRateNoStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case ReviewsPropertyByRateNoStatus.loaded:
                return Column(
                  children: [
                    ...List.generate(
                      state.reviewModel!.results!.length,
                          (index) => PropertyReviewAndRatingWidget(
                        rating: -1,
                        reviewModel: state.reviewModel!,
                        index: index,
                        propertyId: widget.propertyId,
                      ),
                    ),
                  ],
                );
              case ReviewsPropertyByRateNoStatus.error:
                return Center(child: Text(state.error!));
              default:
                return const SizedBox(); // Return an empty widget if state is not recognized
            }
          },
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }
}
