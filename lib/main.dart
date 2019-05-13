import 'package:flutter/material.dart';
import 'package:flutter_notekeeper/screens/note_details.dart';
import 'package:flutter_notekeeper/screens/note_list.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Note Keeper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple
      ),
      home : NoteList(),

    );
  }

}


