import 'package:flutter/material.dart';

class BecomeTutor extends StatefulWidget {
  const BecomeTutor({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<BecomeTutor> createState() => _BecomeTutorState();
}

class _BecomeTutorState extends State<BecomeTutor> {
  int currentStep = 1;
  int maxStep = 3;
  DateTime selectedDate = DateTime.now();

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    ) as DateTime;
    if (picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  _renderStepOne() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
              child: Image.asset(
            'assets/images/become_tutor_logo.png',
            fit: BoxFit.cover,
            width: 150,
            height: 150,
          )),
          const Text(
            'Setup your tutor profile',
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
                    'Your tutor profile is your chance to market yourself to students on Tutoring. You can make edits later on your profile settings page.'),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20, top: 15, bottom: 15),
            child: Text(
              'Basic Info',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(color: Colors.grey[300]),
                  child: const Center(
                    child: Text('Upload your avatar...'),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.only(bottom: 5.0),
                            child: Text('Tutor name',
                                style: TextStyle(fontSize: 16)),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: SizedBox(
                              width: double.infinity,
                              height: 36,
                              child: TextField(
                                autocorrect: false,
                                decoration: InputDecoration(
                                  hintText: 'Name',
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 15),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.0)),
                                    borderSide: BorderSide(
                                      color: Color(0xFFD6D6D6),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.0)),
                                    borderSide:
                                        BorderSide(color: Color(0xFFD6D6D6)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 5.0),
                            child:
                                Text('Country', style: TextStyle(fontSize: 16)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: SizedBox(
                              width: double.infinity,
                              height: 36,
                              child: DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  hintText: 'Please select your country',
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 15),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.0)),
                                    borderSide: BorderSide(
                                      color: Color(0xFFD6D6D6),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.0)),
                                    borderSide:
                                        BorderSide(color: Color(0xFFD6D6D6)),
                                  ),
                                ),
                                items: <String>['Vietnam', 'US', 'UK']
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (_) {},
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 5.0),
                            child: Text('Birthday',
                                style: TextStyle(fontSize: 16)),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                                onPressed: () {
                                  _selectDate(context);
                                },
                                child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                        "${selectedDate.toLocal()}"
                                            .split(' ')[0],
                                        style: const TextStyle(
                                            color: Colors.black)))),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _renderStepTwo() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
              child: Image.asset(
            'assets/images/intro_video_logo.png',
            fit: BoxFit.cover,
            width: 150,
            height: 150,
          )),
          const Text(
            'Video introduction',
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
                    'Let students know that they can expect from a lesson with you by recording a video highlighting your teaching style, expertise and personality. Student can be nevous to speak with a foreigner, so it is very help to have a friendly video that introduces yourself and invites student to call you.'),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20, top: 15, bottom: 15),
            child: Text(
              'Introducing video',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          Container(
            width: 300,
            decoration:
                BoxDecoration(color: Theme.of(context).primaryColorLight),
            child: const Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                  'A few helpful tips:\n1.Find a clean and quite space.\n2.Smile and look at the camera.\n3.Dress smart.\n4. Speak for 1-3 minutes.\n5.Brand yourself and have fun.'),
            ),
          ),
          Center(
              child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child:
                OutlinedButton(onPressed: () {}, child: Text('Choose video')),
          ))
        ],
      ),
    );
  }

  _renderStepThee() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.tag_faces_outlined,
          size: 100,
          color: Theme.of(context).primaryColor,
        ),
        const Text(
          'You have done all the step\nPlease wait for the operator\'s approval',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
        ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
            child: const Text('Back to home'))
      ],
    );
  }

  _activeStep() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Text(
            '1. Complete profile',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: currentStep == 1
                    ? Theme.of(context).primaryColor
                    : Colors.black),
          )),
          Expanded(
              child: Text(
            '2. Video introduction',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: currentStep == 2
                    ? Theme.of(context).primaryColor
                    : Colors.black),
          )),
          Expanded(
              child: Text(
            '3. Approval',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: currentStep == 3
                    ? Theme.of(context).primaryColor
                    : Colors.black),
          )),
        ],
      ),
    );
  }

  _changeStep() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          currentStep == 1 || currentStep == maxStep
              ? const SizedBox()
              : ElevatedButton(
                  onPressed: () {
                    _previousStepHandler();
                  },
                  child: const Text('Previous')),
          currentStep == maxStep
              ? const SizedBox()
              : ElevatedButton(
                  onPressed: () {
                    _nextStepHandler();
                  },
                  child: const Text('Next'))
        ],
      ),
    );
  }

  _nextStepHandler() {
    setState(() {
      if (currentStep < maxStep) {
        currentStep++;
      }
    });
  }

  _previousStepHandler() {
    setState(() {
      if (currentStep != 1) {
        currentStep--;
      }
    });
  }

  _renderScreen() {
    if (currentStep == 1) {
      return _renderStepOne();
    } else if (currentStep == 2) {
      return _renderStepTwo();
    } else if (currentStep == maxStep) {
      return _renderStepThee();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[_activeStep(), _renderScreen(), _changeStep()],
      )),
      resizeToAvoidBottomInset: false,
    );
  }
}
