import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:smart_real_estate/features/client/filter_screen/presentation/pages/filter_screen.dart';
import 'package:smart_real_estate/features/client/search/presentation/widgets/search_appbar.dart';

import '../../../../../core/utils/images.dart';
import '../../../../../core/utils/styles.dart';
import '../../domain/search_meta_data.dart';



class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
   final int list=0;
   late FocusNode _focusNode;


   /// algolia setup
   final _searchTextController = TextEditingController();
   final _productsSearcher = HitsSearcher(
       applicationID: 'K5HRMSGJI4',
       apiKey: '67e7c4435e6254c743056eb62f612305',
       indexName: 'real_estate_index');

   Stream<SearchMetadata> get _searchMetadata =>
       _productsSearcher.responses.map(SearchMetadata.fromResponse);

   final PagingController<int, Product> _pagingController =
   PagingController(firstPageKey: 0);

   Stream<HitsPage> get _searchPage =>
       _productsSearcher.responses.map(HitsPage.fromResponse);

   final GlobalKey<ScaffoldState> _mainScaffoldKey = GlobalKey();

   final _filterState = FilterState();

   late final _facetList = _productsSearcher.buildFacetList(
     filterState: _filterState,
     attribute: 'brand',
   );

   @override
   void initState() {
     super.initState();
     _focusNode = FocusNode();
     // Request focus when the widget is built
     WidgetsBinding.instance.addPostFrameCallback((_) {
       FocusScope.of(context).requestFocus(_focusNode);
     });


     /// algolia setup
     _searchTextController.addListener(
           () => _productsSearcher.applyState(
             (state) => state.copyWith(
           query: _searchTextController.text,
           page: 0,
         ),
       ),
     );
     _searchPage.listen((page) {
       if (page.pageKey == 0) {
         _pagingController.refresh();
       }
       _pagingController.appendPage(page.items, page.nextPageKey);
     }).onError((error) => _pagingController.error = error);
     _pagingController.addPageRequestListener(
             (pageKey) => _productsSearcher.applyState(
                 (state) => state.copyWith(
               page: pageKey,
             )
         )
     );
     _productsSearcher.connectFilterState(_filterState);
     _filterState.filters.listen((_) => _pagingController.refresh());
   }

   @override
   void dispose() {
     _focusNode.dispose();
     super.dispose();
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


    return Scaffold(
      appBar: AppBarSearch(
          onPressed: (){
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (builder) =>FilterScreen(),
                  // _filterScreen(),
            );
          },
          onTapBack: (){
            Navigator.pop(context);
          }),

      body:Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30,),
              Hero(
                tag: "search",
                child: TextField(
                  controller: _searchTextController,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    hintText: Locales.string(context, "search_here"),
                    contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8), // Adjust the vertical padding as needed
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              Column(
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
                            Text(Locales.string(context, "have"), style: fontLarge,),
                            Text("$list ", style: fontMediumBold,),
                            Text(Locales.string(context, 'favorite_list'),
                              style: fontLarge,)
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
                              color: Theme.of(context).cardColor
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
                ],
              ),
              const SizedBox(height: 30,),
              StreamBuilder<List<SelectableItem<Facet>>>(
                stream: _facetList.facets,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox.shrink();
                  }
                  final selectedData = snapshot.data!;
                  if (selectedData.isEmpty) {
                    return const Center(child: Text('No items found'));
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: selectedData.length,
                      itemBuilder: (context, index) {
                        final item = selectedData[index];
                        return ListTile(
                          leading: Image.network(Images.noImageUrl),
                          title: Text(item.toString()),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      )


    );
  }

}
class Product {
  final String name;
  final String image;

  Product(this.name, this.image);

  static Product fromJson(Map<String, dynamic> json) {
    return Product(json['name'], json['image_urls'][0]);
  }
}

class HitsPage {
  const HitsPage(this.items, this.pageKey, this.nextPageKey);

  final List<Product> items;
  final int pageKey;
  final int? nextPageKey;

  factory HitsPage.fromResponse(SearchResponse response) {
    final items = response.hits.map(Product.fromJson).toList();
    final isLastPage = response.page >= response.nbPages;
    final nextPageKey = isLastPage ? null : response.page + 1;
    return HitsPage(items, response.page, nextPageKey);
  }
}










//
// import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
// import 'package:flutter/material.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
//
// import '../widgets/search_appbar.dart';
//
//
// class SearchMetadata {
//   final int nbHits;
//
//   const SearchMetadata(this.nbHits);
//
//   factory SearchMetadata.fromResponse(SearchResponse response) =>
//       SearchMetadata(response.nbHits);
// }
//
// class Product {
//   final String name;
//   final String image;
//
//   Product(this.name, this.image);
//
//   static Product fromJson(Map<String, dynamic> json) {
//     return Product(json['name'], json['image_urls'][0]);
//   }
// }
//
// class HitsPage {
//   const HitsPage(this.items, this.pageKey, this.nextPageKey);
//
//   final List<Product> items;
//   final int pageKey;
//   final int? nextPageKey;
//
//   factory HitsPage.fromResponse(SearchResponse response) {
//     final items = response.hits.map(Product.fromJson).toList();
//     final isLastPage = response.page >= response.nbPages;
//     final nextPageKey = isLastPage ? null : response.page + 1;
//     return HitsPage(items, response.page, nextPageKey);
//   }
// }
//
// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});
//
//
//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }
//
// class _SearchScreenState extends State<SearchScreen> {
//
//   final _searchTextController = TextEditingController();
//
//   final _productsSearcher = HitsSearcher(
//       applicationID: 'latency',
//       apiKey: '927c3fe76d4b52c5a2912973f35a3077',
//       indexName: 'STAGING_native_ecom_demo_products');
//
//   Stream<SearchMetadata> get _searchMetadata =>
//       _productsSearcher.responses.map(SearchMetadata.fromResponse);
//
//   final PagingController<int, Product> _pagingController =
//   PagingController(firstPageKey: 0);
//
//   Stream<HitsPage> get _searchPage =>
//       _productsSearcher.responses.map(HitsPage.fromResponse);
//
//   final GlobalKey<ScaffoldState> _mainScaffoldKey = GlobalKey();
//
//   final _filterState = FilterState();
//
//   late final _facetList = _productsSearcher.buildFacetList(
//     filterState: _filterState,
//     attribute: 'brand',
//   );
//
//   @override
//   void initState() {
//     super.initState();
//     _searchTextController.addListener(
//           () => _productsSearcher.applyState(
//             (state) => state.copyWith(
//           query: _searchTextController.text,
//           page: 0,
//         ),
//       ),
//     );
//     _searchPage.listen((page) {
//       if (page.pageKey == 0) {
//         _pagingController.refresh();
//       }
//       _pagingController.appendPage(page.items, page.nextPageKey);
//     }).onError((error) => _pagingController.error = error);
//     _pagingController.addPageRequestListener(
//             (pageKey) => _productsSearcher.applyState(
//                 (state) => state.copyWith(
//               page: pageKey,
//             )
//         )
//     );
//     _productsSearcher.connectFilterState(_filterState);
//     _filterState.filters.listen((_) => _pagingController.refresh());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBarSearch(
//           onPressed: (){
//             const SizedBox(height: 50,);
//           },
//           onTapBack: (){
//             Navigator.pop(context);
//           }),
//
//       body: Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 30,),
//               Hero(
//                 tag: "search",
//                 child: TextField(
//                   controller: _searchTextController,
//                   focusNode: _focusNode,
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: Theme.of(context).cardColor,
//                       prefixIcon: const Icon(Icons.search),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(20),
//                         borderSide: BorderSide.none,
//                       ),
//                       hintText:Locales.string(context, "search_here"),
//                       contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8), // Adjust the vertical padding as needed
//                     ),
//                 ),
//               ),
//
//             const SizedBox(height: 20,),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(15.0),
//                       child: Row(
//                         children: [
//                           Text(Locales.string(context, "have"),style: fontLarge,),
//                           Text("$list ", style: fontMediumBold,),
//                           Text(Locales.string(context, 'favorite_list'),
//                             style: fontLarge,)
//                         ],
//                       ),
//                     ),
//                     StreamBuilder<SearchMetadata>(
//                       stream: _searchMetadata,
//                       builder: (context, snapshot) {
//                         if (!snapshot.hasData) {
//                           return const SizedBox.shrink();
//                         }
//                         return Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text('${snapshot.data!.nbHits} hits'),
//                         );
//                       },
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(15.0),
//                       child: Container(
//                         height: 40,
//                         width: 100,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(100),
//                             color: Theme
//                                 .of(context)
//                                 .cardColor
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               InkWell(
//                                 onTap: showDesign1,
//                                 child: Container(
//                                   height: 24,
//                                   width: 34,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(100),
//                                     color: isDesign1 ? Colors.white : Colors
//                                         .transparent,
//                                   ),
//
//                                   child: Center(child: SvgPicture.asset(
//                                     Images.listIcon,
//                                     color: isDesign1 ? null : Colors.grey,)),
//                                 ),
//                               ),
//                               InkWell(
//                                   onTap: showDesign2,
//                                   child:
//                                   Container(
//                                     height: 24,
//                                     width: 34,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(100),
//                                       color: isDesign1
//                                           ? Colors.transparent
//                                           : Colors.white,
//                                     ),
//                                     child: Center(child: SvgPicture.asset(
//                                       Images.grideIcon, fit: BoxFit.contain,
//                                       color: isDesign1 ? null : Colors.blue,)),
//                                   ))
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 30,),
//
//
//               Center(
//                 child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   GestureDetector(
//                     // onTap: (){
//                     //   ////
//                     //   print("ooooooo");
//                     // },
//                     child: SvgPicture.asset(Images.notFound,
//                       width: 142,
//                       height: 142,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Text(Locales.string(context,
//                       "dont_found_search"),
//                     style: fontLargeBold,
//                     textAlign: TextAlign.center,
//                   ),
//
//                   const SizedBox(height: 16),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                     child: Text(Locales.string(context,
//                         "dont_found_search1"),
//                       style: fontMedium,
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ]
//             ),
//             )
//                 ]
//           ),
//         )),
//
//     );
//
//     // return Scaffold(
//     //   key: _mainScaffoldKey,
//     //   appBar: AppBar(
//     //     title: const Text('Algolia & Flutter'),
//     //     actions: [
//     //       IconButton(
//     //           onPressed: () => _mainScaffoldKey.currentState?.openEndDrawer(),
//     //           icon: const Icon(Icons.filter_list_sharp))
//     //     ],
//     //   ),
//     //   endDrawer: Drawer(
//     //     child: _filters(context),
//     //   ),
//     //   body: Center(
//     //     child: Column(
//     //       children: <Widget>[
//     //         SizedBox(
//     //             height: 44,
//     //             child: TextField(
//     //               controller: _searchTextController,
//     //               decoration: const InputDecoration(
//     //                 border: InputBorder.none,
//     //                 hintText: 'Enter a search term',
//     //                 prefixIcon: Icon(Icons.search),
//     //               ),
//     //             )),
//     //         StreamBuilder<SearchMetadata>(
//     //           stream: _searchMetadata,
//     //           builder: (context, snapshot) {
//     //             if (!snapshot.hasData) {
//     //               return const SizedBox.shrink();
//     //             }
//     //             return Padding(
//     //               padding: const EdgeInsets.all(8.0),
//     //               child: Text('${snapshot.data!.nbHits} hits'),
//     //             );
//     //           },
//     //         ),
//     //         Expanded(
//     //           child: _hits(context),
//     //         )
//     //       ],
//     //     ),
//     //   ),
//     // );
//   }
//
//   Widget _hits(BuildContext context) => PagedListView<int, Product>(
//       pagingController: _pagingController,
//       builderDelegate: PagedChildBuilderDelegate<Product>(
//           noItemsFoundIndicatorBuilder: (_) => const Center(
//             child: Text('No results found'),
//           ),
//           itemBuilder: (_, item, __) => Container(
//             color: Colors.white,
//             height: 80,
//             padding: const EdgeInsets.all(8),
//             child: Row(
//               children: [
//                 SizedBox(width: 50, child: Image.network(item.image)),
//                 const SizedBox(width: 20),
//                 Expanded(child: Text(item.name))
//               ],
//             ),
//           )));
//
//   Widget _filters(BuildContext context) => Scaffold(
//     appBar: AppBar(
//       title: const Text('Filters'),
//     ),
//     body: StreamBuilder<List<SelectableItem<Facet>>>(
//         stream: _facetList.facets,
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const SizedBox.shrink();
//           }
//           final selectableFacets = snapshot.data!;
//           return ListView.builder(
//               padding: const EdgeInsets.all(8),
//               itemCount: selectableFacets.length,
//               itemBuilder: (_, index) {
//                 final selectableFacet = selectableFacets[index];
//                 return CheckboxListTile(
//                   value: selectableFacet.isSelected,
//                   title: Text(
//                       "${selectableFacet.item.value} (${selectableFacet.item.count})"),
//                   onChanged: (_) {
//                     _facetList.toggle(selectableFacet.item.value);
//                   },
//                 );
//               });
//         }),
//   );
//
//   @override
//   void dispose() {
//     _searchTextController.dispose();
//     _productsSearcher.dispose();
//     _pagingController.dispose();
//     _filterState.dispose();
//     _facetList.dispose();
//     super.dispose();
//   }
// }
