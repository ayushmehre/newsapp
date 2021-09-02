import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrious_createrapp/utils/colors.dart';

class BottomTabs extends StatefulWidget {
  final int selectedTab;
  final Function(int) tabPressed;
  BottomTabs({required this.selectedTab, required this.tabPressed});

  @override
  _BottomTabsState createState() => _BottomTabsState();
}

class _BottomTabsState extends State<BottomTabs> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    _selectedTab = widget.selectedTab;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1.0,
            blurRadius: 30.0,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BottomTabBtn(
            imagePath: Icons.trending_up,
            selected: _selectedTab == 0 ? true : false,
            onPressed: () {
              widget.tabPressed(0);
            },
          ),
          BottomTabBtn(
            imagePath: Icons.person,
            selected: _selectedTab == 1 ? true : false,
            onPressed: () {
              widget.tabPressed(1);
            },
          ),
          BottomTabBtn(
            imagePath: Icons.explore,
            selected: _selectedTab == 2 ? true : false,
            onPressed: () {
              widget.tabPressed(2);
            },
          ),
          BottomTabBtn(
            imagePath: Icons.more_vert,
            selected: _selectedTab == 3 ? true : false,
            onPressed: () {
              widget.tabPressed(3);
            },
          ),
          // BottomTabBtn(
          //   imagePath: "assets/search.svg",
          //   selected: _selectedTab == 4 ? true : false,
          //   onPressed: () {
          //     widget.tabPressed(4);
          //   },
          // ),
        ],
      ),
    );
  }
}

class BottomTabBtn extends StatelessWidget {
  final IconData imagePath;
  final bool selected;
  final Function onPressed;
  BottomTabBtn({
    required this.imagePath,
    required this.selected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    bool _selected = selected;

    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: _selected
                  ? Theme.of(context).accentColor
                  : Colors.transparent,
              width: 2.0,
            ),
          ),
        ),
        child: Icon(imagePath, size: 30, color: black),
        // child: Image(
        //   image: AssetImage(imagePath),
        //   width: 26,
        //   height: 26,
        //   // color: _selected ? Theme.of(context).accentColor : Colors.black,
        // ),
      ),
    );
  }
}
