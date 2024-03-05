import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_demo/models/notes.dart';
import 'package:sqflite_demo/utils/custom_toast.dart';

import '../utils/database_helper.dart';

class NoteDetails2 extends StatelessWidget {
  NoteDetails2({super.key});

  var controller1 = TextEditingController();
  var controller2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Item into list"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical:  20),
        child: Column(
          children: [
            TextFormField(
              controller: controller1,
              decoration: const InputDecoration(
                hintText: "Enter Title",
                
              ),
            ),
            SizedBox(height: 10,),

            TextFormField(
              controller: controller2,
              decoration: const InputDecoration(
                hintText: "Enter Desc",
              ),
            ),
            ElevatedButton(onPressed: () {
              saveItem(context);
            }, child: const Text("Save"))
          ],
        ),
      )
    );
  }
  saveItem(BuildContext context) async
  {
    var obj = DatabaseHelper();
    var text1 = controller1.text.toString();
    var result;
    var text2 = controller2.text.toString();
    if(text1.length > 1 && text2.length > 1)
    {
      result = await obj.insertNote(Notes(text1, 1, DateFormat.yMMMd().format(DateTime.now()),text2));
      CustomToast(context: context, message: result.toString(), iconData: Icons.confirmation_num_sharp, iconColor: Colors.red);
      Navigator.pop(context, result);
    }
    else
    {
      CustomToast(context: context, message: "Failed", iconData: Icons.content_cut_rounded, iconColor: Colors.black);
    }

  }
}
