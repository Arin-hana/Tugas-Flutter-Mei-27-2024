import 'package:json_annotation/json_annotation.dart';
//©Arin Hanabi

part 'post_model.g.dart';

@JsonSerializable()
class PostModel {
  int id;
  String name;
  int salary;
  int age;

  PostModel(
      {required this.id,
      required this.name,
      required this.salary,
      required this.age});

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
  Map<String, dynamic> toJson() => _$PostModelToJson(this);
}
