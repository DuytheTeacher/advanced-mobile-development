import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  DateTime selectedDate = DateTime.now();
  TextEditingController phoneController = TextEditingController();

  _infoSection() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            child: ClipOval(
              child: Image.network(
                'https://api.app.lettutor.com/avatar/4d54d3d7-d2a9-42e5-97a2-5ed38af5789aavatar1627913015850.00',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            radius: 30,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Account name',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const Text(
            'account@email.com.vn',
            style: TextStyle(color: Colors.grey),
          )
        ],
      ),
    );
  }

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
                  onPressed: () {
                    _selectDate(context);
                  },
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text("${selectedDate.toLocal()}".split(' ')[0],
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
              items: <String>['Vietnam', 'US', 'UK'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (_) {},
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
              items: <String>['Beginner', 'Intermediate', 'Advanced']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (_) {},
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              _infoSection(),
              _birthdaySection(context),
              _phoneSection(phoneController),
              _countrySection(),
              _levelSection(),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Save'),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
