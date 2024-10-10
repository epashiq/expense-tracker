import 'package:freezed_annotation/freezed_annotation.dart';
part 'expense_model.freezed.dart';
part 'expense_model.g.dart';

@freezed
class ExpenseModel with _$ExpenseModel {
  factory ExpenseModel({
    required String id,
    required String type,
    required String category,
    required double amount,
    required DateTime date,
  }) = _ExpenseModel;
  factory ExpenseModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseModelFromJson(json);
}
