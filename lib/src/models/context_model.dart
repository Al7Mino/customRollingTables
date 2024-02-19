import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:rolling_tables/src/models/table_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'context_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ContextModel {
  ContextModel(this.name, [this._tables = const []]) {
    if (_tables.isEmpty) {
      _tables = List.empty(growable: true);
    }
  }

  final String _id = UniqueKey().toString();

  /// Context name
  String name = '';

  /// List of tables
  @JsonKey(includeFromJson: true, includeToJson: true)
  List<TableModel> _tables;

  String get id => _id;

  UnmodifiableListView<TableModel> get tables => UnmodifiableListView(_tables);

  void addTable(TableModel value) {
    _tables.add(value);
  }

  void removeTable(TableModel value) {
    _tables.remove(value);
  }

  factory ContextModel.fromJson(Map<String, dynamic> json) =>
      _$ContextModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContextModelToJson(this);
}
