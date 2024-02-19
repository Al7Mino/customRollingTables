import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:rolling_tables/src/models/context_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'data_model.g.dart';

@JsonSerializable(explicitToJson: true)
class DataModel {
  DataModel([this._contexts = const []]) {
    if (_contexts.isEmpty) {
      _contexts = List.empty(growable: true);
    }
  }

  final String _id = UniqueKey().toString();

  /// List of contexts
  @JsonKey(includeFromJson: true, includeToJson: true)
  List<ContextModel> _contexts;

  String get id => _id;

  UnmodifiableListView<ContextModel> get contexts =>
      UnmodifiableListView(_contexts);

  void addContext(ContextModel value) {
    _contexts.add(value);
  }

  void removeContext(ContextModel value) {
    _contexts.remove(value);
  }

  factory DataModel.fromJson(Map<String, dynamic> json) =>
      _$DataModelFromJson(json);

  Map<String, dynamic> toJson() => _$DataModelToJson(this);
}
