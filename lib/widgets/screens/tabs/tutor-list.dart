import 'package:advanced_mobile_dev/models/tutor-model.dart';
import 'package:advanced_mobile_dev/providers/tutorsProvider.dart';
import 'package:advanced_mobile_dev/widgets/common/tutor-list-only.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum SortingOptions { none, ascending, descending }

class TurtorList extends StatefulWidget {
  const TurtorList({Key? key}) : super(key: key);

  @override
  _TurtorListState createState() => _TurtorListState();
}

class _TurtorListState extends State<TurtorList> {
  List<String> activeSpec = [];
  SortingOptions sorting = SortingOptions.none;

  void handleToggleSpec(String spec) {
    bool checkExisted = activeSpec.contains(spec);

    if (checkExisted) {
      setState(() {
        activeSpec.remove(spec);
      });
    } else {
      setState(() {
        activeSpec.add(spec);
      });
    }
  }

  void handleToggleSorting() {
    setState(() {
      if (sorting == SortingOptions.none ||
          sorting == SortingOptions.ascending) {
        sorting = SortingOptions.descending;
      } else {
        sorting = SortingOptions.ascending;
      }
    });
  }

  _sortingSection() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                handleToggleSorting();
              },
              icon: sorting == SortingOptions.none
                  ? const Icon(Icons.sort)
                  : sorting == SortingOptions.ascending
                      ? const Icon(Icons.arrow_upward)
                      : const Icon(Icons.arrow_downward),
              iconSize: 14,
            ),
            const Text(
              'Sort by Name',
              style: TextStyle(fontSize: 12),
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    final tutorProvider = Provider.of<TutorProvider>(context);
    // List<Tutor> list = tutorProvider.queryTutorWithSpecAndSort(activeSpec, sorting);
    List<TutorModel> list =
        tutorProvider.queryTutorWithSpecAndSort(activeSpec, sorting);
    List<String> favorites = tutorProvider.tutorModelFavorites;

    _filterChips() {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
        child: SizedBox(
          width: double.infinity,
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: tutorProvider.specialties
                .map((spec) => Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: GestureDetector(
                        onTap: () {
                          handleToggleSpec(spec);
                        },
                        child: Chip(
                          backgroundColor: activeSpec.contains(spec)
                              ? Theme.of(context).primaryColorDark
                              : Theme.of(context).primaryColorLight,
                          label: Text(spec.toUpperCase(),
                              style: TextStyle(
                                  color: activeSpec.contains(spec)
                                      ? Theme.of(context)
                                          .scaffoldBackgroundColor
                                      : Theme.of(context).primaryColor,
                                  fontSize: 10)),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        child: Column(children: <Widget>[
          _filterChips(),
          _sortingSection(),
          TutorList(tutorsList: list, favorites: favorites)
        ]),
      ),
    );
  }
}
