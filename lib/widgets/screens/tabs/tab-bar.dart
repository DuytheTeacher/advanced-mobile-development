import 'package:advanced_mobile_dev/providers/courseProvider.dart';
import 'package:advanced_mobile_dev/providers/tutorsProvider.dart';
import 'package:advanced_mobile_dev/widgets/common/courses-list.dart';
import 'package:advanced_mobile_dev/widgets/common/tutor-list-only.dart';
import 'package:advanced_mobile_dev/widgets/screens/tabs/courses.dart';
import 'package:advanced_mobile_dev/widgets/screens/tabs/history.dart';
import 'package:advanced_mobile_dev/widgets/screens/tabs/home-screen.dart';
import 'package:advanced_mobile_dev/widgets/screens/tabs/schedule.dart';
import 'package:advanced_mobile_dev/widgets/screens/tabs/settings.dart';
import 'package:advanced_mobile_dev/widgets/screens/tabs/tutor-list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../models/tutor-model.dart';

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
      {
        'page': HomeScreen(seclectPage: _seclectPage),
        'title': AppLocalizations.of(context)!.home
      },
      {
        'page': const Schedule(),
        'title': AppLocalizations.of(context)!.schedule
      },
      {
        'page': const TurtorList(),
        'title': AppLocalizations.of(context)!.tutors
      },
      {'page': const Courses(), 'title': AppLocalizations.of(context)!.courses},
      {'page': const History(), 'title': AppLocalizations.of(context)!.history},
      {
        'page': Settings(seclectPage: _seclectPage),
        'title': AppLocalizations.of(context)!.settings
      },
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
          _selectedIndex == 2 || _selectedIndex == 3
              ? Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          showSearch(
                              context: context,
                              delegate: _selectedIndex == 2
                                  ? TutorSearch(filter: _filter)
                                  : CourseSearch());
                        },
                        icon: Icon(
                          Icons.search_sharp,
                          color: Theme.of(context).primaryColor,
                        )),
                    _selectedIndex != 3 ? _filterRender() : Container(),
                    _selectedIndex != 3 ? _popupMenu() : Container()
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
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: AppLocalizations.of(context)!.home),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: AppLocalizations.of(context)!.upcoming),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: AppLocalizations.of(context)!.tutors),
          BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded), label: AppLocalizations.of(context)!.courses),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: AppLocalizations.of(context)!.history),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: AppLocalizations.of(context)!.settings),
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}

class CourseSearch extends SearchDelegate<String> {
  CourseSearch();

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
    final courseProvider = Provider.of<CourseProvider>(context);
    List<Course> list = courseProvider.queryCourse(query);

    return SingleChildScrollView(
        child: CoursesList(
          query: query
    ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);
    List<Course> list = courseProvider.queryCourse(query);

    return SingleChildScrollView(
        child: CoursesList(
          query: query
    ));
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
    List<TutorModel> list = tutorProvider.queryTutor(filter, query);
    List<String> favorites = tutorProvider.tutorModelFavorites;

    return SingleChildScrollView(
        child: TutorList(tutorsList: list, favorites: favorites));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final tutorProvider = Provider.of<TutorProvider>(context);
    List<TutorModel> list = tutorProvider.queryTutor(filter, query);
    List<String> favorites = tutorProvider.tutorModelFavorites;

    return SingleChildScrollView(
      child: TutorList(tutorsList: list, favorites: favorites),
    );
  }
}
