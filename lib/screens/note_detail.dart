import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_demo/utils/custom_toast.dart';
import 'package:sqflite_demo/utils/database_helper.dart';

import '../models/notes.dart';

class NoteDetail extends StatefulWidget {
  final String title;
  final Notes? notes;

  const NoteDetail(this.notes, this.title, {super.key});
  @override
  State<NoteDetail> createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  static final _priorities = ["High", "Low"];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DatabaseHelper helper = DatabaseHelper();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: ListView(
          children: [

            /// DropDown Button
            ListTile(
              title: DropdownButton(
                items: _priorities.map(
                  (String dropDownStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Text(dropDownStringItem),
                    );
                  },
                ).toList(),
                value: getPriorityAsString(widget.notes!.priority),
                onChanged: (valueSelectedByUser) {
                  setState(() {
                    debugPrint("User selected $valueSelectedByUser");
                    updatePriorityAsInt(valueSelectedByUser!);
                  });
                },
              ),
            ),

            // Second Element
            // Title TextField
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: titleController,
                decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),

            //Third Element
            // Description TextField
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),

            //Fourth Element
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Row(
                children: [

                  // Save Note Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        _save();
                        debugPrint("Save button clicked");
                      },
                      child: const Text('Save', textScaleFactor: 1.5),
                    ),
                  ),

                  const SizedBox(
                    width: 5,
                  ),

                  // Delete Note Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        debugPrint("Delete button clicked");
                        _delete();
                      },
                      child: const Text('Delete', textScaleFactor: 1.5),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        widget.notes!.priority = 1;
        break;
      case 'Low':
        widget.notes!.priority = 2;
        break;
    }
  }

  String? getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0]; //High
        break;
      case 2:
        priority = _priorities[1]; //Low
        break;
    }
    return null;
  }

  void updateTitle() {
    widget.notes!.title = titleController.text.toString();
  }

  void updateDescription() {
    widget.notes!.description = descriptionController.text.toString();
  }

  void _save() async {
    widget.notes!.date != DateFormat.yMMMd().format(DateTime.now());
    updateTitle();
    updateDescription();

    DatabaseHelper databaseHelper = DatabaseHelper();
    // CustomToast(context: context, iconColor: Colors.black, iconData: Icons.notifications, message: widget.notes!.title.toString());
    int result;
    if (widget.notes!.id != null)
    {
      result = await helper.updateNote(widget.notes!);
    }
    else
    {
      result = await helper.insertNote(widget.notes!);
    }

    if (result != 0)
    {
      Navigator.pop(context,result);
      // CustomToast(context: context, iconColor: Colors.black, iconData: Icons.notifications, message: "Note Updated");
    } 
    else 
    {
      _showAlertDialog('Status', 'Problem saving notes' + result.toString());
    }
    
  }

  void _delete() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    int result = await databaseHelper.deleteNote(widget.notes!.id);
    if (result != 0) {
      Navigator.pop(context, result);
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
