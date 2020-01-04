import 'dart:io';

import 'package:random_people/utils/path_provider.dart';

class CacheProvider {
  static const _FAVORITE_USER_PATH = "cached/favorite_users.json";
  factory CacheProvider() {
    if (_this == null) {
      _this = CacheProvider._();
    }
    return _this;
  }
  CacheProvider._();
  static CacheProvider _this;
  static CacheProvider get inst => CacheProvider();

  
  String _loadCachedJson(String fileName) {
    var filepath = PathProvider.saveDir + '/$fileName';
    var file = File(filepath);
    if (file.existsSync())
    {
      return file.readAsStringSync();
    }
    return "";   
  }
  _saveJson(String fileName, String json) async {
    if (PathProvider.saveDir == null) {
      await PathProvider.init();
    }
    var filepath = PathProvider.saveDir + '/$fileName';
    var file = File(filepath);
    if (!file.existsSync())
      file.createSync(recursive: true);
    file.writeAsStringSync(json);    
  }


  String loadFavoriteUsers() => _loadCachedJson(_FAVORITE_USER_PATH);
  saveFavoriteUsers(String json) => _saveJson(_FAVORITE_USER_PATH, json);
}