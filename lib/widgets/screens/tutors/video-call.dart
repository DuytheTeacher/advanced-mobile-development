import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VideoCall extends StatefulWidget {
  const VideoCall({Key? key, required this.title}) : super(key: key);

  final String title;
  static String routeName = '/video-call';

  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> with TickerProviderStateMixin {
  DateTime now = DateTime.now();
  DateTime then = DateTime(2022, 3, 6, 20, 0, 0);
  late AnimationController controller;
  bool isPlaying = true;

  Duration _secondsBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day, from.hour, from.minute);
    to = DateTime(to.year, to.month, to.day, to.hour, to.minute);
    return to.difference(from);
  }

  String get countText {
    Duration count = controller.duration! * controller.value;
    return '${count.inDays > 0 ? '${count.inDays}d:' : ''}${count.inHours % 24}:${(count.inMinutes % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')} until lesson starts (${DateFormat('E, d MMMM y, hh:mm a').format(then)})';
  }

  void _startTimer() {
    controller.reverse(from: controller.value == 0 ? 1.0 : controller.value);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final args =
          ModalRoute.of(context)!.settings.arguments as VideoCallArguments;

      setState(() {
        then = args.dueDate;
      });

      int seconds = _secondsBetween(now, then).inSeconds > 0
          ? _secondsBetween(now, then).inSeconds
          : 0;

      controller = AnimationController(
          vsync: this, duration: Duration(seconds: seconds));
      _startTimer();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller.value <= 0) {
      setState(() {
        isPlaying = false;
      });
    }
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          isPlaying
              ? Center(
                  child: SizedBox(
                    width: 300,
                    child: Card(
                      elevation: 5,
                      color: Theme.of(context).primaryColor,
                      child: AnimatedBuilder(
                        animation: controller,
                        builder: (context, child) => Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            countText,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Column(
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      child: Image.asset('assets/images/demo_video_call.png'),
                    )
                  ],
                )
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}

class VideoCallArguments {
  final DateTime dueDate;

  VideoCallArguments(this.dueDate);
}
