import 'package:advanced_mobile_dev/models/tutor-model.dart';
import 'package:advanced_mobile_dev/providers/classProvider.dart';
import 'package:advanced_mobile_dev/providers/tutorsProvider.dart';
import 'package:advanced_mobile_dev/providers/userProvider.dart';
import 'package:advanced_mobile_dev/widgets/common/tutor-card.dart';
import 'package:advanced_mobile_dev/widgets/screens/tutors/video-call.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.seclectPage}) : super(key: key);

  final Function seclectPage;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _recommendSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            AppLocalizations.of(context)!.recommendedTutors,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          GestureDetector(
            onTap: () {
              widget.seclectPage(2);
            },
            child: Text(
              AppLocalizations.of(context)!.seeAll,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final tutorProvider = Provider.of<TutorProvider>(context);
    final classProvider = Provider.of<ClassProvider>(context);

    List<Class> classes =
        classProvider.getClassByUserId(userProvider.currentUser?.id);
    classes.sort((a, b) => a.schedule.compareTo(b.schedule));

    _bookingSection() {
      Duration totalTime = classProvider.totalLearningHours();

      String nextClassText = classes.isNotEmpty
          ? '${DateFormat('E, d MMMM y').format(classes[0].schedule)}, ${DateFormat.jm().format(classes[0].schedule)} - ${DateFormat.jm().format(classes[0].schedule.add(const Duration(hours: 1, minutes: 30)))}'
          : '';

      return Container(
          width: double.infinity,
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          child: Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context)!.totalLessonTime(
                      totalTime.inHours.toString(),
                      (totalTime.inMinutes % 60).toString()),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    AppLocalizations.of(context)!.upcomingLesson,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: classes.isNotEmpty
                      ? Row(
                          children: [
                            Expanded(
                                flex: 5,
                                child: Text(
                                  nextClassText,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor),
                                )),
                            Expanded(
                              flex: 4,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, VideoCall.routeName,
                                      arguments: VideoCallArguments(
                                          classes[0].schedule));
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.video_call_rounded,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .enterLessonRoom,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                    primary: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    fixedSize:
                                        const Size(120, double.minPositive),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50))),
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: Text(
                          AppLocalizations.of(context)!.thereIsNoUpcomingClass,
                          style: TextStyle(
                              color: Theme.of(context).scaffoldBackgroundColor),
                        )),
                ),
              ],
            ),
          ));
    }

    _listRecommendedTutors() {
      List<String> favorites = tutorProvider.tutorModelFavorites;
      return SizedBox(
        height: classes.isNotEmpty ? 327 : 357,
        child: ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: tutorProvider.tutorsModelList.length,
          itemBuilder: (BuildContext context, int index) {
            TutorModel tutor = tutorProvider.tutorsModelList[index];
            return Center(child: TutorCard(tutor: tutor, favorites: favorites));
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
        ),
      );
    }

    return Column(
      children: <Widget>[
        _bookingSection(),
        _recommendSection(),
        _listRecommendedTutors()
      ],
    );
  }
}
