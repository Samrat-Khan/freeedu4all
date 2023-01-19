import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_community/routes/routeDataPass.dart';
import 'package:education_community/services/firebaseUpdataDeleteData.dart';
import 'package:education_community/services/user_service.dart';
import 'package:education_community/widgets/textStyle.dart';
import 'package:flutter/material.dart';

class DraftPost extends StatefulWidget {
  @override
  _DraftPostState createState() => _DraftPostState();
}

class _DraftPostState extends State<DraftPost> {
  String currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUser = firebaseAuth.currentUser.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Draft Post",
          style: kSettingTitle,
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("DraftBlog")
            .where("BlogOwnerId", isEqualTo: currentUser)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.separated(
            itemBuilder: (context, index) {
              DocumentSnapshot<Map<String, dynamic>> ds =
                  snapshot.data.docs[index];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: ds.data()["BlogPhotoUrl"] == null
                      ? Image.asset(
                          "images/post.png",
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          ds.data()["BlogPhotoUrl"],
                          fit: BoxFit.cover,
                        ),
                ),
                title: Text(
                  ds.data()["BlogTitle"] == null
                      ? "You Haven't specify any title yet"
                      : ds.data()["BlogTitle"],
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(ds.data()["DateTime"]),
                isThreeLine: true,
                trailing: PopupMenuButton(
                  onSelected: (value) {
                    handelSelect(
                      value: value,
                      currentUser: currentUser,
                      blogPhotoUrl: ds.data()["BlogPhotoUrl"],
                      blogUid: ds.data()["BlogUid"],
                      blogDetail: ds.data()["BlogDetail"],
                      blogTitle: ds.data()["BlogTitle"],
                    );
                  },
                  itemBuilder: (context) {
                    return {"Edit", "Delete"}.map((String choice) {
                      return PopupMenuItem(
                        child: Text(choice),
                        value: choice,
                      );
                    }).toList();
                  },
                ),
              );
            },
            separatorBuilder: (context, index) => Divider(
              thickness: 2,
              indent: 12,
              endIndent: 12,
            ),
            itemCount: snapshot.data.docs.length,
          );
        },
      ),
    );
  }

  handelSelect(
      {String value,
      String blogUid,
      String currentUser,
      String blogPhotoUrl,
      String blogTitle,
      String blogDetail}) {
    switch (value) {
      case "Edit":
        return Navigator.pushNamed(context, "DraftBlogEditPage",
            arguments: DraftToDraftEdit(
              blogUid: blogUid,
              blogPhoto: blogPhotoUrl,
              blogTitle: blogTitle,
              blogDetail: blogDetail,
            ));
      case "Delete":
        return deletePost(
          blogUid: blogUid,
          currentUserId: currentUser,
          blogPhotoUrl: blogPhotoUrl,
        );
    }
  }

  Delete _delete = Delete();
  deletePost(
      {String blogUid, String currentUserId, String blogPhotoUrl}) async {
    await _delete.deleteDaftBlog(
      blogUid: blogUid,
      currentUserId: currentUserId,
      blogPhotoUrl: blogPhotoUrl,
    );
  }
}
