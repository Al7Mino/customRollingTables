// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'context_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContextModel _$ContextModelFromJson(Map<String, dynamic> json) => ContextModel(
      json['name'] as String,
      (json['_tables'] as List<dynamic>?)
              ?.map((e) => TableModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ContextModelToJson(ContextModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      '_tables': instance._tables.map((e) => e.toJson()).toList(),
    };
