class ResponseCreateAlarm {
  int? id;
  bool? isActive;
  String? timeCreated;
  String? timeUpdated;
  String? maxPrice;
  String? minPrice;
  bool? forSale;
  bool? forRent;
  int? state;
  int? category;
  List<int>? value;

  ResponseCreateAlarm({
    this.id,
    this.isActive,
    this.timeCreated,
    this.timeUpdated,
    this.maxPrice,
    this.minPrice,
    this.forSale,
    this.forRent,
    this.state,
    this.category,
    this.value,
  });

  factory ResponseCreateAlarm.fromJson(Map<String, dynamic> json) {
    return ResponseCreateAlarm(
      id: json['id'],
      isActive: json['is_active'],
      timeCreated: json['time_created'],
      timeUpdated: json['time_updated'],
      maxPrice: json['max_price'],
      minPrice: json['min_price'],
      forSale: json['for_sale'],
      forRent: json['for_rent'],
      state: json['state'],
      category: json['category'],
      value: json['value'] != null ? List<int>.from(json['value']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'is_active': isActive,
      'time_created': timeCreated,
      'time_updated': timeUpdated,
      'max_price': maxPrice,
      'min_price': minPrice,
      'for_sale': forSale,
      'for_rent': forRent,
      'state': state,
      'category': category,
      'value': value,
    };
  }
}
