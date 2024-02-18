import 'package:flutter/material.dart';

class ContextModel {
  final String _id = UniqueKey().toString();

  /// Context name
  String name = '';

  /// List of tables
  late List<String> tables = [];

  String get id => _id;
}
