import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:smart_real_estate/core/constant/app_constants.dart';
import 'package:smart_real_estate/core/utils/styles.dart';
import 'package:smart_real_estate/features/client/property_details/data/model/review_model.dart';
import 'package:smart_real_estate/features/client/property_details/presentation/pages/reviews_rating_screen.dart';

class PropertyReviewAndRatingWidget extends StatefulWidget {
  const PropertyReviewAndRatingWidget({
    super.key,
    required this.rating,
    required this.reviewModel,
    required this.index,
    required this.propertyId, required this.token, required this.propertyDetails,
  });

  final double rating;
  final int propertyId;
  final ReviewModel reviewModel;
  final int index;
  final String token;
  final propertyDetails;

  @override
  State<PropertyReviewAndRatingWidget> createState() =>
      _PropertyReviewAndRatingWidgetState();
}

class _PropertyReviewAndRatingWidgetState
    extends State<PropertyReviewAndRatingWidget> {
  bool _expanded = false;
  int? _maxLines = 3;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          const SizedBox(height: 10.0),
          if (widget.rating != -1) _buildRatingWidget(),
          const SizedBox(height: 10.0),
          if (widget.rating != -1)
            _buildReviewContainer(
              date: widget.reviewModel.results!.first.timeCreated.toString(),
              profile: widget.reviewModel.results!.first.profile.toString(),
              rate: widget.reviewModel.results!.first.rating.toString(),
              review: widget.reviewModel.results!.first.review.toString(),
              name: widget.reviewModel.results!.first.user.toString()
            ),
          if (widget.rating == -1)
            _buildReviewContainer(
                date: widget.reviewModel.results![widget.index].timeCreated.toString(),
                profile: widget.reviewModel.results![widget.index].profile.toString(),
                rate: widget.reviewModel.results![widget.index].rating.toString(),
                review: widget.reviewModel.results![widget.index].review.toString(),
                name: widget.reviewModel.results![widget.index].user.toString(),
            ),
          if (widget.rating != -1) const SizedBox(height: 7.0),
          if (widget.rating != -1) _buildDisplayAllReviews(widget.propertyId, widget.propertyDetails),
        ],
      ),
    );
  }

  Widget _buildRatingWidget() {
    return Container(
      height: 85.0,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: const Color(0xfff4c6bb0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const SizedBox(width: 7.0),
              Container(
                height: 53.0,
                width: 53.0,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: const Center(
                  child: Icon(Icons.star, color: Colors.amberAccent),
                ),
              ),
              const SizedBox(width: 7.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.rating.toString(),
                        style: fontMediumBold.copyWith(color: Colors.white),
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        "⭐ ⭐ ⭐ ⭐ ⭐",
                        style: fontSmall.copyWith(color: Colors.white),
                      )
                    ],
                  ),
                  Text(
                    Locales.string(context, "review_no").replaceAll(
                        "{no}",
                        (widget.reviewModel.results!.isEmpty)
                            ? "0"
                            : widget.reviewModel.results!.length.toString()),
                    style: fontSmall.copyWith(color: Colors.white),
                  )
                ],
              ),
            ],
          ),
          Row(
            children: [
              if (widget.reviewModel.results!.isNotEmpty)
                SizedBox(
                  height: 40,
                  width: 70,
                  child: Stack(
                    children: List.generate(
                      widget.reviewModel.results!.length >= 3
                          ? 3
                          : widget.reviewModel.results!.length,
                          (index) => Positioned(
                        top: 4,
                        left: index * 20.0,
                        child: Container(
                          height: 30.0,
                          width: 30.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            color: Theme.of(context).cardColor,
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
                                    "${AppConstants.baseUrl3}${widget.reviewModel.results![index].profile}",
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(width: 7.0),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildReviewContainer({
    required String profile,
    required String name,
    required String review,
    required String date,
    required String rate
  }) {
    return Container(
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
                            "${AppConstants.baseUrl3}$profile",
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
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: fontMediumBold,
                      ),
                      Text(
                        "$rate ⭐",
                        style: fontSmall,
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: _toggleExpanded,
                    child: SizedBox(
                      child: Text(
                        review,
                        style: fontMedium,
                        maxLines: _maxLines,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Text(
                    calculateTimeDifference(date),
                    style: fontSmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisplayAllReviews(int propertyId, final propertyDetails) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReviewsRatingScreen(
              propertyId: propertyId,
              token: widget.token, propertyDetails: propertyDetails,
            ),
          ),
        );
      },
      child: Container(
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
      ),
    );
  }

  void _toggleExpanded() {
    setState(() {
      // Toggle a state variable to control the number of lines displayed
      if (_expanded) {
        _maxLines = 3; // Collapse the text to 20 lines when tapped
      } else {
        _maxLines = 20; // Expand the text to show all lines when tapped
      }
      _expanded = !_expanded; // Toggle the state variable
    });
  }

  String calculateTimeDifference(String dateTimeString) {
    DateTime now = DateTime.now();
    DateTime dateTime = DateTime.parse(dateTimeString);

    Duration difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return Locales.string(context, "seconds_ago").replaceAll("{no}", difference.inSeconds.toString());
    } else if (difference.inMinutes < 60) {
      return Locales.string(context, "minutes_ago").replaceAll("{no}", difference.inMinutes.toString());
    } else if (difference.inHours < 24) {
      return Locales.string(context, "hours_ago").replaceAll("{no}", difference.inHours.toString());
    } else if (difference.inDays < 30) {
      return Locales.string(context, "days_ago").replaceAll("{no}", difference.inDays.toString());
    } else if ((difference.inDays ~/ 30) < 12) {
      return Locales.string(context, "month_ago").replaceAll("{no}", "${difference.inDays ~/ 30}");
    } else {
      int years = difference.inDays ~/ 365;
      int months = (difference.inDays % 365) ~/ 30;
      return Locales.string(context, "years_ago").replaceAll("{no}", '$years years and $months months ago');
    }
  }


}
