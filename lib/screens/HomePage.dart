import 'package:education_community/screens/blogPost.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Homepage extends StatefulWidget {
  final GoogleSignInAccount user;
  Homepage({this.user});
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text("Hello"),
          centerTitle: true,
          elevation: 0,
        ),
        body: ListView.separated(
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: ClipRRect(
                    child: Image.asset("images/14.png"),
                  ),
                  title: Text(
                    data,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text("By Samrat Khan"),
                  trailing: Icon(Icons.gavel_outlined),
                ),
              );
            },
            separatorBuilder: (context, index) => Divider(),
            itemCount: 13),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => BlogPost()));
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  String data =
      "usihhsslkjhsokkhfkjiodhfiohflkh;lkfhoihfsoihlkhklhkkfloksh;ffhkjfhkhfkhkjhfkhfvkljhfkjhifhk;sfhdk;hfkh";
}
