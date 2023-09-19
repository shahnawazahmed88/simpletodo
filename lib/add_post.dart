import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_tools/utils.dart';
import 'package:flutter/material.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final databaseRef = FirebaseDatabase.instance.ref('Post');
  final postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add post'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            TextFormField(
              maxLines: 4,
              controller: postController,
              decoration: InputDecoration(
                  hintText: 'What is in your mind?',
                  border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                String id = DateTime.now().microsecondsSinceEpoch.toString();
                databaseRef
                    .child(id)
                    .set({
                      'title': postController.text.toString().trim(),
                      'id': id
                    })
                    .then((value) => Utils.showSnackBar('Post Added'))
                    .onError((error, stackTrace) =>
                        Utils.showSnackBar(error.toString()));
              },
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
