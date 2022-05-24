import 'package:advanced_mobile_dev/models/feedback-model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tutor-model.g.dart';

@JsonSerializable(explicitToJson: true)
class TutorModel {
  var level, email, avatar, name, country, phone, language, birthday, id, userId, video, bio, education, experience, profession, interests, languages, specialties, price;
  List<FeedBackModel>? feedbacks = [];

  TutorModel({
    required this.level,
    required this.email,
    required this.avatar,
    required this.name,
    required this.country,
    required this.phone,
    required this.language,
    required this.birthday,
    required this.id,
    required this.bio,
    required this.education,
    required this.experience,
    required this.interests,
    required this.languages,
    required this.price,
    required this.profession,
    required this.specialties,
    required this.userId,
    required this.video,
    required this.feedbacks
});

  factory TutorModel.fromJson(Map<String, dynamic> data) =>
      _$TutorModelFromJson(data);

  Map<String, dynamic> toJson() => _$TutorModelToJson(this);
}
