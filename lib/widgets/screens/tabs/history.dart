import 'package:advanced_mobile_dev/providers/classProvider.dart';
import 'package:advanced_mobile_dev/providers/tutorsProvider.dart';
import 'package:advanced_mobile_dev/providers/userProvider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../api/api.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  bool _isFirstLoading = false;
  bool _isMoreLoading = false;
  int _page = 1;
  final int _limit = 5;
  bool _hasNextPage = true;
  late ScrollController _controller;

  var api;
  var classesList;

  List<Class> classes = [];

  @override
  initState() {
    super.initState();
    _firstLoad();
    _controller = ScrollController()..addListener(_loadMore);
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    api = Api().api;
    super.didChangeDependencies();
  }

  void _firstLoad() async {
    setState(() {
      _isFirstLoading = true;
      _page = 1;
      _hasNextPage = true;
    });

    try {
      api = Api().api;
      var resp = await api.get('/booking/list/student', queryParameters: {
        'page': _page,
        'perPage': _limit,
        'dateTimeLte': (DateTime.now().subtract(const Duration(minutes: 35)))
                .microsecondsSinceEpoch /
            1000,
        'orderBy': 'meeting',
        'sortBy': 'desc'
      });
      setState(() {
        classesList = resp.data['data']['rows'];
      });
    } on DioError catch (e) {
      if (e.response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.response?.data['message']),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.message);
      }
    }

    setState(() {
      _isFirstLoading = false;
    });
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoading == false &&
        _isMoreLoading == false &&
        _controller.position.extentAfter < 100) {
      setState(() {
        _isMoreLoading = true;
        _page += 1;
      });

      try {
        api = Api().api;
        var resp = await api.get('/booking/list/student', queryParameters: {
          'page': _page,
          'perPage': _limit,
          'dateTimeLte': (DateTime.now().subtract(const Duration(minutes: 35)))
                  .microsecondsSinceEpoch /
              1000,
          'orderBy': 'meeting',
          'sortBy': 'desc'
        });
        setState(() {
          classesList.addAll(resp.data['data']['rows']);
        });
      } on DioError catch (e) {
        if (e.response != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.response?.data['message']),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Theme.of(context).errorColor,
            ),
          );
        } else {
          // Something happened in setting up or sending the request that triggered an Error
          print(e.message);
        }
      }

      setState(() {
        _isMoreLoading = false;
      });
    }
  }

  _historySection(var currentClass) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Lesson Time: ${DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(currentClass['startTimestamp']))} - ${DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(currentClass['endTimestamp']))}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _reviewSection() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Text(
                'Teach has not reviewed yet.',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _tutorSection(var tutorDetail) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: CircleAvatar(
                    child: ClipOval(
                      child: Image.network(
                        tutorDetail['avatar'],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    radius: 30,
                  )),
              Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        tutorDetail['name'],
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          tutorDetail['country'],
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF616161)),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _historyCard(var currentClass) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10.0)),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  DateFormat('E, d MMMM y').format(
                      DateTime.fromMillisecondsSinceEpoch(
                          currentClass['scheduleDetailInfo']['scheduleInfo']
                                  ['startTimestamp'])),
                  style: const TextStyle(
                      fontWeight: FontWeight.w900, fontSize: 28),
                ),
                Text(
                    '${DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(currentClass['scheduleDetailInfo']['scheduleInfo']['startTimestamp'])).inHours} hours ago'),
                _tutorSection(currentClass['scheduleDetailInfo']['scheduleInfo']['tutorInfo']),
                _historySection(currentClass['scheduleDetailInfo']['scheduleInfo']),
                // _reviewSection()
              ],
            ),
          ),
        ),
      );
    }

    _listHistory() {
      return Column(
        children: [
          SizedBox(
            height: _isMoreLoading ? 282 : 337,
            child: ListView.separated(
              shrinkWrap: true,
              controller: _controller,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: classesList.length,
              itemBuilder: (BuildContext context, int index) {
                var currentClass = classesList[index];
                return Center(child: _historyCard(currentClass));
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
          ),
          if (_isMoreLoading == true)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
                child: Image.asset(
              'assets/images/history_logo.png',
              fit: BoxFit.cover,
              width: 150,
              height: 150,
            )),
            const Text(
              'History',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: Container(
                decoration: const BoxDecoration(
                    border: Border(
                  left: BorderSide(
                    color: Colors.grey,
                    width: 4,
                  ),
                )),
                child: const Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                      'The following is a list of lessons you have attended.\nYou can review the details of the lessons you have attended.'),
                ),
              ),
            ),
            _isFirstLoading
                ? const Center(child: CircularProgressIndicator())
                : classesList.isEmpty
                    ? const Center(
                        child: Text(
                        'There is no history!',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ))
                    : _listHistory()
          ],
        ),
      ),
    );
  }
}
