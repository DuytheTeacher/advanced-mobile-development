import 'package:advanced_mobile_dev/api/api.dart';
import 'package:advanced_mobile_dev/providers/classProvider.dart';
import 'package:advanced_mobile_dev/widgets/screens/tutors/video-call.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Schedule extends StatefulWidget {
  const Schedule({Key? key}) : super(key: key);

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
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
        'dateTimeGte': (DateTime.now().subtract(const Duration(minutes: 5)))
                .microsecondsSinceEpoch /
            1000,
        'orderBy': 'meeting',
        'sortBy': 'asc'
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
        var resp = await api.get('/booking/list/student', queryParameters: {
          'page': _page,
          'perPage': _limit,
          'dateTimeGte': (DateTime.now().subtract(const Duration(minutes: 5)))
                  .microsecondsSinceEpoch /
              1000,
          'orderBy': 'meeting',
          'sortBy': 'asc'
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
                      GestureDetector(
                        onTap: () {
                          // Navigator.pushNamed(context, TutorDetail.routeName,
                          //     arguments: TutorDetailArguments(tutorDetail.id));
                        },
                        child: Text(
                          tutorDetail['name'],
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
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

  _scheduleSection(var currentClass) {
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    '${AppLocalizations.of(context)!.lessonTime}: ${DateFormat.jm().format(DateTime.fromMicrosecondsSinceEpoch(currentClass['scheduleDetailInfo']['scheduleInfo']['startTimestamp'] * 1000))} - ${DateFormat.jm().format(DateTime.fromMicrosecondsSinceEpoch(currentClass['scheduleDetailInfo']['scheduleInfo']['endTimestamp'] * 1000))}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 110,
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(width: 1, color: Colors.red),
                      ),
                      onPressed: () async {
                        setState(() {
                          _isFirstLoading = true;
                        });
                        try {
                          var resp = await api.delete('/booking', data: {
                            "scheduleDetailIds": [
                              currentClass['scheduleDetailInfo']['id']
                            ]
                          });
                          _firstLoad();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Cancel class Successfully!'),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Theme.of(context).accentColor,
                            ),
                          );
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
                      },
                      child: Row(
                        children: <Widget>[
                          const Icon(
                            Icons.cancel_outlined,
                            color: Colors.red,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                              AppLocalizations.of(context)!.cancelMeeting,
                              style: TextStyle(color: Colors.red),
                            ),
                          )
                        ],
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _scheduleCard(var currentClass) {
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
                      DateTime.fromMicrosecondsSinceEpoch(
                          currentClass['scheduleDetailInfo']['scheduleInfo']
                                  ['startTimestamp'] *
                              1000)),
                  style: const TextStyle(
                      fontWeight: FontWeight.w900, fontSize: 28),
                ),
                Text('1 ${AppLocalizations.of(context)!.lesson}'),
                _tutorSection(currentClass['scheduleDetailInfo']['scheduleInfo']
                    ['tutorInfo']),
                _scheduleSection(currentClass),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, VideoCall.routeName,
                                arguments: VideoCallArguments(
                                    DateTime.fromMicrosecondsSinceEpoch(
                                        currentClass['scheduleDetailInfo']
                                                ['startPeriodTimestamp'] *
                                            1000)));
                          },
                          child: Text(AppLocalizations.of(context)!.joinMeeting))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    _listSchedule() {
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
                return Center(child: _scheduleCard(currentClass));
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
              'assets/images/schedule_logo.png',
              fit: BoxFit.cover,
              width: 150,
              height: 150,
            )),
            Text(
              AppLocalizations.of(context)!.schedule,
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
                child: Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                      AppLocalizations.of(context)!.scheduleDesc),
                ),
              ),
            ),
            _isFirstLoading
                ? const Center(child: CircularProgressIndicator())
                : classesList.isEmpty
                    ? Center(
                        child: Text(AppLocalizations.of(context)!.noClass,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ))
                    : _listSchedule(),
          ],
        ),
      ),
    );
  }
}
