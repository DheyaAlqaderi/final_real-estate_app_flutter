class AlarmModel {
  final List<AlarmValue> alarmValues;
  final bool isActive;
  final String maxPrice;
  final String minPrice;
  final bool forSale;
  final bool forRent;
  final int state;
  final int category;

  AlarmModel({
    required this.alarmValues,
    required this.isActive,
    required this.maxPrice,
    required this.minPrice,
    required this.forSale,
    required this.forRent,
    required this.state,
    required this.category,
  });

  factory AlarmModel.fromJson(Map<String, dynamic> json) {
    var alarmValuesList = json['alarm_values'] as List<dynamic>;
    List<AlarmValue> alarmValues =
    alarmValuesList.map((e) => AlarmValue.fromJson(e)).toList();

    return AlarmModel(
      alarmValues: alarmValues,
      isActive: json['is_active'],
      maxPrice: json['max_price'],
      minPrice: json['min_price'],
      forSale: json['for_sale'],
      forRent: json['for_rent'],
      state: json['state'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'alarm_values': alarmValues.map((value) => value.toJson()).toList(),
      'is_active': isActive,
      'max_price': maxPrice,
      'min_price': minPrice,
      'for_sale': forSale,
      'for_rent': forRent,
      'state': state,
      'category': category,
    };
  }
}

class AlarmValue {
  final int attributeId;
  final String value;

  AlarmValue({
    required this.attributeId,
    required this.value,
  });

  factory AlarmValue.fromJson(Map<String, dynamic> json) {
    return AlarmValue(
      attributeId: json['attribute_id'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attribute_id': attributeId,
      'value': value,
    };
  }
}

