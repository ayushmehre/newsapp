import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/pages/ExplorePage.dart';
import 'package:newsapp/pages/HomePage.dart';
import 'package:newsapp/pages/UserAccount.dart';
import 'package:newsapp/pages/UserFeeds.dart';
import 'package:newsapp/tabs/bottom_tabs.dart';

class BottomNav extends StatefulWidget {
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late PageController _tabsPagesController;
  int _selectedTab = 0;

  @override
  void initState() {
    _tabsPagesController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _tabsPagesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: PageView(
            physics: new NeverScrollableScrollPhysics(),
            controller: _tabsPagesController,
            onPageChanged: (num) {
              setState(() {
                _selectedTab = num;
              });
            },
            children: [
              HomeScreen(),
              UserFeeds(),
              ExploreScreen(),
              UserAccount(),
            ],
          ),
        ),
        BottomTabs(
          selectedTab: _selectedTab,
          tabPressed: (num) {
            _tabsPagesController.animateToPage(
              num,
              duration: Duration(microseconds: 300),
              curve: Curves.easeInCubic,
            );
          },
        )
      ],
    ));
  }
}
