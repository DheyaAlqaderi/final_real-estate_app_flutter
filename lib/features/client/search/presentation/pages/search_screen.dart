import 'dart:convert';

import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:smart_real_estate/core/constant/app_constants.dart';
import 'package:smart_real_estate/core/helper/local_data/shared_pref.dart';
import 'package:smart_real_estate/core/helper/my_model_map.dart';
import 'package:smart_real_estate/features/client/filter_screen/presentation/pages/filter_screen.dart';
import 'package:smart_real_estate/features/client/search/presentation/widgets/search_appbar.dart';

import '../../../../../core/utils/images.dart';
import '../../../../../core/utils/styles.dart';
import '../../domain/search_meta_data.dart';
import '../widgets/list_property_widget.dart';



class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
   final int list=0;
   late FocusNode _focusNode;
   String? token;


   /// algolia setup
   final _searchTextController = TextEditingController();
   final _productsSearcher = HitsSearcher(
       applicationID: 'K5HRMSGJI4',
       apiKey: '67e7c4435e6254c743056eb62f612305',
       indexName: 'property_index');

   Stream<SearchMetadata> get _searchMetadata =>
       _productsSearcher.responses.map(SearchMetadata.fromResponse);

   final PagingController<int, MyModel> _pagingController =
   PagingController(firstPageKey: 0);

   Stream<HitsPage> get _searchPage =>
       _productsSearcher.responses.map(HitsPage.fromResponse);

   final GlobalKey<ScaffoldState> _mainScaffoldKey = GlobalKey();

   final _filterState = FilterState();

   late final _facetList = _productsSearcher.buildFacetList(
     filterState: _filterState,
     attribute: 'brand',
   );

   Future<void> fetchToken()async{
     final mToken = await SharedPrefManager.getData(AppConstants.token);
     setState(() {
       token = mToken;
     });
   }
   @override
   void initState() {
     super.initState();
     _focusNode = FocusNode();
     // Request focus when the widget is built
     WidgetsBinding.instance.addPostFrameCallback((_) {
       FocusScope.of(context).requestFocus(_focusNode);
     });

     fetchToken();


     Widget _hits(BuildContext context) => PagedListView<int, MyModel>(
         pagingController: _pagingController,
         builderDelegate: PagedChildBuilderDelegate<MyModel>(
             noItemsFoundIndicatorBuilder: (_) => const Center(
               child: Text('No results found'),
             ),
             itemBuilder: (_, item, __) => Container(
               color: Colors.white,
               height: 80,
               padding: const EdgeInsets.all(8),
               child: Row(
                 children: [
                   // SizedBox(width: 50, child: Image.network(item)),
                   const SizedBox(width: 20),
                   Expanded(child: Text(jsonDecode(item.toString())))
                 ],
               ),
             )));

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

   Widget _hits(BuildContext context) => PagedListView<int, MyModel>(
       pagingController: _pagingController,
       builderDelegate: PagedChildBuilderDelegate<MyModel>(
           noItemsFoundIndicatorBuilder: (_) => const Center(
             child: Text('No results found'),
           ),
           itemBuilder: (_, item, __) => Container(
             color: Colors.white,
             height: 150,
             padding: const EdgeInsets.all(8),
             child: ListPropertyWidget(address: item.data['address'],image: item.data['image_url'],name: item.data['name'],price: item.data['price'],rate: item.data['data_serializers']['rate_review'],id: item.data['id'],token: token,)
           )
       )
   );

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
                      StreamBuilder<SearchMetadata>(
                                  stream: _searchMetadata,
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const SizedBox.shrink();
                                    }
                                    return Wrap(
                                      children: [
                                        Text(Locales.string(context, "have"), style: fontLarge,),
                                        Text(" ${snapshot.data!.nbHits} ", style: fontMediumBold,),
                                        Text(Locales.string(context, 'favorite_list'),
                                          style: fontLarge,)
                                      ],
                                    );
                                  },
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
            const SizedBox(height: 10,),
            Expanded(child: _hits(context))
          ],
        ),
      )


    );
  }

}


class HitsPage {
  const HitsPage(this.items, this.pageKey, this.nextPageKey);

  final List<MyModel> items;
  final int pageKey;
  final int? nextPageKey;

  factory HitsPage.fromResponse(SearchResponse response) {
    final items = response.hits.map(MyModel.fromJson).toList();
    final isLastPage = response.page >= response.nbPages;
    final nextPageKey = isLastPage ? null : response.page + 1;
    return HitsPage(items, response.page, nextPageKey);
  }
}