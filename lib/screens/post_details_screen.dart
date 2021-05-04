import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostDetailsScreen extends StatelessWidget {
  final postTitle = Get.arguments[0].toString();
  final postBody = Get.arguments[1].toString();
  final author = Get.arguments[2].toString();
  final userId = Get.arguments[3].toString();
  final currentUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Row(
              children: [
                if (userId == currentUser.uid)
                  ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                      elevation: MaterialStateProperty.all(5.0),
                    ),
                    icon: Icon(Icons.edit),
                    label: Text('Edit'),
                    onPressed: () {},
                    //TODO Implement Editing
                  ),
                SizedBox(
                  width: 5.0,
                ),
                ElevatedButton.icon(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green[500])),
                  icon: Icon(Icons.share),
                  label: Text('Share'),
                  onPressed: () {},
                  //TODO Implement Sharing
                ),
                SizedBox(
                  width: 5.0,
                ),
                ElevatedButton.icon(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue[700])),
                  icon: Icon(Icons.comment),
                  label: Text('Comment'),
                  onPressed: () {},
                  //TODO Implement Commenting on the post
                ),
              ],
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(10.0),
              child: Text(
                postTitle,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Text(
                'Created by: $author',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.deepPurpleAccent,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  width: double.infinity,
                  child: Text(
                    postBody,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
