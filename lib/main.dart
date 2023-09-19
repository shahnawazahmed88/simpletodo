import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tools/utils.dart';
import 'package:flutter/material.dart';

import 'auth_page.dart';
import 'home_page.dart';
import 'login_widget.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
final navigatorKey = GlobalKey<NavigatorState>();
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: Utils.messengerKey,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Firebase Tools',
      theme: ThemeData(
        // is not restarted.
        primarySwatch: Colors.teal,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return  Center(child: CircularProgressIndicator(),);
          }else if(snapshot.hasError) {
            return Center(child: Text('Something went wrong!', style: TextStyle(fontSize: 20),),);
          }else if(snapshot.hasData){
            return HomePage();
          }else{
            return AuthPage();
          }
        },
      )

    );
  }
}

