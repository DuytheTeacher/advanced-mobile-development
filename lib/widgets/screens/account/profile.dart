import 'dart:io';

import 'package:advanced_mobile_dev/api/api.dart';
import 'package:advanced_mobile_dev/providers/userProvider.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key, required this.title}) : super(key: key);

  final String title;
  static const routeName = '/profile';

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _phoneController = TextEditingController();
  String? _countryController;
  String? _levelController;
  String? _imageUrl;
  List<String> countryCodes = [];
  var api;
  var userDetail;

  @override
  void didChangeDependencies() async {
    try {
      api = Api().api;
      var respCountries = await api.get('https://countriesnow.space/api/v0.1/countries/iso');
      respCountries.data['data'].forEach((item) {
        setState(() {
          countryCodes.add(item['Iso2'].toString());
        });
      });
      var respDetail = await api.get('/user/info');
      setState(() {
        userDetail = respDetail.data['user'];
        _selectedDate = respDetail.data['user']['birthday'] != null ? DateFormat("yyyy-MM-dd").parse(respDetail.data['user']['birthday']) : DateTime.now();
        _phoneController.text = respDetail.data['user']['phone'];
        _countryController = respDetail.data['user']['country'];
        _levelController = respDetail.data['user']['level'].toString().toUpperCase();
        _imageUrl = respDetail.data['user']['avatar'];
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

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Future pickImage() async {
      try {
        final image =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (image == null) return;
        setState(() {
          _imageUrl = image.path;
        });
      } on PlatformException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
      }
    }

    _infoSection(String? fullName, String? email) {
      final imageTemp = File(_imageUrl!);

      return SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () => pickImage(),
              child: CircleAvatar(
                child: ClipOval(
                  child: _imageUrl == ''
                      ? Image.network(
                          'https://media.istockphoto.com/photos/businessman-silhouette-as-avatar-or-default-profile-picture-picture-id476085198?k=20&m=476085198&s=612x612&w=0&h=8J3VgOZab_OiYoIuZfiMIvucFYB8vWYlKnSjKuKeYQM=',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          imageTemp,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                ),
                radius: 30,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                fullName ?? '',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              email ?? '',
              style: const TextStyle(color: Colors.grey),
            )
          ],
        ),
      );
    }

    _selectDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
      ) as DateTime;
      if (picked != _selectedDate) {
        setState(() {
          _selectedDate = picked;
        });
      }
    }

    _birthdaySection(BuildContext context) {
      return SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(bottom: 5.0),
                child: Text('Birthday', style: TextStyle(fontSize: 16)),
              ),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(width: 1, color: Colors.blue),
                    ),
                    onPressed: () {
                      _selectDate(context);
                    },
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                            DateFormat('dd-MM-yyyy').format(_selectedDate),
                            style: const TextStyle(color: Colors.black)))),
              )
            ],
          ),
        ),
      );
    }

    _phoneSection(TextEditingController phone) {
      return SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(bottom: 5.0),
                child: Text('Phone number', style: TextStyle(fontSize: 16)),
              ),
              SizedBox(
                width: double.infinity,
                height: 36,
                child: TextField(
                  controller: phone,
                  keyboardType: TextInputType.number,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    hintText: 'Phone Number',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      borderSide: BorderSide(
                        color: Color(0xFFD6D6D6),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      borderSide: BorderSide(color: Color(0xFFD6D6D6)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    _countrySection() {
      return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 5.0),
              child: Text('Country', style: TextStyle(fontSize: 16)),
            ),
            SizedBox(
              width: double.infinity,
              height: 36,
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  hintText: 'Please select your country',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    borderSide: BorderSide(
                      color: Color(0xFFD6D6D6),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    borderSide: BorderSide(color: Color(0xFFD6D6D6)),
                  ),
                ),
                items: countryCodes.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                value: _countryController,
                onChanged: (value) {
                  setState(() {
                    _countryController = value;
                  });
                },
              ),
            ),
          ],
        ),
      );
    }

    _levelSection() {
      return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 5.0),
              child: Text('Level', style: TextStyle(fontSize: 16)),
            ),
            SizedBox(
              width: double.infinity,
              height: 36,
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  hintText: 'Please select your level',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    borderSide: BorderSide(
                      color: Color(0xFFD6D6D6),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    borderSide: BorderSide(color: Color(0xFFD6D6D6)),
                  ),
                ),
                items: ['BEGINNER', 'INTERMEDIATE', 'PROFICIENCY']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                value: _levelController,
                onChanged: (value) {
                  setState(() {
                    _levelController = value;
                  });
                },
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.profile)),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          width: double.infinity,
          child: userDetail != null ? Column(
            children: <Widget>[
              _infoSection(
                  userDetail?['name'].toString(), userDetail?['email'].toString()),
              _birthdaySection(context),
              _phoneSection(_phoneController),
              _countrySection(),
              _levelSection(),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () async {
                      var body = {
                        "country": _countryController.toString(),
                        "phone": _phoneController.text,
                        "birthday": DateFormat('yyyy-MM-dd').format(_selectedDate),
                        "level": _levelController.toString().toUpperCase(),
                      };
                      var resp = await api.put('/user/info', data: body);
                      setState(() {
                        userDetail = resp.data['user'];
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Save profile successfully!'),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Theme.of(context).accentColor,
                        ),
                      );
                    },
                    child: const Text('Save'),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                  ),
                ),
              ),
            ],
          ) : const Center(child: CircularProgressIndicator(),),
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
