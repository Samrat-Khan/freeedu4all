import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Container(
          height: _height / 4,
          width: _width / 4,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/loading.gif"),
            ),
          ),
        ),
      ),
    );
  }
}
