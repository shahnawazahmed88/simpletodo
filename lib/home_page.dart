import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_tools/add_post.dart';
import 'package:firebase_tools/profile_page.dart';
import 'package:firebase_tools/utils.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbRef = FirebaseDatabase.instance.ref('Post');
  final searchFilter = TextEditingController();
  final editController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfilePage()));
              },
              child: Icon(
                Icons.person,
                size: 26.0,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
              child: Icon(
                Icons.logout,
                size: 26.0,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Fetching Firebase realtime data to list using SteamBuilder
            /*Expanded(child: StreamBuilder(
              stream: dbRef.onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {

                if(!snapshot.hasData){
                  return CircularProgressIndicator();
                }else{
                  Map<dynamic,dynamic> map = snapshot.data!.snapshot.value as dynamic;
                  List<dynamic> list = [];
                  list.clear();
                  list=map.values.toList();
                  return ListView.builder(
                      itemCount: snapshot.data!.snapshot.children.length,
                      itemBuilder: (context, index){
                        return ListTile(
                            title:Text(list[index]['title']),
                          subtitle: Text(list[index]['id']),
                        );
                      });
                }

            },
            )),
            SizedBox(
              height: 20.0,
              width: 150.0,
              child: Divider(
                thickness: 1.0,
                color: Colors.teal.shade100,
              ),
            ),*/
            TextFormField(
              controller: searchFilter,
              decoration: InputDecoration(
                  hintText: 'Search',
                  border: OutlineInputBorder()
              ),
              onChanged: (String value){
                setState(() {
                });
              },
            ),
            Expanded(
              child: FirebaseAnimatedList(
                  query: dbRef,
                  defaultChild: Text('Loading...'),
                  itemBuilder: (context, snapshot, animation, index) {
                    final title = snapshot.child('title').value.toString();
                    final id = snapshot.child('id').value.toString();
                    if(searchFilter.text.isEmpty){
                      return ListTile(
                        title: Text(snapshot
                            .child('title')
                            .value
                            .toString()),
                        subtitle: Text(snapshot
                            .child('id')
                            .value
                            .toString()),
                        trailing: PopupMenuButton(
                          icon: Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value:1,
                              child: ListTile(
                                onTap: (){
                                  Navigator.pop(context);
                                  showMyDialog(title,id);
                                },
                                leading: Icon(Icons.edit),
                                title: Text('Edit'),
                              ),),
                            PopupMenuItem(
                              value:2,
                              child: ListTile(
                                leading: Icon(Icons.delete),
                                title: Text('Delete'),
                                onTap: (){
                                  Navigator.pop(context);
                                  dbRef.child(id).remove();
                                },
                              ),),
                          ],
                        ),
                      );
                    }else if(title.toString().toLowerCase().contains(searchFilter.text.toLowerCase())){
                      return ListTile(
                        title: Text(snapshot
                             .child('title')
                            .value
                            .toString()),
                        subtitle: Text(snapshot
                            .child('id')
                            .value
                            .toString()),
                      );
                    }else{
                      return Container();
                    }

                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddPost()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
  Future<void> showMyDialog(String title, String id) async{
    editController.text = title;
return showDialog(context: context,
    builder: (BuildContext context){
  return AlertDialog(
   title: Text('Update'),
    content: Container(
    child: TextField(
      controller: editController,
      decoration: InputDecoration(
        hintText: 'Edit'
      ),
    ),
    ),
    actions: [
      TextButton(onPressed: (){
      Navigator.pop(context);
      }, child: Text('Cancel'),),
      TextButton(onPressed: (){
        Navigator.pop(context);
        dbRef.child(id).update({
          'title': editController.text.toString()
        }).then((value) => {
          Utils.showSnackBar('Post Updated')
        }).onError((error, stackTrace) => {
        Utils.showSnackBar(error.toString())
        });
      }, child: Text('Update'),),
    ],
  );
    });
  }
}
