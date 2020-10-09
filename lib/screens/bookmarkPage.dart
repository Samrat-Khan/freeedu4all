import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_community/services/user_service.dart';
import 'package:flutter/material.dart';

class BookMarkPage extends StatefulWidget {
  @override
  _BookMarkPageState createState() => _BookMarkPageState();
}

class _BookMarkPageState extends State<BookMarkPage> {
  String currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUser = firebaseAuth.currentUser.uid;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Blog")
              .where("Bookmark.$currentUser", isEqualTo: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.documents[index];
                return Container(
                  child: Text(ds.data()["BlogTitle"]),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
