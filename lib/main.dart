import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:random_people/bloc/bloc_provider.dart';
import 'package:random_people/bloc/random_user_bloc.dart';
import 'package:random_people/utils/path_provider.dart';

import 'screen/main_page.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]).then((_) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) async {
      await PathProvider.init();
      runApp(MyApp());
    });    
  });  
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random People App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        child: MainPage(),
        bloc: RandomUserBloc(),
      ),
    );
  }
}
