import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavbarScrollHide extends StatefulWidget {
  @override
  State<NavbarScrollHide> createState() => _NavbarScrollHideState();
}

class _NavbarScrollHideState extends State<NavbarScrollHide> {
  late final ScrollListener _model;
  late final ScrollController _controller;
  final double _bottomNavBarHeight = 56;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _model = ScrollListener.initialise(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _model,
        builder: (context, child) {
          return Stack(
            children: [
              ListView.builder(
                controller: _controller,
                itemCount: 20,
                itemBuilder: (_, i) => ListTile(title: Text('Item $i')),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: _model.bottom,
                child: _bottomNavBar,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget get _bottomNavBar {
    return SizedBox(
      height: _bottomNavBarHeight,
      child: BottomNavigationBar(
        backgroundColor: Colors.amber,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.call), label: 'Call'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Message'),
        ],
      ),
    );
  }
}

class ScrollListener extends ChangeNotifier {
  double bottom = 0;
  double _last = 0;

  ScrollListener.initialise(ScrollController controller, [double height = 56]) {
    controller.addListener(() {
      final current = controller.offset;
      bottom += _last - current;
      if (bottom <= -height) bottom = -height;
      if (bottom >= 0) bottom = 0;
      _last = current;
      if (bottom <= 0 && bottom >= -height) notifyListeners();
    });
  }
}