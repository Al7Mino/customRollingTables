import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'table_entry_model.g.dart';

@JsonSerializable()
class TableEntryModel {
  TableEntryModel(
    this.name, [
    this.score = 10,
  ]);

  final String _id = UniqueKey().toString();

  /// Entry name
  String name = '';

  /// Entry score
  int score = 10;

  String get id => _id;

  factory TableEntryModel.fromJson(Map<String, dynamic> json) =>
      _$TableEntryModelFromJson(json);

  Map<String, dynamic> toJson() => _$TableEntryModelToJson(this);
}
