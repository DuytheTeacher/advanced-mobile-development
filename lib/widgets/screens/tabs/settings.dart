import 'package:advanced_mobile_dev/providers/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key, required this.seclectPage}) : super(key: key);

  final Function seclectPage;

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserProvider>(context);

    _profileItem() {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: CircleAvatar(
                        child: ClipOval(
                          child: Image.network(
                            'https://api.app.lettutor.com/avatar/4d54d3d7-d2a9-42e5-97a2-5ed38af5789aavatar1627913015850.00',
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
                        children: const <Widget>[
                          Text(
                            'Account name',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              'acount@email.com.vn',
                              style: TextStyle(
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
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    'Change password',
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
              widget.seclectPage(3);
            },
            child: Row(
              children: [
                Icon(
                  Icons.menu_book_sharp,
                  color: Theme.of(context).primaryColor,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    'Courses',
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
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    'Become a tutor',
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
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    'Logout',
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
        child: Column(
          children: <Widget>[
            _profileItem(),
            _changePasswordItem(),
            _coursesItem(),
            _becomeTutorItem(),
            _logoutItem()
          ],
        ),
      ),
    );
  }
}
