import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_community/services/firebase_service_for_setData.dart';
import 'package:education_community/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CommentPage extends StatefulWidget {
  static const Route = "Comment_Page";
  final String blogUID;
  CommentPage({this.blogUID});
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  String commentID = Uuid().v1();
  String commentText, commentedUserName, commentedUseID, commentedUserPhotoUrl;
  TextEditingController _commentEditingController = TextEditingController();
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
                child: FutureBuilder(
                  future: getUserData(ds.data()["CommentPersonID"]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Comment Loading....");
                    }
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(commentedUserPhotoUrl),
                      ),
                      title: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          title: Text(commentedUserName),
                          subtitle: Text(ds.data()["Comment"]),
                          isThreeLine: true,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future getUserData(String userID) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection("Users").doc(userID).get();
    commentedUserName = snapshot.data()["DisplayName"];
    commentedUseID = snapshot.data()["UserID"];
    commentedUserPhotoUrl = snapshot.data()["PhotoUrl"];
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
    FirebaseServiceSetData firebaseServiceSetData = FirebaseServiceSetData();
    firebaseServiceSetData
        .addCommentToBlog(
      comment: commentText,
      commentPersonId: googleSignIn.currentUser.id,
      blogUID: widget.blogUID,
    )
        .whenComplete(() {
      Navigator.pop(context);
      _commentEditingController.clear();
      commentText = "";
    });
  }
}
