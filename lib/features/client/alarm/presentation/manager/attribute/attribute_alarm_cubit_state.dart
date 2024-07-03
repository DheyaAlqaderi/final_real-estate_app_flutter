import 'package:equatable/equatable.dart';

import '../../../data/models/attribute_alarm_model.dart';

abstract class AttributeAlarmState extends Equatable {
  const AttributeAlarmState();

  @override
  List<Object?> get props => [];
}

class AttributeAlarmInitial extends AttributeAlarmState {}

class AttributeAlarmLoading extends AttributeAlarmState {}

class AttributeAlarmLoaded extends AttributeAlarmState {
  final List<AttributesAlarmModel> attributes;

  const AttributeAlarmLoaded(this.attributes);

  @override
  List<Object?> get props => [attributes];
}

class AttributeAlarmFailure extends AttributeAlarmState {
  final String error;

  const AttributeAlarmFailure(this.error);

  @override
  List<Object?> get props => [error];
}
