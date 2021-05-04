import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:getx_test_app/models/post.dart';

class HomeController extends GetxController {
  final appBarTitle = 'Awesome Posts';
  final postsStream =
      FirebaseFirestore.instance.collection('posts').snapshots();
  //Currently not in use.
  // List<Post> _posts = [];
  //Currently not in use.
  // List<Post> get posts => [..._posts];
  //Currently not in use.
}
