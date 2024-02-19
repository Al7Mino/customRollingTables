import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:rolling_tables/src/models/table_entry_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'table_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TableModel {
  TableModel(this.name, [this._entries = const []]) {
    if (_entries.isEmpty) {
      _entries = List.empty(growable: true);
    }
  }

  final String _id = UniqueKey().toString();

  /// Table name
  String name = '';

  /// List of entries
  @JsonKey(includeFromJson: true, includeToJson: true)
  List<TableEntryModel> _entries = [];

  String get id => _id;

  UnmodifiableListView<TableEntryModel> get entries =>
      UnmodifiableListView(_entries);

  void addTableEntry(TableEntryModel value) {
    _entries.add(value);
  }

  void removeTableEntry(TableEntryModel value) {
    _entries.remove(value);
  }

  factory TableModel.fromJson(Map<String, dynamic> json) =>
      _$TableModelFromJson(json);

  Map<String, dynamic> toJson() => _$TableModelToJson(this);
}
