import 'dart:convert';

import 'package:advanced_mobile_dev/api/api.dart';
import 'package:advanced_mobile_dev/models/tutor-model.dart';
import 'package:advanced_mobile_dev/providers/classProvider.dart';
import 'package:advanced_mobile_dev/providers/tutorsProvider.dart';
import 'package:advanced_mobile_dev/providers/userProvider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TutorDetail extends StatefulWidget {
  const TutorDetail({Key? key, required this.title}) : super(key: key);

  final String title;
  static String routeName = '/tutor-detail';

  @override
  _TutorDetailState createState() => _TutorDetailState();
}

class _TutorDetailState extends State<TutorDetail> {
  Tutor tutorDetail = Tutor(
      id: '',
      imageUrl: 'https://source.unsplash.com/random/?avatar/tutor',
      name: '',
      ratingStars: 0,
      description: '',
      country: '',
      languages: [],
      specialities: [],
      interest: '',
      exp: '',
      isFavorite: false);

  TutorModel? tutorModelDetail;
  var _additionalDetail;
  var _scheduleList;
  var arg;

  DateTime pickedDate = DateTime.now();

  VideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;

  @override
  void didChangeDependencies() async {
    final tutorProvider = Provider.of<TutorProvider>(context, listen: false);
    arg = ModalRoute.of(context)!.settings.arguments as TutorDetailArguments;

    _additionalDetail = arg.asyncDetail;
    _controller = VideoPlayerController.network(
      _additionalDetail['video'],
    );
    tutorModelDetail = tutorProvider.getTutorDetailById(arg.id);
    _scheduleList =
        await tutorProvider.getScheduleByTutorId(_additionalDetail['userId']);

    _initializeVideoPlayerFuture = _controller?.initialize();
    _controller?.play();

    super.didChangeDependencies();
  }

  @override
  dispose() {
    _controller?.dispose();
    super.dispose();
  }

  _videoSection() {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the VideoPlayerController has finished initialization, use
          // the data it provides to limit the aspect ratio of the video.
          return AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            // Use the VideoPlayer widget to display the video.
            child: VideoPlayer(_controller!),
          );
        } else {
          // If the VideoPlayerController is still initializing, show a
          // loading spinner.
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  _generateStars(int stars) {
    return Row(
      children: List.generate(
        5,
        (index) => index + 1 <= stars
            ? const Icon(
                Icons.star,
                color: Colors.yellow,
              )
            : const Icon(
                Icons.star_border_outlined,
                color: Colors.yellow,
              ),
      ),
    );
  }

  _actionsGroup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.message,
              color: Theme.of(context).primaryColor,
            ),
            Text(
              'Message',
              style: TextStyle(
                  fontSize: 12, color: Theme.of(context).primaryColor),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.report,
              color: Theme.of(context).primaryColor,
            ),
            Text(
              'Report',
              style: TextStyle(
                  fontSize: 12, color: Theme.of(context).primaryColor),
            ),
          ],
        )
      ],
    );
  }

  _tutorDescription() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Text(tutorModelDetail?.bio));
  }

  _chipsSectionGenerator(String section, List<String> chips) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              section,
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 16),
            ),
            Wrap(
              spacing: 10,
              runSpacing: -10,
              children: List.generate(
                  chips.length,
                  (index) => Chip(
                      backgroundColor: Theme.of(context).primaryColorLight,
                      label: Text(
                        chips[index].toUpperCase(),
                        style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context).primaryColor),
                      ))),
            )
          ],
        ),
      ),
    );
  }

  _textSectionGenerator(String section, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              section,
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 16),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                description,
              ),
            )
          ],
        ),
      ),
    );
  }

  _commentCard(dynamic comment) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: CircleAvatar(
                  child: ClipOval(
                    child: Image.network(
                      comment['firstInfo']['avatar'],
                      width: 35,
                      height: 35,
                      fit: BoxFit.cover,
                    ),
                  ),
                  radius: 30,
                )),
            Expanded(
                flex: 9,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            comment['firstInfo']['name'],
                            style: const TextStyle(fontSize: 15),
                          ),
                          _generateStars(comment['rating']),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          comment['content'],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF616161)),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              DateFormat('E, d MMM y, hh:mm')
                                  .format(DateTime.parse(comment['createdAt'])),
                              style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  _listCommentsGenerator(List<dynamic> comments) {
    return Column(
      children: [...comments.map((element) => _commentCard(element)).toList()],
    );
  }

  _commentSectionGenerator() {
    final tutorData = Provider.of<TutorProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            'Rating and comments (${_additionalDetail['User']['feedbacks'].length})',
            style:
                TextStyle(color: Theme.of(context).primaryColor, fontSize: 16),
          ),
        ),
        _listCommentsGenerator(_additionalDetail['User']['feedbacks'])
      ],
    );
  }

  _listDateBooking(BuildContext ctx) {
    var list = _scheduleList
        .where((element) => DateTime.fromMicrosecondsSinceEpoch(
                element['startTimestamp'] * 1000)
            .isAfter(DateTime.now()))
        .toList();

    list.sort((a, b) {
      return DateTime.fromMicrosecondsSinceEpoch(a['startTimestamp'] * 1000)
              .isAfter(DateTime.fromMicrosecondsSinceEpoch(
                  b['startTimestamp'] * 1000))
          ? 1
          : -1;
    });

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: list.isNotEmpty ? list.sublist(0, 7).map<Widget>((element) {
            return SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))),
                  onPressed: () async {
                    var api = Api().api;
                    try {
                      await api.post('/booking', data: json.encode({ 'scheduleDetailIds': [ element['scheduleDetails'][0]['id'] ] }));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: const Text('Book classroom successfully!'), behavior: SnackBarBehavior.floating, backgroundColor: Theme.of(context).accentColor,),
                      );
                    } on DioError catch (e) {
                      if (e.response != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.response?.data['message']), behavior: SnackBarBehavior.floating, backgroundColor: Theme.of(context).errorColor,),
                        );
                      } else {
                        // Something happened in setting up or sending the request that triggered an Error
                        print(e.message);
                      }
                    }

                    setState(() {
                      pickedDate = DateTime.fromMicrosecondsSinceEpoch(
                          element['startTimestamp'] * 1000);
                    });
                  },
                  child: Text(DateFormat('E, dd MMMM y, hh:mm a').format(
                      DateTime.fromMicrosecondsSinceEpoch(
                          element['startTimestamp'] * 1000)))),
            );
          }).toList() : [],
        ),
      ),
    );
  }

  _listTimeBooking() {
    DateTime firstClass = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 8, 0);
    final classProvider = Provider.of<ClassProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final args =
        ModalRoute.of(context)!.settings.arguments as TutorDetailArguments;

    List<Class> classesList =
        classProvider.getClassByIds(args.id, userProvider.currentUser?.id);

    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: List.generate(4, (index) {
              var session = DateTime(
                  pickedDate.year,
                  pickedDate.month,
                  pickedDate.day,
                  firstClass.add(Duration(hours: (index * 4))).hour,
                  firstClass.add(Duration(hours: (index * 4))).minute);
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                    onPressed: classesList.any((element) =>
                                element.schedule.compareTo(session) == 0) ||
                            session.isBefore(DateTime.now())
                        ? null
                        : () {
                            Class newClass = Class(
                                id: const Uuid().v4(),
                                userId: userProvider.currentUser?.id,
                                tutorId: args.id,
                                schedule: session);
                            classProvider.addClass(newClass);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Book meeting successfully!'),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                    child: Text(classesList.any((element) =>
                            element.schedule.compareTo(session) == 0)
                        ? 'Booked (${DateFormat('hh:mm a').format(firstClass.add(Duration(hours: (index * 4))))})'
                        : DateFormat('hh:mm a').format(
                            firstClass.add(Duration(hours: (index * 4)))))),
              );
            }),
          ),
        ),
      ),
    );
  }

  _dateBooking(BuildContext ctx) {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.grey[200]),
          child: const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text(
                'Pick your date!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        _listDateBooking(ctx)
      ],
    );
  }

  _timeBooking() {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.grey[200]),
          child: const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text(
                'Pick your time!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        _listTimeBooking()
      ],
    );
  }

  _showDateBookingModal(BuildContext ctx) {
    return showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            child: SizedBox(
              width: double.infinity,
              child: _dateBooking(ctx),
            ),
            onTap: () {},
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  _showTimeBookingModal(BuildContext ctx) {
    return showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            child: SizedBox(
              width: double.infinity,
              child: _timeBooking(),
            ),
            onTap: () {},
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final tutorData = Provider.of<TutorProvider>(context);

    _tutorInfo() {
      return Row(
        children: <Widget>[
          Expanded(
              flex: 2,
              child: CircleAvatar(
                child: ClipOval(
                  child: Image.network(
                    _additionalDetail['User']['avatar'] ?? '',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                radius: 30,
              )),
          Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _additionalDetail['User']['name'] ?? '',
                    style: const TextStyle(fontSize: 17),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      'Teacher',
                      style: TextStyle(fontSize: 12, color: Color(0xFF616161)),
                    ),
                  ),
                  Text(_additionalDetail['User']['country'] ?? '')
                ],
              )),
          Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _generateStars(_additionalDetail['avgRating'].round() ?? 0),
                  IconButton(
                    onPressed: () async {
                      var resp = await tutorData
                          .toggleFavorite(tutorModelDetail?.userId);
                      if (resp != null && resp == true) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text('Tutor is added to Favorite'),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Theme.of(context).accentColor,
                        ));
                      } else if (resp != null && resp == false) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text('Tutor is removed from Favorite'),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Theme.of(context).accentColor,
                        ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(tutorData.errorMessage),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Theme.of(context).accentColor,
                        ));
                      }
                    },
                    icon: Icon(
                      tutorData.tutorModelFavorites.indexWhere((element) =>
                                  element == tutorModelDetail?.userId) !=
                              -1
                          ? Icons.favorite
                          : Icons.favorite_outline,
                      color: Colors.red,
                    ),
                  )
                ],
              ))
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.tutor)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            width: double.infinity,
            child: Column(children: <Widget>[
              _videoSection(),
              const SizedBox(
                height: 30,
              ),
              _tutorInfo(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _showDateBookingModal(context);
                    },
                    child: const Text('Booking'),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                  ),
                ),
              ),
              _actionsGroup(),
              _tutorDescription(),
              _chipsSectionGenerator('Languages', tutorModelDetail?.languages),
              _chipsSectionGenerator(
                  'Specialities', tutorModelDetail?.specialties),
              _textSectionGenerator('Interest', tutorModelDetail?.interests),
              _textSectionGenerator(
                  'Teaching Experience', tutorModelDetail?.experience),
              _commentSectionGenerator()
            ]),
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}

class TutorDetailArguments {
  final String id;
  final dynamic asyncDetail;

  TutorDetailArguments(this.id, this.asyncDetail);
}
