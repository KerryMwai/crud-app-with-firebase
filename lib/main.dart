import 'package:crudappwithfirebase/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void>main() async{
  WidgetsFlutterBinding.ensureInitialized();
  var options=const FirebaseOptions(
    apiKey: "AIzaSyANSDz6JQau_J-jRkOg2qjuzSG1AJzv5qQ", 
    appId: "1:972089465483:android:a0fad70544bf5f542ed28e", 
    messagingSenderId: "972089465483",
     projectId: "farm-management-system-548dc");
  await Firebase.initializeApp(options: options);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CRUD Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}


