import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_community/services/firebase_service_for_setData.dart';
import 'package:education_community/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CommentPage extends StatefulWidget {
  final String blogUID;
  CommentPage({this.blogUID});
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  String commentID = Uuid().v1();
  String commentText,
      commentedUserName,
      commentedUseID,
      commentedUserPhotoUrl,
      currentUserId;
  TextEditingController _commentEditingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUserId = firebaseAuth.currentUser.uid;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _commentEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: Colors.white,
        title: Text(
          "Comments",
          style: TextStyle(color: Colors.black),
        ),
      ),
      bottomNavigationBar: callCommentTextField(),
      body: showCommentOfUsers(),
    );
  }

  Container showCommentOfUsers() {
    return Container(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Comments")
            .orderBy("TimeStamp", descending: false)
            .where("BlogUID", isEqualTo: widget.blogUID)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("No Comments Yet");
          }
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.documents[index];
              return Container(
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: FadeInImage(
                      height: 30,
                      width: 30,
                      fit: BoxFit.cover,
                      placeholder: AssetImage("images/profile.png"),
                      image: NetworkImage(ds.data()["CommentUserPhoto"]),
                    ),
                  ),
                  title: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      title: Text(ds.data()["CommentUserName"]),
                      subtitle: Text(ds.data()["Comment"]),
                      isThreeLine: true,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  BottomAppBar callCommentTextField() {
    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text("Click To Add Comment"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(
                Icons.add_box_rounded,
                size: 30,
              ),
              onPressed: () => showCommentBottomSheet(),
            ),
          ),
        ],
      ),
    );
  }

  void showCommentBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height / 2,
            // color: Color(0xff737373),
            child: Container(
              padding: EdgeInsets.all(25),
              child: TextField(
                autofocus: true,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "Your Comment",
                  suffixIcon: IconButton(
                      icon: Icon(Icons.send), onPressed: submitComment),
                ),
                controller: _commentEditingController,
                onChanged: (text) {
                  commentText = text;
                },
              ),
            ),
          );
        });
  }

  submitComment() {
    FirebaseSetData firebaseServiceSetData = FirebaseSetData();
    firebaseServiceSetData
        .addCommentToBlog(
      userId: currentUserId,
      comment: commentText,
      blogUID: widget.blogUID,
    )
        .whenComplete(() {
      Navigator.pop(context);
      _commentEditingController.clear();
      commentText = "";
    });
  }
}
