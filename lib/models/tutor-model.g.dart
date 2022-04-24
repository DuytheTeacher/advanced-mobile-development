// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tutor-model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TutorModel _$TutorModelFromJson(Map<String, dynamic> json) => TutorModel(
      level: json['level'],
      email: json['email'],
      avatar: json['avatar'],
      name: json['name'],
      country: json['country'],
      phone: json['phone'],
      language: json['language'],
      birthday: json['birthday'],
      id: json['id'],
      bio: json['bio'],
      education: json['education'],
      experience: json['experience'],
      interests: json['interests'],
      languages: json['languages'],
      price: json['price'],
      profession: json['profession'],
      specialties: json['specialties'],
      userId: json['userId'],
      video: json['video'],
      feedbacks: (json['feedbacks'] as List<dynamic>?)
          ?.map((e) => FeedBackModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TutorModelToJson(TutorModel instance) =>
    <String, dynamic>{
      'level': instance.level,
      'email': instance.email,
      'avatar': instance.avatar,
      'name': instance.name,
      'country': instance.country,
      'phone': instance.phone,
      'language': instance.language,
      'birthday': instance.birthday,
      'id': instance.id,
      'userId': instance.userId,
      'video': instance.video,
      'bio': instance.bio,
      'education': instance.education,
      'experience': instance.experience,
      'profession': instance.profession,
      'interests': instance.interests,
      'languages': instance.languages,
      'specialties': instance.specialties,
      'price': instance.price,
      'feedbacks': instance.feedbacks?.map((e) => e.toJson()).toList(),
    };
