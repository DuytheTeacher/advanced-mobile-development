import 'package:advanced_mobile_dev/api/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

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
  final serverText = TextEditingController(text: 'https://meet.lettutor.com/');
  final roomText = TextEditingController(text: "LetTutorRoom");
  final subjectText = TextEditingController(text: "LetTutor Meeting");
  final nameText = TextEditingController(text: "Sample");
  final emailText = TextEditingController(text: "sample@email.com");
  var tokenText = '';
  bool? isAudioOnly = true;
  bool? isAudioMuted = true;
  bool? isVideoMuted = true;
  var user;

  @override
  void initState() {
    super.initState();
    JitsiMeet.addListener(JitsiMeetingListener(
        onConferenceWillJoin: _onConferenceWillJoin,
        onConferenceJoined: _onConferenceJoined,
        onConferenceTerminated: _onConferenceTerminated,
        onError: _onError));
  }

  @override
  void didChangeDependencies() async {
    final args =
        ModalRoute.of(context)!.settings.arguments as VideoCallArguments;
    var api = Api().api;
    try {
      var resp = await api.get('/user/info');
      setState(() {
        user = resp.data['user'];
      });
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
      roomText.text = args.configs['scheduleDetailId'].toString();
      nameText.text = user['name'].toString();
      emailText.text = user['email'].toString();
      tokenText = args.configs['studentMeetingLink'].toString().substring(0, 12);
      then = args.dueDate;
    });

    int seconds = _secondsBetween(now, then).inSeconds > 0
        ? _secondsBetween(now, then).inSeconds
        : 0;

    controller =
        AnimationController(vsync: this, duration: Duration(seconds: seconds));

    _startTimer();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    JitsiMeet.removeAllListeners();
  }

  void _onConferenceWillJoin(message) {
    debugPrint("_onConferenceWillJoin broadcasted with message: $message");
  }

  void _onConferenceJoined(message) {
    debugPrint("_onConferenceJoined broadcasted with message: $message");
  }

  void _onConferenceTerminated(message) {
    debugPrint("_onConferenceTerminated broadcasted with message: $message");
  }

  _onError(error) {
    debugPrint("_onError broadcasted: $error");
  }

  _onAudioOnlyChanged(bool? value) {
    setState(() {
      isAudioOnly = value;
    });
  }

  _onAudioMutedChanged(bool? value) {
    setState(() {
      isAudioMuted = value;
    });
  }

  _onVideoMutedChanged(bool? value) {
    setState(() {
      isVideoMuted = value;
    });
  }

  _joinMeeting() async {
    String? serverUrl = serverText.text.trim().isEmpty ? null : serverText.text;

    // Enable or disable any feature flag here
    // If feature flag are not provided, default values will be used
    // Full list of feature flags (and defaults) available in the README
    Map<FeatureFlagEnum, bool> featureFlags = {
      FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
    };
    if (!kIsWeb) {
      // Here is an example, disabling features for each platform
      if (Platform.isAndroid) {
        // Disable ConnectionService usage on Android to avoid issues (see README)
        featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
      } else if (Platform.isIOS) {
        // Disable PIP on iOS as it looks weird
        featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
      }
    }
    // Define meetings options here
    var options = JitsiMeetingOptions(room: roomText.text)
      ..serverURL = serverUrl
      ..subject = subjectText.text
      ..userDisplayName = nameText.text
      ..userEmail = emailText.text
      ..token = tokenText
      ..audioOnly = isAudioOnly
      ..audioMuted = isAudioMuted
      ..videoMuted = isVideoMuted
      ..featureFlags.addAll(featureFlags)
      ..webOptions = {
        "roomName": roomText.text,
        "width": "100%",
        "height": "100%",
        "enableWelcomePage": false,
        "chromeExtensionBanner": null,
        "userInfo": {"displayName": nameText.text}
      };

    debugPrint("JitsiMeetingOptions: $options");
    await JitsiMeet.joinMeeting(
      options,
      listener: JitsiMeetingListener(
          onConferenceWillJoin: (message) {
            debugPrint("${options.room} will join with message: $message");
          },
          onConferenceJoined: (message) {
            debugPrint("${options.room} joined with message: $message");
          },
          onConferenceTerminated: (message) {
            debugPrint("${options.room} terminated with message: $message");
          },
          genericListeners: [
            JitsiGenericListener(
                eventName: 'readyToClose',
                callback: (dynamic message) {
                  debugPrint("readyToClose callback");
                }),
          ]),
    );
  }

  Widget meetConfig() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          TextField(
            controller: nameText,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Display Name",
            ),
          ),
          const SizedBox(height: 16,),
          CheckboxListTile(
            title: const Text("Audio Only"),
            value: isAudioOnly,
            onChanged: _onAudioOnlyChanged,
          ),
          const SizedBox(height: 16,),
          CheckboxListTile(
            title: const Text("Audio Muted"),
            value: isAudioMuted,
            onChanged: _onAudioMutedChanged,
          ),
          const SizedBox(height: 16,),
          CheckboxListTile(
            title: const Text("Video Muted"),
            value: isVideoMuted,
            onChanged: _onVideoMutedChanged,
          ),
          const Divider(
            height: 48.0,
            thickness: 2.0,
          ),
          SizedBox(
            height: 64.0,
            width: double.maxFinite,
            child: ElevatedButton(
              onPressed: () {
                _joinMeeting();
              },
              child: const Text(
                "Join Meeting",
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateColor.resolveWith((states) => Colors.blue)),
            ),
          ),
          // SizedBox(
          //   height: 48.0,
          // ),
        ],
      ),
    );
  }

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
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    if (controller.value > 0) {
      setState(() {
        isPlaying = false;
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.videoCall)),
      body: controller != null ? Column(
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
              : Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: kIsWeb
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: width * 0.30,
                              child: meetConfig(),
                            ),
                            Container(
                                width: width * 0.60,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                      color: Colors.white54,
                                      child: SizedBox(
                                        width: width * 0.60 * 0.70,
                                        height: width * 0.60 * 0.70,
                                        child: JitsiMeetConferencing(
                                          extraJS: const [
                                            // extraJs setup example
                                            '<script>function echo(){console.log("echo!!!")};</script>',
                                            '<script src="https://code.jquery.com/jquery-3.5.1.slim.js" integrity="sha256-DrT5NfxfbHvMHux31Lkhxg42LY6of8TaYyK50jnxRnM=" crossorigin="anonymous"></script>'
                                          ],
                                        ),
                                      )),
                                ))
                          ],
                        )
                      : meetConfig(),
                ),
        ],
      ) : Center(child: CircularProgressIndicator(),),
      resizeToAvoidBottomInset: false,
    );
  }
}

class VideoCallArguments {
  final DateTime dueDate;
  var configs;

  VideoCallArguments(this.dueDate, this.configs);
}
