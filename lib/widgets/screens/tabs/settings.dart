import 'dart:io';

import 'package:advanced_mobile_dev/api/api.dart';
import 'package:advanced_mobile_dev/providers/languageProvider.dart';
import 'package:advanced_mobile_dev/providers/themeProvider.dart';
import 'package:advanced_mobile_dev/providers/userProvider.dart';
import 'package:advanced_mobile_dev/widgets/screens/account/profile.dart';
import 'package:advanced_mobile_dev/widgets/screens/tutors/favorite-tutors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key, required this.seclectPage}) : super(key: key);

  final Function seclectPage;

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var api;
  var userDetail;

  @override
  void didChangeDependencies() async {
    api = Api().api;
    try {
      var respDetail = await api.get('/user/info');
      setState(() {
        userDetail = respDetail.data['user'];
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

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    _profileItem() {
      final imageFile = File(userDetail['avatar']);

      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, Profile.routeName);
            },
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: CircleAvatar(
                        child: ClipOval(
                          child: userDetail['avatar'] == ''
                              ? Image.network(
                                  'https://media.istockphoto.com/photos/businessman-silhouette-as-avatar-or-default-profile-picture-picture-id476085198?k=20&m=476085198&s=612x612&w=0&h=8J3VgOZab_OiYoIuZfiMIvucFYB8vWYlKnSjKuKeYQM=',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  imageFile,
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
                            userDetail['name'],
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              userDetail['email'],
                              style: const TextStyle(
                                  fontSize: 12, color: Color(0xFF616161)),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
            ),
          ),
        ),
      );
    }

    _changePasswordItem() {
      return Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            child: Row(
              children: [
                Icon(
                  Icons.key,
                  color: Theme.of(context).primaryColor,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    AppLocalizations.of(context)!.changePassword,
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            ),
            style: ElevatedButton.styleFrom(
                primary: Theme.of(context).scaffoldBackgroundColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50))),
          ),
        ),
      );
    }

    _coursesItem() {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, FavoriteTutor.routeName);
            },
            child: Row(
              children: [
                Icon(
                  Icons.favorite_border_outlined,
                  color: Theme.of(context).primaryColor,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    AppLocalizations.of(context)!.favoriteTutors,
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            ),
            style: ElevatedButton.styleFrom(
                elevation: 3,
                primary: Theme.of(context).scaffoldBackgroundColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50))),
          ),
        ),
      );
    }

    _becomeTutorItem() {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/become-tutor');
            },
            child: Row(
              children: [
                Icon(
                  Icons.work,
                  color: Theme.of(context).primaryColor,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    AppLocalizations.of(context)!.becomeATutor,
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            ),
            style: ElevatedButton.styleFrom(
                elevation: 3,
                primary: Theme.of(context).scaffoldBackgroundColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50))),
          ),
        ),
      );
    }

    _changeLanguageItem() {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              languageProvider.changeLocale();
            },
            child: Row(
              children: [
                Icon(
                  Icons.language,
                  color: Theme.of(context).primaryColor,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    AppLocalizations.of(context)!.changeLanguage(
                        languageProvider.locale == 'vi'
                            ? 'English'
                            : 'Ti???ng Vi???t'),
                    style: const TextStyle(color: Colors.black),
                  ),
                )
              ],
            ),
            style: ElevatedButton.styleFrom(
                elevation: 3,
                primary: Theme.of(context).scaffoldBackgroundColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50))),
          ),
        ),
      );
    }

    _changeThemeItem() {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              themeProvider.changeTheme();
            },
            child: Row(
              children: [
                Icon(
                  Icons.color_lens,
                  color: Theme.of(context).primaryColor,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    AppLocalizations.of(context)!.changeTheme,
                    style: const TextStyle(color: Colors.black),
                  ),
                )
              ],
            ),
            style: ElevatedButton.styleFrom(
                elevation: 3,
                primary: Theme.of(context).scaffoldBackgroundColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50))),
          ),
        ),
      );
    }

    _logoutItem() {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              userData.logout();
            },
            child: Row(
              children: [
                Icon(
                  Icons.logout,
                  color: Theme.of(context).primaryColor,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    AppLocalizations.of(context)!.logout,
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            ),
            style: ElevatedButton.styleFrom(
                elevation: 3,
                primary: Theme.of(context).scaffoldBackgroundColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50))),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: userDetail != null
            ? Column(
                children: <Widget>[
                  _profileItem(),
                  _changePasswordItem(),
                  _coursesItem(),
                  _becomeTutorItem(),
                  _changeLanguageItem(),
                  _changeThemeItem(),
                  _logoutItem()
                ],
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
