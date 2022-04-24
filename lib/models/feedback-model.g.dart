// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback-model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedBackModel _$FeedBackModelFromJson(Map<String, dynamic> json) =>
    FeedBackModel(
      id: json['id'],
      bookingId: json['bookingId'],
      content: json['content'],
      createdAt: json['createdAt'],
      firstId: json['firstId'],
      firstInfo: UserModel.fromJson(json['firstInfo'] as Map<String, dynamic>),
      rating: json['rating'],
      secondId: json['secondId'],
    );

Map<String, dynamic> _$FeedBackModelToJson(FeedBackModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bookingId': instance.bookingId,
      'firstId': instance.firstId,
      'secondId': instance.secondId,
      'rating': instance.rating,
      'content': instance.content,
      'createdAt': instance.createdAt,
      'firstInfo': instance.firstInfo.toJson(),
    };
