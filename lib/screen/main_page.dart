import 'package:flutter/material.dart';
import 'package:random_people/bloc/bloc_provider.dart';
import 'package:random_people/bloc/random_user_bloc.dart';
import 'package:random_people/widget/user_info_card.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin{
  
  TabController _tabController;
  RandomUserBloc _bloc;
  PageController _pageController;

  Widget _background() {
    return Column(
      children: <Widget>[
        Container(
          height: 180,
          color: Color(0xff2d2e32),
        ),
        Expanded(
          child: Container(
            color: Color(0xfff9f9f9),
          ),
        )
      ],
    );
  }  
  
  Widget _carouselOfRandomPeople(BuildContext context) {
    double cardMargin = 10.0;
    double cardWidth = MediaQuery.of(context).size.width - 2 * cardMargin;
    double cardHeight = cardWidth * 1.05;
    RandomUserBloc bloc = BlocProvider.of(context);   


    return Container(
      margin: EdgeInsets.only(top: 40),
      height: cardHeight,
      child: PageView.builder(        
        scrollDirection: Axis.horizontal,
        controller: _pageController,
        itemCount: 3,
        itemBuilder: (context, pos){
          return Container(
            margin: EdgeInsets.only(left: cardMargin, right: cardMargin),
            child: UserInfoCard(
              stream: bloc.getUserObserver(pos),
              tabController: _tabController,
              width: cardWidth, height: cardHeight,
              isPlaceHolder: pos == 1 ? false: true)
          );
        },
      ),
    );
  }

  @override
  void initState() {
    _bloc = BlocProvider.of(context);

    if (_pageController == null) {
      _pageController = PageController(initialPage: 1, viewportFraction: 1.0); 
      _pageController.addListener((){      
        if (_pageController.position.haveDimensions) {
          double pageNo = _pageController.page;
          if (pageNo == 0.0 || pageNo == 2.0) {
            _pageController.jumpToPage(1);
            if (pageNo == 0.0) {
              _bloc.addCurrentUserToFavorite();
            }
            _bloc.fetchRandomUser();
          }
        }      
      });
    }

    if(_tabController == null) {
      _tabController = TabController(length: UserInfoTab.values.length, vsync: this, initialIndex: 0);
    }
    
    _bloc.fetchRandomUser();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _background(),
          Align(
            alignment: Alignment.topCenter,
            child: SafeArea(
              top: true,
              child: _carouselOfRandomPeople(context),
            )
          )
        ],
      ),
    );
  }
}

