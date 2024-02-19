// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TableModel _$TableModelFromJson(Map<String, dynamic> json) => TableModel(
      json['name'] as String,
      (json['_entries'] as List<dynamic>?)
              ?.map((e) => TableEntryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$TableModelToJson(TableModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      '_entries': instance._entries.map((e) => e.toJson()).toList(),
    };
