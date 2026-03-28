import 'package:json_annotation/json_annotation.dart';

part 'option_item_model.g.dart';

@JsonSerializable()
class OptionItemModel {
  int? id;

  /// Entry name
  String name = '';

  /// Entry score
  int score = 10;

  bool isLocked = false;

  int sortOrder = 0;

  int tableId;

  OptionItemModel({
    this.id,
    required this.name,
    this.score = 10,
    this.isLocked = false,
    this.sortOrder = 0,
    required this.tableId,
  });

  OptionItemModel copyWith({
    int? id,
    String? name,
    int? score,
    bool? isLocked,
    int? sortOrder,
    int? tableId,
  }) {
    return OptionItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      score: score ?? this.score,
      isLocked: isLocked ?? this.isLocked,
      sortOrder: sortOrder ?? this.sortOrder,
      tableId: tableId ?? this.tableId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'score': score,
      'is_locked': isLocked ? 1 : 0,
      'sort_order': sortOrder,
      'table_id': tableId,
    };
  }

  factory OptionItemModel.fromMap(Map<String, dynamic> map) {
    return OptionItemModel(
      id: map['id'],
      name: map['name'],
      score: map['score'] ?? 10,
      isLocked: map['is_locked'] == 1 ? true : false,
      sortOrder: map['sort_order'] ?? 0,
      tableId: map['table_id'],
    );
  }

  factory OptionItemModel.fromJson(Map<String, dynamic> json) =>
      _$OptionItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$OptionItemModelToJson(this);
}
