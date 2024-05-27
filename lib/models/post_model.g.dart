// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostModel _$PostModelFromJson(Map<String, dynamic> json) => PostModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      salary: (json['salary'] as num).toInt(),
      age: (json['age'] as num).toInt(),
    );

Map<String, dynamic> _$PostModelToJson(PostModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'salary': instance.salary,
      'age': instance.age,
    };
