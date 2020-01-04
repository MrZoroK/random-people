import 'package:json_annotation/json_annotation.dart';
import 'package:random_people/model/location.dart';
import 'package:random_people/model/user_name.dart';
part 'user.g.dart';


@JsonSerializable(explicitToJson: true)
class User {
    String gender;
    UserName name;
    Location location;
    String email;
    String username;
    String password;
    String salt;  
    String dob;
    String phone;
    String cell;
    String picture;

    String getDayOfBirth(){
      int mlsecond = int.parse(dob);
      var dt = DateTime.fromMillisecondsSinceEpoch(mlsecond * 1000);
      String year = dt.year.toString();
      String month = dt.month.toString();
      String day = dt.day.toString();
      return "$year-$month-$day";
    }

    factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
    static List<User> fromList(List<dynamic> list) {
      var listUser = List<User>();
      for (var jsUser in list) {
        listUser.add(User.fromJson(jsUser));
      }
      return listUser;
    }
    
    Map<String, dynamic> toJson() => _$UserToJson(this);  
    User(
      this.gender,
      this.name,
      this.location,
      this.email,
      this.username,
      this.password,
      this.salt,
      this.dob,
      this.phone,
      this.cell,
      this.picture);
}