import 'package:json_annotation/json_annotation.dart';

part 'user-model.g.dart';

@JsonSerializable()
class UserModel {
  var id, email, name, avatar, country, phone, language, birthday;
  var avgRating;
  var roles;
  var isActivated;
  var feedbacks;
  var courses;

  UserModel(
      {required this.id,
      required this.email,
      required this.name,
      required this.avatar,
      required this.country,
      required this.phone,
      required this.language,
      required this.birthday,
      required this.avgRating,
      required this.feedbacks,
      required this.courses,
      required this.isActivated,
      required this.roles});

  factory UserModel.fromJson(Map<String, dynamic> data) =>
      _$UserModelFromJson(data);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
