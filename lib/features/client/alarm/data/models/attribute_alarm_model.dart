class AttributesAlarmModel {
  int? id;
  List<ValueAttributeModel>? valueAttribute;
  String? name;
  String? dataType;
  List<int>? category;

  AttributesAlarmModel({this.id, this.valueAttribute, this.name, this.dataType, this.category});

  factory AttributesAlarmModel.fromJson(Map<String, dynamic> json) {
    return AttributesAlarmModel(
      id: json['id'],
      valueAttribute: json['value_attribute'] != null
          ? (json['value_attribute'] as List)
          .map((item) => ValueAttributeModel.fromJson(item))
          .toList()
          : null,
      name: json['name'],
      dataType: json['data_type'],
      category: json['category'] != null ? List<int>.from(json['category']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value_attribute': valueAttribute?.map((item) => item.toJson()).toList(),
      // 'value_attribute': valueAttribute != null
      //     ? valueAttribute!.map((item) => item.toJson()).toList()
      //     : null,
      'name': name,
      'data_type': dataType,
      'category': category,
    };
  }
}

class ValueAttributeModel {
  int? id;
  String? value;
  int? attribute;

  ValueAttributeModel({this.id, this.value, this.attribute});

  factory ValueAttributeModel.fromJson(Map<String, dynamic> json) {
    return ValueAttributeModel(
      id: json['id'],
      value: json['value'],
      attribute: json['attribute'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
      'attribute': attribute,
    };
  }
}
