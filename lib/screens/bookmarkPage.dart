import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_community/routes/routeDataPass.dart';
import 'package:education_community/services/firebaseUpdataDeleteData.dart';
import 'package:education_community/services/user_service.dart';
import 'package:education_community/widgets/textStyle.dart';
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
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "Bookmarks",
            style: kBookmarkTitle,
          ),
        ),
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
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    child: Container(
                      height: MediaQuery.of(context).size.height / 7,
                      width: MediaQuery.of(context).size.width / 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 100,
                            width: 90,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: ds.data()["BlogPhotoUrl"] == null
                                      ? AssetImage("images/home.png")
                                      : NetworkImage(ds.data()["BlogPhotoUrl"]),
                                  fit: BoxFit.cover,
                                )),
                          ),
                          SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                ds.data()["BlogType"],
                                style: kTimelineBlogType,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 1.9,
                                child: Text(
                                  ds.data()["BlogTitle"],
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                  style: kTimelineBlogTitle,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(Icons.bookmark_rounded),
                            onPressed: () =>
                                handelBookmark(blogUID: ds.data()["BlogUid"]),
                          ),
                        ],
                      ),
                    ),
                    onTap: () async {
                      Navigator.of(context).pushNamed(
                        "BlogReadPage",
                        arguments: HomeToBlogRead(
                          blogUID: ds.data()["BlogUid"],
                          blogOwnerID: ds.data()["BlogOwnerId"],
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  FirebaseUpdateDeleteData _serviceUpdateData = FirebaseUpdateDeleteData();
  handelBookmark({String blogUID}) {
    _serviceUpdateData.handelBookmark(
      currentUserID: currentUser,
      isBookmarkChecked: false,
      blogUid: blogUID,
    );
  }
}
