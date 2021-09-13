import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:newsapp/pages/ExplorePage.dart';
import 'package:newsapp/pages/HomePage.dart';
import 'package:newsapp/pages/UserAccount.dart';
import 'package:newsapp/pages/UserFeeds.dart';
import 'package:newsapp/tabs/bottom_tabs.dart';
import 'package:newsapp/widgets/scroll_listener.dart';

class BottomNav extends StatefulWidget {
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late final ScrollListener _model;
  late final ScrollController _controller;
  final double _bottomNavBarHeight = 56;
  late PageController _tabsPagesController;
  int _selectedTab = 0;

  // final ScrollController controller = ScrollController();
  bool visible = true;

  @override
  void initState() {
    _tabsPagesController = PageController();
    _controller = ScrollController();
    _model = ScrollListener.initialise(_controller);
    hideNavbar();
    super.initState();
  }

  @override
  void dispose() {
    _tabsPagesController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void showBottomBar() {
    setState(() {
      visible = true;
    });
  }

  void hideBottomBar() {
    setState(() {
      visible = false;
    });
  }

  hideNavbar() {
    _controller.addListener(
      () {
        print("aaaa");
        if (_controller.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if (visible) {
            visible = false;
            showBottomBar();
          }
        }

        if (_controller.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (!visible) {
            visible = true;
            hideBottomBar();
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("_bottomNavBarHeight");
    print(_bottomNavBarHeight);
    return Scaffold(
      body: AnimatedBuilder(
        animation: _model,
        builder: (context, child) {
          return Column(
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
              visible
                  ? BottomTabs(
                      selectedTab: _selectedTab,
                      tabPressed: (num) {
                        _tabsPagesController.animateToPage(
                          num,
                          duration: Duration(microseconds: 300),
                          curve: Curves.easeInCubic,
                        );
                      },
                    )
                  : Container(),
            ],
          );
        },
      ),
    );
  }
}
