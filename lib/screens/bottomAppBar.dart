import 'package:education_community/screens/HomePage.dart';
import 'package:education_community/screens/bookmarkPage.dart';
import 'package:education_community/screens/myProfilePage.dart';
import 'package:education_community/screens/settingsPage.dart';
import 'package:flutter/material.dart';

class BottomNavigationAppBar extends StatefulWidget {
  @override
  _BottomNavigationAppBarState createState() => _BottomNavigationAppBarState();
}

class _BottomNavigationAppBarState extends State<BottomNavigationAppBar> {
  PageController _pageController;
  int selectedPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

  changePage(int pageNo) {
    setState(() {
      selectedPage = pageNo;
    });
    _pageController.animateToPage(pageNo,
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, "BlogPostPage"),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        elevation: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(
                Icons.home,
                color: selectedPage == 0 ? Colors.red : Colors.black,
              ),
              onPressed: () => changePage(0),
            ),
            IconButton(
              icon: Icon(
                Icons.bookmark_rounded,
                color: selectedPage == 1 ? Colors.red : Colors.black,
              ),
              onPressed: () => changePage(1),
            ),
            IconButton(
              icon: Icon(
                Icons.account_circle_rounded,
                color: selectedPage == 2 ? Colors.red : Colors.black,
              ),
              onPressed: () => changePage(2),
            ),
            IconButton(
              icon: Icon(
                Icons.settings,
                color: selectedPage == 3 ? Colors.red : Colors.black,
              ),
              onPressed: () => changePage(3),
            ),
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Homepage(),
          BookMarkPage(),
          MyProfilePage(),
          SettingsPage(),
        ],
      ),
    );
  }
}
