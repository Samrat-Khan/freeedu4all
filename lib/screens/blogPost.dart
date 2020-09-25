import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlogPost extends StatefulWidget {
  @override
  _BlogPostState createState() => _BlogPostState();
}

class _BlogPostState extends State<BlogPost> {
  String problemText, postTitleText, postDetailText;
  File imageFile;
  bool isAllFieldEmpty = true;

  TextEditingController _titleTextController = TextEditingController();
  TextEditingController _detailTextController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _detailTextController.dispose();
    _titleTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: postAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            photoUploadContainer(_width, _height),
            SizedBox(
              height: 25,
            ),
            postTitleWriteBox(),
            SizedBox(
              height: 25,
            ),
            postDetailWriteBox(),
            SizedBox(
              height: 25,
            ),
            problemText == null ? SizedBox(height: 5) : Text(problemText),
            SizedBox(
              height: 20,
            ),
            postTypeSelectRow(),
          ],
        ),
      ),
    );
  }

  checkTextFieldEmptyOrNot() {
    if (_titleTextController.text.isEmpty ||
        _detailTextController.text.isEmpty ||
        imageFile == null ||
        problemText == null) {
      setState(() {
        this.isAllFieldEmpty = true;
      });
    } else {
      setState(() {
        this.isAllFieldEmpty = false;
      });
    }
  }

  fillAllDataFieldsAlert(BuildContext context) {}

  dataUploadToFirebase() {}

  AppBar postAppBar() {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Text("Write Post"),
      leading: IconButton(
        icon: Icon(Icons.cancel),
        onPressed: () {
          _detailTextController.dispose();
          _titleTextController.dispose();
          imageFile = null;
          Navigator.pop(context);
        },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.cloud_upload),
          onPressed: isAllFieldEmpty == true
              ? fillAllDataFieldsAlert(context)
              : dataUploadToFirebase,
        ),
      ],
    );
  }

  InkWell photoUploadContainer(double _width, double _height) {
    return InkWell(
      child: Container(
        width: _width,
        height: _height / 5,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageFile == null
                ? AssetImage("images/no-image.jpg")
                : FileImage(imageFile),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            child: Text("Click To Upload a Photo"),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.5)),
          ),
        ),
      ),
    );
  }

  Container postTitleWriteBox() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.black)),
      child: TextField(
        decoration: InputDecoration(
          hintText: "What is Dark Matter ?",
          labelText: "Title of Your Post",
          border: InputBorder.none,
        ),
        textInputAction: TextInputAction.next,
        controller: _titleTextController,
        onChanged: (String text) {
          setState(() {
            postTitleText = text;
          });
        },
      ),
    );
  }

  Container postDetailWriteBox() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.black)),
      child: TextField(
        decoration: InputDecoration(
          hintText: "All about Dark Matter....",
          labelText: "Detail of Your Post",
          border: InputBorder.none,
        ),
        //  textInputAction: TextInputAction.done,
        maxLength: 10000,
        maxLines: 10,
        controller: _detailTextController,
        onChanged: (String text) {
          setState(() {
            postDetailText = text;
          });
        },
      ),
    );
  }

  Row postTypeSelectRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        OutlineButton(
          splashColor: Color(0xffd788d7),
          borderSide: BorderSide(
            color: Color(0xff07689f),
            width: 1.5,
          ),
          child: Text("Help"),
          onPressed: () {
            setState(() {
              problemText = "Help";
            });
          },
        ),
        OutlineButton(
          splashColor: Color(0xff9d65ca),
          borderSide: BorderSide(
            color: Color(0xfffec93b),
            width: 1.5,
          ),
          child: Text("Solution"),
          onPressed: () {
            setState(() {
              problemText = "Solution";
            });
          },
        ),
        OutlineButton(
          splashColor: Color(0xff5d54a3),
          borderSide: BorderSide(
            color: Color(0xffa2d5f2),
            width: 1.5,
          ),
          child: Text("Info"),
          onPressed: () {
            setState(() {
              problemText = "Info";
            });
          },
        ),
      ],
    );
  }
}
