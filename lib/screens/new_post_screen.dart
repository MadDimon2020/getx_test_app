import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_test_app/screens/home_screen.dart';
import 'package:intl/intl.dart';

class NewPostScreen extends StatefulWidget {
  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _postBodyController = TextEditingController();
  var _enteredTitle = '';
  var _enteredPostBody = '';
  final _user = FirebaseAuth.instance.currentUser;

  void _createPost() async {
    final users = await FirebaseFirestore.instance
        .collection('users')
        .doc(_user.uid)
        .get();
    final isValid = _formKey.currentState.validate();
    if (isValid) {
      _formKey.currentState.save();
      FirebaseFirestore.instance.collection('posts').add({
        'title': _enteredTitle,
        'body': _enteredPostBody,
        'createdAt': Timestamp.now(),
        // This is to ensure ordering chronologically
        'date': DateFormat('EEEE dd LLL yyyy').format(DateTime.now()),
        'userId': _user.uid,
        'userName': users.data()['username'],
      });

      _titleController.clear();
      _postBodyController.clear();

      /// This might be redundant, since it is asserted
      /// that using an anonymous funcion inside the Get.offAll call
      /// should delete all the relevant controllers.

      Get.offAll(() => HomeScreen());
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Post'),
        actions: [
          Container(
            margin: EdgeInsets.all(10),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).accentColor),
              ),
              child: Text('Publish'),
              onPressed: _createPost,
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.grey[700]),
              ),
              child: Text('Cancel'),
              onPressed: () => Get.offAll(() => HomeScreen()),
            ),
          ),
        ],
      ),
      body: Card(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter the title of your post.';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                textCapitalization: TextCapitalization.words,
                onSaved: (value) {
                  _enteredTitle = value;
                },
              ),
              Expanded(
                child: TextFormField(
                  controller: _postBodyController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some description.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Description',
                    alignLabelWithHint: true,
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.multiline,
                  minLines: 10,
                  maxLines: null,
                  onSaved: (value) {
                    _enteredPostBody = value;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
