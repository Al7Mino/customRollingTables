// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TableEntryModel _$TableEntryModelFromJson(Map<String, dynamic> json) =>
    TableEntryModel(
      json['name'] as String,
      json['score'] as int? ?? 10,
    );

Map<String, dynamic> _$TableEntryModelToJson(TableEntryModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'score': instance.score,
    };
