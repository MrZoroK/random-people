import 'package:flutter/material.dart';
import 'package:random_people/model/user.dart';
import 'package:random_people/widget/common_widget_builder.dart';
import 'package:rxdart/rxdart.dart';
import 'package:random_people/utils/string_ext.dart';

enum UserInfoTab {
  BASIC,
  BIRTHDAY,
  LOCATION,
  PHONE,
  LOGIN
}

extension UserInfoTabExt on UserInfoTab {
  IconData icon() {
    if (this == UserInfoTab.BASIC) {
      return Icons.person;
    } else if (this == UserInfoTab.BIRTHDAY) {
      return Icons.assignment;
    } else if (this == UserInfoTab.LOCATION) {
      return Icons.map;
    } else if (this == UserInfoTab.PHONE) {
      return Icons.phone;
    } else if (this == UserInfoTab.LOGIN) {
      return Icons.lock;
    }
    return null;
  }
}

class UserInfoCard extends StatefulWidget {
  const UserInfoCard({
    @required this.stream,
    @required this.width,
    @required this.height,
    this.isPlaceHolder = true,
    this.tabController,
  });
  final double width;
  final double height;
  final bool isPlaceHolder;
  final Observable<User> stream;
  final TabController tabController;

  @override
  _UserInfoCardState createState() => _UserInfoCardState();
}

class _UserInfoCardState extends State<UserInfoCard>  with TickerProviderStateMixin {

  TabController _tabController;

  Widget _cardHeader(double height) {
    return Container(
      height: height,                  
      decoration: BoxDecoration(
        color: Color(0xfff9f9f9),
        border: BorderDirectional(
          bottom: BorderSide(
            color: Color(0xffdddddd),
            width: 2
          )
        )
      ),                  
    );
  }

  Widget _avatar(String avatarUrl, double size, bool isPlaceHolder) {
    Widget _avatarRoundImage;
    if (avatarUrl == null) {
      Widget placeHolder;
      if (!isPlaceHolder) {
        placeHolder = Center(child: CircularProgressIndicator());
      } else {
        placeHolder = Image(
          image: AssetImage('assets/ano_avatar.png'),
          fit: BoxFit.contain,
        );
      }
      _avatarRoundImage = ClipRRect(
        borderRadius: BorderRadius.circular(size),
        child: placeHolder,
      );
    } else {
      _avatarRoundImage = ClipRRect(
        borderRadius: BorderRadius.circular(size),
        child: CommonWidgetBuilder.loadNetworkImage(avatarUrl, width: size, height: size, linearProcess: false),
      );      
    }

    return Container(
        padding: EdgeInsets.all(5),
        width: size, height: size,
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xffcccccc), width: 2),
          borderRadius: BorderRadius.circular(size),
          color: Colors.white
        ),
        child: _avatarRoundImage
      );
  }

  Widget _buildUserInfoTabView(UserInfoTab tab, User user) {
    if (user == null) {
      return Container();
    }
    String title = "";
    String content = "";
    switch(tab) {
      case UserInfoTab.BASIC:
      {
        title = "My name is";
        content = user.name.toString().titleCase;
        break;
      }
      case UserInfoTab.BIRTHDAY:
      {
        title = "My birthday was on";
        content = user.getDayOfBirth();
        break;
      }
      case UserInfoTab.LOCATION:
      {
        title = "My address is";
        content = user.location.toString().titleCase;
        break;
      }
      case UserInfoTab.PHONE:
      {
        title = "My phone number is";
        content = user.phone;
        break;
      }
      case UserInfoTab.LOGIN:
      {
        title = "My username is";
        content = user.username;
        break;
      }
      default: 
        break;
    }

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(color: Colors.grey, fontSize: 20),
          ),
          Text(
            content,
            style: TextStyle(color: Colors.black, fontSize: 30),
          )
        ],
      ),
    );    
  }

  Widget _buildUserInfoTabs() {
    double tabIconSize = 35;
    double tabIconPadding = 5;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AnimatedBuilder(
          animation: _tabController.animation,
          builder: (context, widget){
            double tabSize = tabIconSize + tabIconPadding * 2;
            double animOffset = tabSize * _tabController.animation.value + tabIconPadding;
            return Container(
              margin: EdgeInsets.only(left: animOffset),
              child: widget,
            );
          },
          child: Image(
            image: AssetImage('assets/Indicator.png'),
            width: tabIconSize,
          )
        ),
        TabBar(
          isScrollable: true,
          tabs: UserInfoTab.values.map((tab){
            return Icon(
              tab.icon(),
              size: tabIconSize,
            );
          }).toList(),
          indicatorPadding: EdgeInsets.all(0),
          indicatorSize: TabBarIndicatorSize.tab,
          labelPadding: EdgeInsets.only(left: tabIconPadding, right: tabIconPadding),
          labelColor: Color(0xff8eb559),
          unselectedLabelColor: Color(0xffdadada),
          indicatorColor: Color(0xff8eb559),
          indicator: BoxDecoration(
            border: Border()
          ),
          controller: _tabController,
        )
      ],
    );
  }

  Widget _cardBody(User user) {
    if (_tabController == null) {
      if (widget.tabController != null) {
        _tabController = widget.tabController;
      } else {
        _tabController = TabController(length: UserInfoTab.values.length, vsync: this);
      }      
    }

    return Container(
      margin: EdgeInsets.only(top: 60, left: 15, right: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: UserInfoTab.values.map((tab){
                return _buildUserInfoTabView(tab, user);
              }).toList()
            )
          ),        
          Container(
            margin: EdgeInsets.only(bottom: 15),
            child: _buildUserInfoTabs()
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double cardHeaderHeight = widget.height * 0.36;
    double avatarSize = cardHeaderHeight + 30;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      child: Container(
        child: StreamBuilder(
          stream: widget.stream,
          builder: (context, snapshot){
            User user = snapshot.data;
            Widget avatar = _avatar(user == null ? null : user.picture, avatarSize, widget.isPlaceHolder);
            return Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    _cardHeader(cardHeaderHeight),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: _cardBody(user),
                      ),
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: EdgeInsets.only(top: 30),
                    child: avatar,
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}