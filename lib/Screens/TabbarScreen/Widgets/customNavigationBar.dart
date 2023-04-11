import 'package:flutter/material.dart';
import 'package:flutter_app/Resources/ColorConst.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int defaultSelectedIndex;
  final Function(int) onChange;
  final List<String> iconList;
  final List<String> iconListFill;
  final List<String> iconTitle;

  CustomBottomNavigationBar(
      {this.defaultSelectedIndex = 0,
      @required this.iconList,
      @required this.iconListFill,
      @required this.iconTitle,
      @required this.onChange});

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;
  List<String> _iconList = [];

  ScreenUtil screenUtil = ScreenUtil();

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.defaultSelectedIndex;
    _iconList = widget.iconList;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _navBarItemList = [];

    for (var i = 0; i < _iconList.length; i++) {
      _navBarItemList.add(
        buildNavBarItem(_iconList[i], i, widget.iconTitle[i],
            widget.iconListFill[i], screenUtil),
      );
    }

    return Container(
      child: SafeArea(
        bottom: true,
        child: Container(
          decoration: BoxDecoration(
            color: kBackgroundColor6,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.0),
                offset: Offset(0, -7),
                blurRadius: 15,
              ),
            ],
          ),
          child: Row(
            children: _navBarItemList,
          ),
        ),
      ),
    );
  }

  Widget buildNavBarItem(
      String icon, int index, String title, String iconFill, screenUtil) {
    return InkWell(
      onTap: () {
        widget.onChange(index);
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        height: screenUtil.setHeight(66),
        width: MediaQuery.of(context).size.width / _iconList.length - 2.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: screenUtil.setHeight(12)),
              child: Stack(
                children: [
                  Image.asset(
                    index == _selectedIndex ? iconFill : icon,
                    height: screenUtil.setHeight(21),
                    width: screenUtil.setWidth(21),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: screenUtil.setHeight(4.0),
                bottom: screenUtil.setHeight(5.0),
              ),
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: screenUtil.setSp(12),
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                    color: index == _selectedIndex ? kTextColor5 : kTextColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
