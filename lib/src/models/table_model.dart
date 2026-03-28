import 'package:json_annotation/json_annotation.dart';

part 'table_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TableModel {
  int? id;

  /// Table name
  String name = '';

  TableModel({
    this.id,
    required this.name,
  });

  TableModel copyWith({
    int? id,
    String? name,
  }) {
    return TableModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory TableModel.fromMap(Map<String, dynamic> map) {
    return TableModel(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }

  factory TableModel.fromJson(Map<String, dynamic> json) =>
      _$TableModelFromJson(json);

  Map<String, dynamic> toJson() => _$TableModelToJson(this);
}
