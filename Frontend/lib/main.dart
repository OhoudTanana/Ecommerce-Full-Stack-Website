import 'package:ecommerce/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//entry point of flutter app
void main() {
  runApp(const MyApp());
}

//MyApp is the Root of widget tree
//MaterialApp is the direct child of MyApp
class MyApp extends StatelessWidget {
  const MyApp({super.key});

// This widget is the root of your application.
//every statelessWidget child should override the build method
//this method describes the UI parts, we build the widgets subtree below it
  @override
  Widget build(BuildContext context) {
    //this widget is the root of the app, wraps a nb of commonly used widgets for material design, visual structure and setting
    //its comonly used as the root app
    return MaterialApp(
      //title of the app
      title: 'Admin Panel',
      //to hide the debug banner, that appears when debugging
      debugShowCheckedModeBanner: false,
      //defines the visual theme of the app
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
        //font
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        //allows us to use new designs and themes.. in our app
        useMaterial3: true,
      ),
      //first widget displayed when we start the app
      home: const HomePage(),
    );
  }
}

//validations: frontend backend
//