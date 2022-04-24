
import 'package:advanced_mobile_dev/models/user-model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'feedback-model.g.dart';

@JsonSerializable(explicitToJson: true)
class FeedBackModel {
  var id, bookingId, firstId, secondId, rating, content, createdAt;
  late UserModel firstInfo;

  FeedBackModel({
    required this.id,
    required this.bookingId,
    required this.content,
    required this.createdAt,
    required this.firstId,
    required this.firstInfo,
    required this.rating,
    required this.secondId
});

  factory FeedBackModel.fromJson(Map<String, dynamic> data) =>
      _$FeedBackModelFromJson(data);

  Map<String, dynamic> toJson() => _$FeedBackModelToJson(this);
}