import 'package:advanced_mobile_dev/providers/userProvider.dart';
import 'package:advanced_mobile_dev/widgets/screens/tabs/courses.dart';
import 'package:advanced_mobile_dev/widgets/screens/tabs/history.dart';
import 'package:advanced_mobile_dev/widgets/screens/tabs/home-screen.dart';
import 'package:advanced_mobile_dev/widgets/screens/tabs/schedule.dart';
import 'package:advanced_mobile_dev/widgets/screens/tabs/settings.dart';
import 'package:advanced_mobile_dev/widgets/screens/tabs/tutor-list.dart';
import 'package:flutter/material.dart';

class Tabbar extends StatefulWidget {
  @override
  _TabbarState createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> {
  int _selectedIndex = 0;

  void _seclectPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, Object>> _pages = [
      {'page': HomeScreen(seclectPage: _seclectPage), 'title': 'Home'},
      {'page': const Schedule(), 'title': 'Schedule'},
      {'page': const TurtorList(), 'title': 'Tutors'},
      {'page': const Courses(), 'title': 'Courses'},
      {'page': const History(), 'title': 'History'},
      {
        'page': Settings(
          seclectPage: _seclectPage
        ),
        'title': 'Settings'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedIndex]['title'] as String,
            style:
                TextStyle(color: Theme.of(context).primaryColor, fontSize: 16)),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
      ),
      body: _pages[_selectedIndex]['page'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _seclectPage,
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Upcoming'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Tutors'),
          BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded), label: 'Courses'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
