// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'option_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OptionItemModel _$OptionItemModelFromJson(Map<String, dynamic> json) =>
    OptionItemModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      score: (json['score'] as num?)?.toInt() ?? 10,
      isLocked: json['isLocked'] as bool? ?? false,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      tableId: (json['tableId'] as num).toInt(),
    );

Map<String, dynamic> _$OptionItemModelToJson(OptionItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'score': instance.score,
      'isLocked': instance.isLocked,
      'sortOrder': instance.sortOrder,
      'tableId': instance.tableId,
    };
