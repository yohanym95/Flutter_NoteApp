import 'package:flutter/material.dart';
import 'package:flutter_notekeeper/models/note.dart';
import 'package:flutter_notekeeper/utils/DatabaseHelper.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  NoteDetail(this.note, this.appBarTitle);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NoteDetailState(this.note, this.appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
  DatabaseHelper helper = DatabaseHelper();
  

  static var priorities = ["High", "Low"];
  String appBarTitle;
  Note note;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionVController = TextEditingController();

  

  NoteDetailState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
  //  var count = note.priority;
    TextStyle textStyle = Theme.of(context).textTheme.title;

    titleController.text = note.title;
    descriptionVController.text = note.description;
    // TODO: implement build
    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                moveToLastScreen();
              },
            ),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: DropdownButton(
                    items: priorities.map(
                      (String dropdownItem) {
                        return DropdownMenuItem<String>(
                          value: dropdownItem,
                          child: Text(dropdownItem),
                        );
                      },
                    ).toList(),
                    style: textStyle,
                    value: getPriorityAsString(note.priority),
                    onChanged: (valueSelectedByUser) {
                      setState(() {
                        debugPrint('User Selected $valueSelectedByUser');
                        updatePriority(valueSelectedByUser);
                      });
                    },
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: TextField(
                      controller: titleController,
                      style: textStyle,
                      onChanged: (value) {
                        debugPrint('Something changed in Title Text Field');
                        updateTitle();
                      },
                      decoration: InputDecoration(
                          labelText: 'Title',
                          labelStyle: textStyle,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: TextField(
                      controller: descriptionVController,
                      style: textStyle,
                      onChanged: (value) {
                        debugPrint(
                            'Something changed in Discription Text Field');
                        updateDescription();
                      },
                      decoration: InputDecoration(
                          labelText: 'Discription',
                          labelStyle: textStyle,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            color: Theme.of(context).primaryColor,
                            textColor: Theme.of(context).primaryColorLight,
                            child: Text(
                              'Save',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                debugPrint('Save Button clicked');
                                _save();
                              });
                            },
                          ),
                        ),
                        Container(
                          width: 5.0,
                        ),
                        Expanded(
                          child: RaisedButton(
                            color: Theme.of(context).primaryColor,
                            textColor: Theme.of(context).primaryColorLight,
                            child: Text(
                              'Delete',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                debugPrint('Delete Button clicked');
                                _delete();
                              });
                            },
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          )),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context,true);
  }

  //Convert the String priority in the form of integer before saving it to database

  void updatePriority(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
      default :
        note.priority = 1;
        break;  
    }
  }

  //convert int priority to string priority and display it to user in dropdown
  String getPriorityAsString(int value) {
    String priority1;
    switch (value) {
      case 1:
        priority1 = priorities[0];
        break;
      case 2:
        priority1 = priorities[1];
        break;
      default :
        priority1 = priorities[0];
        break;   
    }
    return priority1;
  }

  void updateTitle() {
    note.title = titleController.text;
  }

  void updateDescription() {
    note.description = descriptionVController.text;
  }

  void _save() async {
    

    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.id != null) {
      result = await helper.updateNote(note);
    } else {
      result = await helper.insertNote(note);
    }

    moveToLastScreen();
    if (result != 0) {
      showAlertDialog('Status', 'Note saved successfully');
    } else {
      showAlertDialog('Status', 'Problem saving Note');
    }
  }

  void _delete() async{

    moveToLastScreen();
    //Case 1: If user is trying to delete the New Note 
    if(note.id == null){
      showAlertDialog('Status','No Note was deleted');
      return;
    }

    //case 2 user is trying to delete the old note that already has a vaild ID

    int result =await helper.deleteNote(note.id);

    if(result != 0){
      showAlertDialog('Status', 'Note Deleted Successfully');

    }else{
      showAlertDialog('Status', 'Error Occured while deleting Note');
    }


  }

  void showAlertDialog(String title, String message){
    AlertDialog alertDialog = AlertDialog(
      title:Text(title),
      content: Text(message),
    );
    showDialog(
      context: context,
      builder: (_)=>alertDialog);
  }

  
}
