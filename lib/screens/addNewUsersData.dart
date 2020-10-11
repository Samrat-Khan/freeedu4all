import 'dart:io';

import 'package:education_community/services/firebase_service_for_setData.dart';
import 'package:education_community/services/photo_picker.dart';
import 'package:education_community/widgets/textStyle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AddNewUsersData extends StatefulWidget {
  final User user;

  AddNewUsersData({this.user});

  @override
  _AddNewUsersDataState createState() => _AddNewUsersDataState();
}

class _AddNewUsersDataState extends State<AddNewUsersData> {
  File fileImage;
  String displayName, aboutUser;
  String userPhotoUrl;

  bool isAllFieldEmpty = true;

  bool isUserEmailEmpty = true;
  String dummyText =
      "Spent a large portion of my life coding. Will do the same in the next life";
  TextEditingController _displayNameTextEditController =
      TextEditingController();
  TextEditingController _aboutUserTextEditController = TextEditingController();

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _displayNameTextEditController.dispose();
    _aboutUserTextEditController.dispose();
  }

  bool _inAsyncCall = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: _inAsyncCall,
        child: Scaffold(
          key: _key,
          appBar: AppBar(
            title: Text(
              "Update Bio",
              style: kSettingTitle,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                photoChooseContainer(),
                SizedBox(
                  height: 20,
                ),
                displayNameTextField(),
                SizedBox(
                  height: 10,
                ),
                userFixedEmailField(),
                SizedBox(
                  height: 10,
                ),
                aboutUserTextField(),
                SizedBox(
                  height: 10,
                ),
                MaterialButton(
                  color: Colors.black,
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: uploadUserDataToFireStore,
                ),
                Text(
                  "*All fields are mandatory",
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PhotoPicker photoPicker = PhotoPicker();

  imagePicFromGallery() async {
    fileImage = await photoPicker.pickImageFromGallery();
  }

  checkTextFieldEmptyOrNot() {
    if (_displayNameTextEditController.text.isEmpty == true ||
        fileImage == null ||
        _aboutUserTextEditController.text.isEmpty) {
      setState(() {
        isAllFieldEmpty = true;
      });
    } else {
      setState(() {
        isAllFieldEmpty = false;
      });
    }
  }

  uploadUserDataToFireStore() async {
    checkTextFieldEmptyOrNot();
    setState(() {
      _inAsyncCall = true;
    });
    try {
      FirebaseServiceSetData fireBaseService = FirebaseServiceSetData();

      if (isAllFieldEmpty == true) {
        final snackBar = SnackBar(
          content: Text("Fields are empty"),
        );
        _key.currentState.showSnackBar(snackBar);
        setState(() {
          _inAsyncCall = false;
        });
      } else {
        userPhotoUrl = await fireBaseService
            .uploadUserProfilePhotoToFireStorage(fileImage, widget.user.uid);

        fireBaseService
            .updateUserDataToFirebase(
          displayName: displayName,
          aboutUser: aboutUser,
          userEmail: widget.user.email,
          photoUrl: userPhotoUrl,
          uid: widget.user.uid,
        )
            .whenComplete(() {
          Navigator.of(context).pushNamed(
            "BottomAppBar",
          );
          setState(() {
            _inAsyncCall = false;
          });
        });
      }
    } catch (e) {
      final snackBar = SnackBar(
        content: Text(e.message),
      );
      _key.currentState.showSnackBar(snackBar);
      setState(() {
        _inAsyncCall = false;
      });
    }
  }

  photoChooseContainer() {
    return Container(
      height: 110,
      width: 110,
      child: InkWell(
        child: Stack(
          children: [
            Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                image: DecorationImage(
                  image: fileImage == null
                      ? AssetImage("images/14.png")
                      : FileImage(fileImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              child: IconButton(
                  icon: Icon(
                    Icons.add_photo_alternate_rounded,
                    size: 30,
                    color: Colors.black,
                  ),
                  onPressed: imagePicFromGallery),
              bottom: 10,
              right: 7,
            ),
          ],
        ),
        onTap: imagePicFromGallery,
      ),
    );
  }

  Container displayNameTextField() {
    return Container(
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
        controller: _displayNameTextEditController,
        onChanged: (String text) {
          displayName = text;
        },
      ),
    );
  }

  Container userFixedEmailField() {
    return Container(
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
    );
  }

  Container aboutUserTextField() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.black)),
      child: TextField(
        maxLines: 5,
        maxLength: 110,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          hintText: dummyText,
          border: InputBorder.none,
          labelText: "About Yourself",
        ),
        controller: _aboutUserTextEditController,
        onChanged: (String text) {
          aboutUser = text;
        },
      ),
    );
  }
}
