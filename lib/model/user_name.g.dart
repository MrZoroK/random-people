// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_name.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserName _$UserNameFromJson(Map<String, dynamic> json) {
  return UserName(
    json['title'] as String,
    json['first'] as String,
    json['last'] as String,
  );
}

Map<String, dynamic> _$UserNameToJson(UserName instance) => <String, dynamic>{
      'title': instance.title,
      'first': instance.first,
      'last': instance.last,
    };
