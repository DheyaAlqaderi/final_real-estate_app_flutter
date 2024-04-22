class AlarmModel {
  int? state;
  int? category;
  bool? isActive;
  double? maxPrice;
  double? minPrice;
  bool? forSale;
  bool? forRent;
  List<AlarmValue>? alarmValues;

  AlarmModel({
    this.state,
    this.category,
    this.isActive,
    this.maxPrice,
    this.minPrice,
    this.forSale,
    this.forRent,
    this.alarmValues,
  });

  factory AlarmModel.fromJson(Map<String, dynamic> json) {
    return AlarmModel(
      state: json['state'] as int?,
      category: json['category'] as int?,
      isActive: json['is_active'] as bool?,
      maxPrice: json['max_price'] as double?,
      minPrice: json['min_price'] as double?,
      forSale: json['for_sale'] as bool?,
      forRent: json['for_rent'] as bool?,
      alarmValues: (json['alarm_values'] as List<dynamic>?)
          ?.map((value) => AlarmValue.fromJson(value))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['state'] = state;
    data['category'] = category;
    data['is_active'] = isActive;
    data['max_price'] = maxPrice;
    data['min_price'] = minPrice;
    data['for_sale'] = forSale;
    data['for_rent'] = forRent;
    if (alarmValues != null) {
      data['alarm_values'] =
          alarmValues!.map((value) => value.toJson()).toList();
    }
    return data;
  }
}

class AlarmValue {
  int? attributeId;
  dynamic value;

  AlarmValue({
    this.attributeId,
    this.value,
  });

  factory AlarmValue.fromJson(Map<String, dynamic> json) {
    return AlarmValue(
      attributeId: json['attribute_id'] as int?,
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['attribute_id'] = attributeId;
    data['value'] = value;
    return data;
  }
}
