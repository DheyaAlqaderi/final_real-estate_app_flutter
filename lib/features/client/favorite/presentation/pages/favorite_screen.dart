


import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_real_estate/core/constant/app_constants.dart';
import 'package:smart_real_estate/core/utils/images.dart';
import 'package:smart_real_estate/core/utils/styles.dart';
import 'package:smart_real_estate/features/client/favorite/presentation/widgets/favorite_appbar.dart';
import 'package:smart_real_estate/features/client/favorite/presentation/widgets/favorite_widget_temp.dart';

import '../../../../../core/helper/local_data/shared_pref.dart';
import '../../data/models/delete_favorite_model.dart';
import '../../data/models/favorite_model.dart';
import '../../data/models/rest_modle_favorite.dart';
import '../../data/repositories/network.dart';
import '../widgets/add_favorite.dart';
import '../widgets/favorite_widget_list.dart';



class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});




  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late int list=0;//this to definition the number of items in the list
  late FavoriteRepository favoriteRepository;
  List<DeleteFavoriteModel> deleteList = [];

  late List<FavoriteResult> data;
  String? userId;



  Future<void> _loadUserId() async {
    final loadedUserId = await SharedPrefManager.getData(AppConstants.userId);
    setState(() {
      userId = loadedUserId ?? "";
    });
  }
    String? token=" " ;

  @override
  void initState()  {
    super.initState();
    _loadUserId();
      fetchToken();
    favoriteRepository = FavoriteRepository(Dio());
    fetchData();

  }



  Future<void> fetchToken() async {
    try{
      await SharedPrefManager.init();

      String? tokenFlag = await SharedPrefManager.getData(AppConstants.token);
      setState(() {
        token = tokenFlag!;
      });
    } catch(e){
      print("error load token: $e");
    }

  }

  //this to definition the number of items in the list
  void fetchData()async{
    try{
      var response = await favoriteRepository.getFavorite("token $token");
      setState(() {
        list = response.results?.length ?? 0; // Update list with the length of the results
      });

      for(int i=0; i<list; i++){
        setState(() {
          deleteList.add(DeleteFavoriteModel(id: response.results![i].id));
        });

      }
        }catch(e){
      print('Error fetching data: $e');
    }

  }



  bool isDesign1 = true;

  void showDesign1() {
    setState(() {
      isDesign1 = true;
    });
  }

  void showDesign2() {
    setState(() {
      isDesign1 = false;
    });
  }






  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar:  list != 0?FavoriteAppBar(onTap: ()async{
        await favoriteRepository.deleteAllFavorite("token $token", deleteList);
        setState(() {
          data =  [];
          list = 0;
        });
        Navigator.pop(context);
      },):null,
      body: userId!.isNotEmpty
          ?RefreshIndicator(
        onRefresh: ()async{
          fetchData();
        },
        child: FutureBuilder<FavoriteModel?>(
          future: favoriteRepository.getFavorite("token $token"),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: 200.0,),
                    AddFavorite(),
                  ],
                ),
              );
            } else {
              var data = snapshot.data!.results;
              var list = data!.length;

              if (list < 1) {
                return const SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: 200.0,),
                      AddFavorite(),
                    ],
                  ),
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              Text("$list ", style: fontMediumBold),
                              Text(
                                Locales.string(context, 'favorite_list'),
                                style: fontLarge,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            height: 40,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Theme.of(context).cardColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: showDesign1,
                                    child: Container(
                                      height: 24,
                                      width: 34,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        color: isDesign1 ? Colors.white : Colors.transparent,
                                      ),
                                      child: Center(
                                        child: SvgPicture.asset(
                                          Images.listIcon,
                                          color: isDesign1 ? null : Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: showDesign2,
                                    child: Container(
                                      height: 24,
                                      width: 34,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        color: isDesign1 ? Colors.transparent : Colors.white,
                                      ),
                                      child: Center(
                                        child: SvgPicture.asset(
                                          Images.grideIcon,
                                          fit: BoxFit.contain,
                                          color: isDesign1 ? null : Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Flexible(
                      child: !isDesign1
                          ? GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                        ),
                        itemCount: list,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: FavoriteWidget(
                              imagePath: data[index].prop!.image!.isEmpty
                                  ? " "
                                  : data[index].prop!.image!.first.image!,
                              title: data[index].prop!.name!,
                              price: data[index].prop!.price!,
                              address: data[index].prop!.address!['line1'],
                              isFavorite: data[index].prop!.inFavorite!,
                              rate: data[index].prop!.rateReview!,
                              onTapDelete: () async {
                                await favoriteRepository.deleteFavorite(
                                  "token $token",
                                  data[index].prop!.id!,
                                );
                                // reload the widget
                                setState(() {
                                  // Remove the item from the data list
                                  data.removeAt(index);
                                  list = data.length;
                                });
                              },
                            ),
                          );
                        },
                      )
                          : ListView.builder(
                        itemCount: list,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: FavoriteListWidget(
                              id: data[index].prop!.id!,
                              imagePath: data[index].prop!.image!.isEmpty
                                  ? " "
                                  : data[index].prop!.image!.first.image!,
                              title: data[index].prop!.name!,
                              price: data[index].prop!.price!,
                              address: data[index].prop!.address!['line1'],
                              isFavorite: data[index].prop!.inFavorite!,
                              rate: data[index].prop!.rateReview!,
                              onTapDelete: () async {
                                await favoriteRepository.deleteFavorite(
                                  "token $token",
                                  data[index].prop!.id!,
                                );
                                // reload the widget
                                setState(() {
                                  // Remove the item from the data list
                                  data.removeAt(index);
                                  list = data.length;
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
            }
          },
        ),

      )
          : Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "You are not logged in yet",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: (){

                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Go to Login',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void cancelDelete() {
    setState(() {

    });
  }


}

