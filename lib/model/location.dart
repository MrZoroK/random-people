import 'package:json_annotation/json_annotation.dart';
part 'location.g.dart';

@JsonSerializable()
class Location {
  String street;
  String city;
  String state;
  int postcode;

  String toString() {
    return "$street, $city, $state";
  }


  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);
    Map<String, dynamic> toJson() => _$LocationToJson(this);  
    Location(
      this.street,
      this.city,
      this.state,
      this.postcode);
}