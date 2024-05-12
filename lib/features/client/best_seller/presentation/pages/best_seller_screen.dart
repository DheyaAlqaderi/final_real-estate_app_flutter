import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:smart_real_estate/core/constant/app_constants.dart';
import 'package:smart_real_estate/features/client/best_seller/data/models/best_seller_model.dart';

import '../../../../../core/utils/styles.dart';
import '../../domain/repositories/best_seller_repository.dart';
import '../widgets/best_seller_widget.dart';

class BestSellerScreen extends StatefulWidget {
  const BestSellerScreen({super.key});

  @override
  State<BestSellerScreen> createState() => _BestSellerScreenState();
}

class _BestSellerScreenState extends State<BestSellerScreen> {
  late  BestSellerRepository bestSellerRepository;

  @override
  void initState() {
    super.initState();
    bestSellerRepository = BestSellerRepository(Dio());
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          style: IconButton.styleFrom(
            backgroundColor:Theme.of(context).cardColor,
          ),
          icon: const Icon(Icons.arrow_back_ios_new_outlined,size: 15,),
          onPressed: () {
            Navigator.pop(context);
            },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start ,
                  children: [
                    Text(
                      Locales.string(context, 'best_seller'),
                      style: fontLargeBold,
                    ),
                    Text(
                      Locales.string(context, 'text_in_best_seller_page'),
                      style: fontMedium,
                    ),
                  ],
                ),
              ),
              ],
          ),
          Flexible(
            child:FutureBuilder<BestSellerModel?>(
                future: bestSellerRepository. getFavorite(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error ${snapshot.error}');
                  } else if (snapshot.hasData && snapshot.data != null) {
                    var data = snapshot.data!.results;

                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        runSpacing: 1,
                        spacing: 1,
                        children: List.generate(
                          data!.length,
                            (index) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: BestSellerWidget(
                                image: data[index].image==null
                                    ? AppConstants.noImageUrl
                                    : data[index].image!,
                                name: data[index].name!,
                                propertyCount: data[index].propertyCount!,
                                rating:data[index].rateReview!,

                              ),
                            )
                        )
                      ),
                    );
                  } else{
                    return SizedBox();
                  }
                }
            ),
          ),
        ],
      ),

    );
  }
}
