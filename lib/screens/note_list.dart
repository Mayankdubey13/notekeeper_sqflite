import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_demo/models/notes.dart';
import 'package:sqflite_demo/screens/note_detail.dart';
import 'package:sqflite_demo/utils/custom_toast.dart';
import 'package:sqflite_demo/utils/database_helper.dart';

import 'note_details_.dart';

class NoteList extends StatefulWidget {
  const NoteList({super.key});

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Notes>? noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = [];
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          debugPrint("FAB clicked");
          DatabaseHelper obj = DatabaseHelper();
          // navigateToDetail(Notes('', 2, ''), 'ADD NOTE');
          var result = await Navigator.push(context, MaterialPageRoute(builder: (context)=>NoteDetails2()));
          noteList = await obj.getNoteList();
          // result == 1? CustomToast(context: context, message: "Success", iconData: Icons.confirmation_num_sharp, iconColor: Colors.red) : CustomToast(context: context, message: "Failed", iconData: Icons.confirmation_num_sharp, iconColor: Colors.red);
          // CustomToast(context: context, message: result.toString(), iconData: Icons.confirmation_num_sharp, iconColor: Colors.red);
         updateListView();
        },
        tooltip: 'Add Note',
        child: const Icon(Icons.add),
      ),
    );
  }

  ListView getNoteListView() {
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: getPriorityColor(noteList![position].priority),
                child: getPriorityIcon(noteList![position].priority),
              ),
              title: Text("${noteList![position].title}"),
              subtitle: Text("${noteList![position].description}  ${noteList![position].date} "),
              trailing: InkWell(
                child: const Icon(
                  Icons.delete,
                  color: Colors.grey,
                ),
                onTap: () {
                  _delete(context, noteList![position]);
                },
              ),
              onTap: () {
                debugPrint("ListTile Tapped");
                navigateToDetail(noteList![position], 'EDIT NOTE');

              },
            ),
          );
        });
  }

  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.yellow;
      default:
        return Colors.yellow;
    }
  }

  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return const Icon(Icons.play_arrow);
      case 2:
        return const Icon(Icons.keyboard_arrow_right);
      default:
        return const Icon(Icons.keyboard_arrow_right);
    }
  }

  void _delete(BuildContext context, Notes note) async {
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Note deleted successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Notes? notes, String appBarTitle) async {
    int result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(notes!, appBarTitle);
     })
    );
    if(result == 1) updateListView();

    // await Navigator.push(context, MaterialPageRoute(builder: (context) => NoteDetail(notes!, 'Edit Note')));
  }

  void updateListView() async {
    final Future<Database> dbFuture = databaseHelper.intializeDatabase();
    dbFuture.then((database) async
    {
      Future<List<Notes>> noteListFuture = databaseHelper.getNoteList().then((value) async {
        Future<List<Notes>> noteListFuture = databaseHelper.getNoteList();
        noteList = await noteListFuture;
        count = noteList!.length;
        return value;
      });
     }
    );
    Future<List<Notes>> noteListFuture = databaseHelper.getNoteList();
    noteList = await noteListFuture;
    count = noteList!.length;
    setState(() {
    });

  }
}
