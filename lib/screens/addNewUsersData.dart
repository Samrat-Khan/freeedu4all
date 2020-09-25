import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddNewUsersData extends StatefulWidget {
  final User user;
  AddNewUsersData({this.user});
  @override
  _AddNewUsersDataState createState() => _AddNewUsersDataState();
}

class _AddNewUsersDataState extends State<AddNewUsersData> {
  String _result;
  int _radioValue = 0;

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          _result = "ss";

          break;
        case 1:
          _result = "...";

          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Bio"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Container(
              height: 110,
              width: 110,
              child: Stack(
                children: [
                  Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  Positioned(
                    child: IconButton(
                        icon: Icon(
                          Icons.add_photo_alternate_rounded,
                          size: 25,
                          color: Colors.black,
                        ),
                        onPressed: null),
                    bottom: 10,
                    right: 7,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.black)),
              child: TextField(
                autofocus: true,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "John Doe",
                  labelText: "Full Name",
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.black)),
              child: TextField(
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: "ImGoogle",
                  border: InputBorder.none,
                  labelText: "Display Name",
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.black)),
              child: TextField(
                decoration: InputDecoration(
                  hintText: widget.user.email,
                  border: InputBorder.none,
                ),
                enabled: false,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text("I am"),
                Radio(
                    value: 0,
                    groupValue: _radioValue,
                    onChanged: _handleRadioValueChange),
                Text("Student"),
                SizedBox(
                  width: 10,
                ),
                Radio(
                    value: 1,
                    groupValue: _radioValue,
                    onChanged: _handleRadioValueChange),
                Text("Teacher"),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.black)),
              child: TextField(
                maxLines: 5,
                maxLength: 180,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: "Max 5 Lines",
                  border: InputBorder.none,
                  labelText: "About Yourself",
                ),
              ),
            ),
            MaterialButton(
              color: Colors.green,
              child: Text("Submit"),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
