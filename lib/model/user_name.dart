import 'package:json_annotation/json_annotation.dart';
part 'user_name.g.dart';

@JsonSerializable()
class UserName {
  String title;
  String first;
  String last;
  String toString() {
    return "$title. $first $last";
  }

  factory UserName.fromJson(Map<String, dynamic> json) => _$UserNameFromJson(json);
    Map<String, dynamic> toJson() => _$UserNameToJson(this);  
    UserName(
      this.title,
      this.first,
      this.last);
}