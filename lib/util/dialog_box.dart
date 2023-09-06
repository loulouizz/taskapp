import 'package:flutter/material.dart';
import 'package:todoflutter/util/my_button.dart';

class DialogBox extends StatefulWidget {
  final taskNameController;
  final taskDescriptionController;
  VoidCallback onSave;
  VoidCallback onCancel;

  DialogBox({
    Key? key,
    required this.taskNameController,
    required this.taskDescriptionController,
    required this.onSave,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.yellow[300],
      content: Container(
        height: 210,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // get user input
            Form(
              key: _formKey,
              child: Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value! == "") {
                          return "Please enter some text";
                        }
                      },
                      controller: widget.taskNameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Add a new task",
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter some text";
                        }
                      },
                      controller: widget.taskDescriptionController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Add a description",
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // buttons -> save + cancel
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // save button
                MyButton(text: "Save", onPressed: (){
                  if(_formKey.currentState!.validate()){
                    widget.onSave;
                  }

                }),

                const SizedBox(width: 8),

                // cancel button
                MyButton(text: "Cancel", onPressed: widget.onCancel),
              ],
            )
          ],
        ),
      ),
    );
  }
}
