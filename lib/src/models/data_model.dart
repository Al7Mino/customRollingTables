import 'package:flutter/material.dart';

class DataModel {
  final String _id = UniqueKey().toString();

  /// List of contexts
  late List<String> contexts = [];

  String get id => _id;
}
