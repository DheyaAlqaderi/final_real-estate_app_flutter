import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:intl/intl.dart';
import 'package:smart_real_estate/core/constant/app_constants.dart';
import 'package:smart_real_estate/core/utils/styles.dart';
import 'package:smart_real_estate/features/client/property_details/data/model/review_model.dart';

class PropertyReviewAndRatingWidget extends StatefulWidget {
  const PropertyReviewAndRatingWidget({super.key, required this.rating, required this.reviewModel});
  final double rating;
  final ReviewModel reviewModel;

  @override
  State<PropertyReviewAndRatingWidget> createState() => _PropertyReviewAndRatingWidgetState();
}

class _PropertyReviewAndRatingWidgetState extends State<PropertyReviewAndRatingWidget> {
  bool _expanded = false;
  int? _maxLines = 3;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(Locales.string(context, "review"), style: fontMediumBold,),
              Container(
                height: 29.0,
                width: 29.0,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(50.0)
                ),
                child: const Center(
                  child: Icon(Icons.add, size: 16,),
                ),
              )
            ],
          ),

          const SizedBox(height: 10.0,),
          _buildRatingWidget(),
          const SizedBox(height: 10.0,),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Theme.of(context).cardColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Column(
                    children: [
                      Container(
                        height: 55.0,
                        width: 55.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Container(
                            height: 55.0,
                            width: 55.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.0),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                  "${AppConstants.baseUrl2}${widget.reviewModel.results[0].profile}",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox()
                    ],
                  ),
                  const SizedBox(width: 7.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.reviewModel.results.last.user.toString(), style: fontMediumBold,),
                            Text("${widget.reviewModel.results.last.rating.toString()} ⭐", style: fontSmall,)
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              // Toggle a state variable to control the number of lines displayed
                              if (_expanded) {
                                _maxLines = 3; // Collapse the text to 20 lines when tapped
                              } else {
                                _maxLines = 20; // Expand the text to show all lines when tapped
                              }
                              _expanded = !_expanded; // Toggle the state variable
                            });
                          },
                          child: SizedBox(
                            child: Text(
                              widget.reviewModel.results.last.review.toString(),
                              style: fontMedium,
                              maxLines: _maxLines,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),

                        Text(calculateTimeDifference(widget.reviewModel.results.last.timeCreated.toString()),
                          style: fontSmall,
                        ),

                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
          const SizedBox(height: 7.0),
          Container(
            height: 58.0,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).cardColor,
            ),
            child: Center(
              child: Text(
                Locales.string(context, "display_all_reviews"),
                style: fontMediumBold,
              ),
            ),
          )

        ],
      ),

    );
  }
  String calculateTimeDifference(String dateString) {
    // Parse the input date string into a DateTime object
    DateTime inputDate = DateFormat('yyyy-MM-dd HH:mm').parse(dateString).toLocal();

    // Get the current date in the same time zone as the input date
    DateTime currentDate = DateTime.now().toLocal();

    // Calculate the difference between the current date and the input date
    Duration difference = currentDate.difference(inputDate);

    // Convert the difference into hours
    int hoursDifference = difference.inHours;

    if (hoursDifference < 24) {
      return Locales.string(context, "hours_ago").replaceAll("{no}", hoursDifference.toString());
    } else if (hoursDifference < 24 * 30) {
      int daysDifference = difference.inDays;
      return Locales.string(context, "days_ago").replaceAll("{no}", daysDifference.toString());
    } else {
      int monthsDifference = currentDate.month - inputDate.month + (currentDate.year - inputDate.year) * 12;
      return Locales.string(context, "month_ago").replaceAll("{no}", monthsDifference.toString());
    }
  }


  Widget _buildRatingWidget(){
    return Container(
      height: 85.0,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Theme.of(context).primaryColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const SizedBox(width: 7.0,),
              Container(
                height: 53.0,
                width: 53.0,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: const Center(
                  child: Icon(Icons.star, color: Colors.amberAccent,),
                ),
              ),
              const SizedBox(width: 7.0,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      // rate no
                      Text(widget.rating.toString(), style: fontMediumBold.copyWith(color: Colors.white),),
                      // rate stars
                      const SizedBox(width: 4.0,),
                      Text("⭐ ⭐ ⭐ ⭐ ⭐", style: fontSmall.copyWith(color: Colors.white),)
                    ],
                  ),
                  Text(
                    Locales.string(context, "review_no").replaceAll("{no}", widget.reviewModel.results.length.toString()),
                    style: fontSmall.copyWith(color: Colors.white),
                  )
                ],
              ),
            ],
          ),

          Row(
            children: [
              (widget.reviewModel.results.length >= 3)
                  ? SizedBox(
                      height: 40,
                      width: 70,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 4,
                            left: 0,
                            child: Container(
                              height: 30.0,
                              width: 30.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  color: Theme.of(context).cardColor
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Container(
                                  height: 30.0,
                                  width: 30.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50.0),
                                      image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                            "${AppConstants.baseUrl2}${widget.reviewModel.results[0].profile}",
                                          )
                                      )
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            left: 20,
                            child: Container(
                              height: 30.0,
                              width: 30.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  color: Theme.of(context).cardColor
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Container(
                                  height: 30.0,
                                  width: 30.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50.0),
                                      image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                            "${AppConstants.baseUrl2}${widget.reviewModel.results[1].profile}",
                                          )
                                      )
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            left: 40,
                            child: Container(
                              height: 30.0,
                              width: 30.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  color: Theme.of(context).cardColor
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Container(
                                  height: 30.0,
                                  width: 30.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50.0),
                                      image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                            "${AppConstants.baseUrl2}${widget.reviewModel.results[2].profile}",
                                          )
                                      )
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  :(widget.reviewModel.results.length == 2)
                  ? SizedBox(
                      height: 40,
                      width: 70,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 4,
                            left: 0,
                            child: Container(
                              height: 30.0,
                              width: 30.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  color: Theme.of(context).cardColor
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Container(
                                  height: 30.0,
                                  width: 30.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50.0),
                                      image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                            "${AppConstants.baseUrl2}${widget.reviewModel.results[0].profile}",
                                          )
                                      )
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            left: 20,
                            child: Container(
                              height: 30.0,
                              width: 30.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  color: Theme.of(context).cardColor
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Container(
                                  height: 30.0,
                                  width: 30.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50.0),
                                      image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                            "${AppConstants.baseUrl2}${widget.reviewModel.results[1].profile}",
                                          )
                                      )
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ): (widget.reviewModel.results.length == 1)
                  ? SizedBox(
                      height: 40,
                      width: 70,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 4,
                            left: 0,
                            child: Container(
                              height: 30.0,
                              width: 30.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  color: Theme.of(context).cardColor
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Container(
                                  height: 30.0,
                                  width: 30.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50.0),
                                      image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                            "${AppConstants.baseUrl2}${widget.reviewModel.results[0].profile}",
                                          )
                                      )
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ): const SizedBox(),
              const SizedBox(width: 7.0,)
            ],
          )
        ],
      ),
    );
  }
}
