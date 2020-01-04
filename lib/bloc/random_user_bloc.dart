import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:random_people/bloc/bloc_provider.dart';
import 'package:random_people/model/user.dart';
import 'package:random_people/resource/cache_provider.dart';
import 'package:random_people/utils/path_provider.dart';
import 'package:random_people/utils/simple_thread.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

class RandomUserBloc extends BlocBase {
  final _randomUserPublishers = List.generate(3, (idx) => PublishSubject<User>());
  User _currentUser;
  List<User> _favoriteUsers = List();
  SimpleThread _cacheThread = SimpleThread(null);
  bool _needSaveFavoriteUsers = false;

  Observable<User> getUserObserver(int idx) {
    return _randomUserPublishers[idx].stream;
  }

  RandomUserBloc() {
    String strUsers = CacheProvider.inst.loadFavoriteUsers();
    if (strUsers != "") {
      var jsUsers = json.decode(strUsers) as List;
      if (jsUsers != null) {
        _favoriteUsers = User.fromList(jsUsers);
      }
    }

    Timer.periodic(Duration(minutes: 1), (timer){
      if (_needSaveFavoriteUsers) {
        _needSaveFavoriteUsers = false;
        _cacheThread.execute(_saveFavoriteUsers,{
          "saveDir": PathProvider.saveDir,
          "users": _favoriteUsers
        }, null);        
      }      
    });
  }

  static _saveFavoriteUsers(dynamic param, Function cb) {
    List<User> users = param["users"];
    PathProvider.saveDir = param["saveDir"];
    String strUsers = json.encode(users);
    CacheProvider.inst.saveFavoriteUsers(strUsers);
  }

  addCurrentUserToFavorite(){
    if (_currentUser == null) {
      return;
    }
    _favoriteUsers.removeWhere((user){
      return user.username == _currentUser.username;
    });
    _favoriteUsers.add(_currentUser);
    _needSaveFavoriteUsers = true;
  }

  User _fetchRandomUserFromCache() {
    User user;
    if (_favoriteUsers.length > 0) {
      do {      
        int randomNum = Random().nextInt(_favoriteUsers.length);
        user = _favoriteUsers[randomNum];
      } while(_favoriteUsers.length > 1 && user != null && _currentUser != null && user.username == _currentUser.username);
    }
    if (user != null) {
      _currentUser = user;
    } 
    return user;
  }
  fetchRandomUser() async {
    _randomUserPublishers[1].sink.add(null);
    try{
      await http.get("https://randomuser.me/api/0.4/?randomapi").then((response){
        User user;
        if (response != null && response.statusCode == 200) {
          var utf8Res = utf8.decode(response.bodyBytes);
          var jsData = json.decode(utf8Res);
          if (jsData != null) {
            var jsUsers = jsData["results"] as List;
            if (jsUsers != null && jsUsers.length > 0) {
              var jsUser = jsUsers[0];
              var jsUserInfo = jsUser["user"];
              if (jsUserInfo != null) {
                user = User.fromJson(jsUserInfo);              
              }
            }          
          }
          if (user != null) {
            _currentUser = user;
          }          
        }

        if (user == null) {
          user = _fetchRandomUserFromCache();
        }
        _randomUserPublishers[1].sink.add(user);
      });
    } catch (_) {
      var user = _fetchRandomUserFromCache();
      _randomUserPublishers[1].sink.add(user);
    }
  }

  @override
  void dispose() {
    for (var publisher in _randomUserPublishers) {
      publisher.close();
    }
  }

}