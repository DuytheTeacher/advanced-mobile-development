import 'package:advanced_mobile_dev/providers/classProvider.dart';
import 'package:advanced_mobile_dev/providers/tutorsProvider.dart';
import 'package:advanced_mobile_dev/providers/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

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
      comments: [],
      isFavorite: false);

  DateTime pickedDate = DateTime.now();

  VideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;

  @override
  initState() {
    _controller = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    );

    _initializeVideoPlayerFuture = _controller?.initialize();

    _controller?.play();

    Future.delayed(Duration.zero, () {
      final args =
          ModalRoute.of(context)!.settings.arguments as TutorDetailArguments;
      final tutorProvider = Provider.of<TutorProvider>(context, listen: false);
      setState(() {
        tutorDetail = tutorProvider.getTutorDetailById(args.id);
      });
    });

    super.initState();
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
        child: Text(tutorDetail.description));
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
                        chips[index],
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

  _commentCard(Comment comment) {
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
                      comment.userImageUrl,
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
                            comment.userName,
                            style: const TextStyle(fontSize: 15),
                          ),
                          _generateStars(comment.ratingStars),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          comment.content,
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
                              DateFormat('dd/MM/yyyy, hh:mm')
                                  .format(comment.date),
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

  _listCommentsGenerator(List<Comment> comments) {
    return Column(
      children: [...comments.map((element) => _commentCard(element)).toList()],
    );
  }

  _commentSectionGenerator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            'Rating and comments (${tutorDetail.comments.length})',
            style:
                TextStyle(color: Theme.of(context).primaryColor, fontSize: 16),
          ),
        ),
        _listCommentsGenerator(tutorDetail.comments)
      ],
    );
  }

  _listDateBooking(BuildContext ctx) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: List.generate(7, (index) {
            return SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))),
                  onPressed: () {
                    setState(() {
                      pickedDate =
                          DateTime.now().add(Duration(days: index, hours: 0));
                    });
                    _showTimeBookingModal(ctx);
                  },
                  child: Text(DateFormat('dd-MM-yyyy')
                      .format(DateTime.now().add(Duration(days: index))))),
            );
          }),
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
        classProvider.getClassByIds(args.id, userProvider.currentUser.id);

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
                                userId: userProvider.currentUser.id,
                                tutorId: args.id,
                                schedule: session);
                            classProvider.addClass(newClass);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Book meeting successfully!'), behavior: SnackBarBehavior.floating, backgroundColor: Colors.green,),
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
                    tutorDetail.imageUrl,
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
                    tutorDetail.name,
                    style: const TextStyle(fontSize: 17),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      'Teacher',
                      style: TextStyle(fontSize: 12, color: Color(0xFF616161)),
                    ),
                  ),
                  Text(tutorDetail.country)
                ],
              )),
          Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _generateStars(tutorDetail.ratingStars),
                  IconButton(
                    onPressed: () {
                      tutorData.toggleFavorite(tutorDetail.id);
                    },
                    icon: Icon(
                      tutorDetail.isFavorite
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
      appBar: AppBar(title: Text(widget.title)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            width: double.infinity,
            child: Column(children: <Widget>[
              _videoSection(),
              const SizedBox(height: 30,),
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
              _chipsSectionGenerator('Languages', tutorDetail.languages),
              _chipsSectionGenerator('Specialities', tutorDetail.specialities),
              _textSectionGenerator('Interest', tutorDetail.interest),
              _textSectionGenerator('Teaching Experience', tutorDetail.exp),
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

  TutorDetailArguments(this.id);
}
