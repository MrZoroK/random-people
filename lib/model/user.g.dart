// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['gender'] as String,
    json['name'] == null
        ? null
        : UserName.fromJson(json['name'] as Map<String, dynamic>),
    json['location'] == null
        ? null
        : Location.fromJson(json['location'] as Map<String, dynamic>),
    json['email'] as String,
    json['username'] as String,
    json['password'] as String,
    json['salt'] as String,
    json['dob'] as String,
    json['phone'] as String,
    json['cell'] as String,
    json['picture'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'gender': instance.gender,
      'name': instance.name?.toJson(),
      'location': instance.location?.toJson(),
      'email': instance.email,
      'username': instance.username,
      'password': instance.password,
      'salt': instance.salt,
      'dob': instance.dob,
      'phone': instance.phone,
      'cell': instance.cell,
      'picture': instance.picture,
    };
