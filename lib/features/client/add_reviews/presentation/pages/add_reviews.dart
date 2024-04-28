import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:smart_real_estate/features/client/feedback/presentation/widgets/appBar.dart';

import '../../../../../core/utils/styles.dart';
import '../../../home/pages/home_screen.dart';

class AddReview extends StatefulWidget {
  const AddReview({super.key});

  @override
  State<AddReview> createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  final TextEditingController _controller = TextEditingController();
  String review = '';




  double rating = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: "add_review",
        onTap: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context)=>const HomeScreen(),));
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
                  maxLines: null , // This controls the height of the field
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
                ),
              ),

              const SizedBox(height: 70.0),
              SizedBox(
                height: 70,
                width: 276,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle rating and review submission here
                  },
                  child: Center(
                    child: (
                      Text(Locales.string(context, "send"),style: fontLarge,)),
                  )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
