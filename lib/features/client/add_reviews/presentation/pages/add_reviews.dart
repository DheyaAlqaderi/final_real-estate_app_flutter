import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:smart_real_estate/features/client/add_reviews/data/review_model.dart';
import 'package:smart_real_estate/features/client/add_reviews/domain/repositories/rating_repository.dart';
import 'package:smart_real_estate/features/client/feedback/presentation/widgets/appBar.dart';

class AddReview extends StatefulWidget {
  const AddReview({super.key, required this.propertyId});
  final int propertyId;

  @override
  State<AddReview> createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  final TextEditingController _controller = TextEditingController();
  String review = '';
  double rating = 0;
  bool isLoading = false;

  late RatingRepository ratingRepository; // Declare as late to initialize later

  Future<void> post() async {
    setState(() {
      isLoading = true;
    });

    // Handle rating and review submission here
    try {
      await ratingRepository.postReview(
          Review(
              review: _controller.text,
              rateReview: rating,
              prop: widget.propertyId),
          "token 0a53a95704d2b4e2bf439563e02bd290c0fa0eb4"
      );
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      // setState(() {
      //   isLoading = false;
      // });
      print("Failed to post review: $e");
    }

    // setState(() {
    //   isLoading = false;
    // });

  }

  @override
  void initState() {
    super.initState();
    ratingRepository = RatingRepository(Dio()); // Initialize RatingRepository
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: "add_review",
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30.0),
              RatingBar.builder(
                initialRating: rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    this.rating = rating;
                  });
                },
              ),
              const SizedBox(height: 100.0),
              SizedBox(
                height: 100,
                child: TextFormField(
                  controller: _controller,
                  maxLines: null, // This controls the height of the field
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    hintText: Locales.string(context, 'add_review'),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      review = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 70.0),
              SizedBox(
                height: 70,
                width: 276,
                child: ElevatedButton(
                  onPressed: () async {
                    await post();
                    Navigator.pop(context);
                  },
                  child: Center(
                    child: isLoading
                        ?const CircularProgressIndicator(color: Colors.white,)
                        :Text(Locales.string(context, "send"), style: const TextStyle(fontSize: 18), // Assuming fontLarge is defined elsewhere
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
