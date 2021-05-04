import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_test_app/screens/new_post_screen.dart';
import 'package:getx_test_app/controllers/home_controller.dart';
import 'package:getx_test_app/screens/post_details_screen.dart';

class HomeScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.appBarTitle),
        actions: [
          DropdownButton(
            underline: SizedBox(),
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Logout'),
                    ],
                  ),
                ),
                value: 'logout',
              ),
            ],
            onChanged: (value) {
              if (value == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            final loadedPosts = streamSnapshot.data.docs;
            return ListView.builder(
              itemCount: loadedPosts.length,
              itemBuilder: (context, index) {
                return InkWell(
                  splashColor: Theme.of(context).primaryColor,
                  child: Card(
                    color: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    elevation: 5.0,
                    margin: EdgeInsets.all(10.0),
                    child: ListTile(
                      title: Text(
                        loadedPosts[index]['title'],
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Posted on: ${loadedPosts[index]['date']}',
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        'Posted by: ${loadedPosts[index]['userName']}',
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  onTap: () => Get.to(
                    () => PostDetailsScreen(),
                    arguments: [
                      loadedPosts[index]['title'],
                      loadedPosts[index]['body'],
                      loadedPosts[index]['userName'],
                      loadedPosts[index]['userId'],
                    ],
                  ),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.post_add),
        tooltip: 'Create a new post',
        onPressed: () => Get.to(() => NewPostScreen()),
      ),
    );
  }
}
