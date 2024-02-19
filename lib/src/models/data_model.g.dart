// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataModel _$DataModelFromJson(Map<String, dynamic> json) => DataModel(
      (json['_contexts'] as List<dynamic>?)
              ?.map((e) => ContextModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$DataModelToJson(DataModel instance) => <String, dynamic>{
      '_contexts': instance._contexts.map((e) => e.toJson()).toList(),
    };
