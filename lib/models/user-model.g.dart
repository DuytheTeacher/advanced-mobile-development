// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user-model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      avatar: json['avatar'],
      country: json['country'],
      phone: json['phone'],
      language: json['language'],
      birthday: json['birthday'],
      avgRating: json['avgRating'],
      feedbacks: json['feedbacks'],
      courses: json['courses'],
      isActivated: json['isActivated'],
      roles: json['roles'],
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'avatar': instance.avatar,
      'country': instance.country,
      'phone': instance.phone,
      'language': instance.language,
      'birthday': instance.birthday,
      'avgRating': instance.avgRating,
      'roles': instance.roles,
      'isActivated': instance.isActivated,
      'feedbacks': instance.feedbacks,
      'courses': instance.courses,
    };
