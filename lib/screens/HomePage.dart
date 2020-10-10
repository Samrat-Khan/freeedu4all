import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_community/routes/routeDataPass.dart';
import 'package:education_community/widgets/loadingWidget.dart';
import 'package:education_community/widgets/textStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "Edu Community",
            style: kAppTitle,
          ),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Blog")
              .orderBy("TimeStamp", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: LoadingWidget());
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: LoadingWidget());
            } else
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
                              height: 90,
                              width: 90,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image:
                                        NetworkImage(ds.data()["BlogPhotoUrl"]),
                                    fit: BoxFit.cover,
                                  )),
                            ),
                            SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  ds.data()["BlogType"],
                                  style: kTimelineBlogType,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.9,
                                  child: Text(
                                    ds.data()["BlogTitle"],
                                    softWrap: true,
                                    overflow: TextOverflow.fade,
                                    style: kTimelineBlogTitle,
                                  ),
                                ),
                                Text(ds.data()["DateTime"]),
                              ],
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
}
