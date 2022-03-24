import 'package:advanced_mobile_dev/providers/tutorsProvider.dart';
import 'package:advanced_mobile_dev/widgets/common/tutor-list-only.dart';
import 'package:advanced_mobile_dev/widgets/screens/tabs/courses.dart';
import 'package:advanced_mobile_dev/widgets/screens/tabs/history.dart';
import 'package:advanced_mobile_dev/widgets/screens/tabs/home-screen.dart';
import 'package:advanced_mobile_dev/widgets/screens/tabs/schedule.dart';
import 'package:advanced_mobile_dev/widgets/screens/tabs/settings.dart';
import 'package:advanced_mobile_dev/widgets/screens/tabs/tutor-list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum SearchOptions { name, country }

class Tabbar extends StatefulWidget {
  @override
  _TabbarState createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> {
  int _selectedIndex = 0;
  SearchOptions _filter = SearchOptions.name;

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
      {'page': Settings(seclectPage: _seclectPage), 'title': 'Settings'},
    ];

    _popupMenu() {
      return PopupMenuButton(
        onSelected: (SearchOptions selectedValue) {
          setState(() {
            if (selectedValue == SearchOptions.name) {
              _filter = SearchOptions.name;
            } else {
              _filter = SearchOptions.country;
            }
          });
        },
        itemBuilder: (_) => const [
          PopupMenuItem(
            child: Text('Search by name'),
            value: SearchOptions.name,
          ),
          PopupMenuItem(
            child: Text('Search by country'),
            value: SearchOptions.country,
          ),
        ],
        icon: Icon(
          Icons.more_vert,
          color: Theme.of(context).primaryColor,
        ),
      );
    }

    _filterRender() {
      String filterText = '';
      if (_filter == SearchOptions.name) {
        filterText = 'Name';
      } else if (_filter == SearchOptions.country) {
        filterText = 'Country';
      }
      return Center(
        child: RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
                child: Icon(
                  Icons.filter_alt_outlined,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              TextSpan(
                  text: filterText,
                  style: TextStyle(color: Theme.of(context).primaryColor)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedIndex]['title'] as String,
            style:
                TextStyle(color: Theme.of(context).primaryColor, fontSize: 16)),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        actions: [
          _selectedIndex == 2
              ? Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          showSearch(
                              context: context,
                              delegate: TutorSearch(filter: _filter));
                        },
                        icon: Icon(
                          Icons.search_sharp,
                          color: Theme.of(context).primaryColor,
                        )),
                    _filterRender(),
                    _popupMenu()
                  ],
                )
              : Container()
        ],
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

class TutorSearch extends SearchDelegate<String> {
  SearchOptions filter;

  TutorSearch({required this.filter});

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            if (query.isEmpty) {
              close(context, '');
            } else {
              query = '';
            }
          },
        )
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: const Icon(Icons.arrow_back));

  @override
  Widget buildResults(BuildContext context) {
    final tutorProvider = Provider.of<TutorProvider>(context);
    List<Tutor> list = tutorProvider.queryTutor(filter, query);

    return SingleChildScrollView(child: TutorList(tutorsList: list,));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final tutorProvider = Provider.of<TutorProvider>(context);
    List<Tutor> list = tutorProvider.queryTutor(filter, query);

    return SingleChildScrollView(child: TutorList(tutorsList: list,),);
  }
}
