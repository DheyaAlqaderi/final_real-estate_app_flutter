import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';

/// search class
class SearchMetadata {
  final int nbHits;

  const SearchMetadata(this.nbHits);

  factory SearchMetadata.fromResponse(SearchResponse response) =>
      SearchMetadata(response.nbHits);
}