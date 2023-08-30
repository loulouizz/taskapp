import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todoflutter/data/database.dart';
import 'package:todoflutter/util/dialog_box.dart';
import 'package:todoflutter/util/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // reference the hive box
  final _myBox = Hive.box('mybox1');
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {

    // if this is the 1st time ever opening the app, then create default data
    if(_myBox.get("TODOLIST") == null){
      db.createInitialData();
    } else {
      // there already exists data
      db.loadData();
    }

    super.initState();
  }


  // text controller
  final _taskNameController = TextEditingController();
  final _taskDescriptionController = TextEditingController();


  //checkbox was tapped
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][2] = !db.toDoList[index][2];
    });
    db.updateDataBase();
  }

  // save new task
  void saveNewTask() {
    setState(() {
      db.toDoList.add([_taskNameController.text, _taskDescriptionController.text, false]);
      _taskNameController.clear();
      _taskDescriptionController.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  void updateTask(int index, String newName, String newDescription) {
    db.toDoList[index][0] = newName;
    db.toDoList[index][1] = newDescription;
    db.updateDataBase();
  }

  void editTask(int index) {
    _taskNameController.text = db.toDoList[index][0];
    _taskDescriptionController.text = db.toDoList[index][1];

    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          taskNameController: _taskNameController,
          taskDescriptionController: _taskDescriptionController,
          onSave: () {
            updateTask(index, _taskNameController.text, _taskDescriptionController.text);
            _taskNameController.clear();
            _taskDescriptionController.clear();
            Navigator.of(context).pop();
            setState(() {}); // Atualiza a interface do usuário
          },
          onCancel: () {
            _taskNameController.clear();
            _taskDescriptionController.clear();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }



  //create a new task
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          taskNameController: _taskNameController,
          taskDescriptionController: _taskDescriptionController,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
    db.updateDataBase();
  }

  // delete task
  void deleteTask(int index){
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.yellow[200],
        appBar: AppBar(
          title: Container(
            alignment: Alignment.center,
            child: Text("TO DO"),
          ),
          elevation: 0,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            createNewTask();
          },
          child: Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: db.toDoList.length,
          itemBuilder: (context, index) {
            return ToDoTile(
              taskName: db.toDoList[index][0],
              taskCompleted: db.toDoList[index][2],
              description: db.toDoList[index][1],
              onChanged: (value) => checkBoxChanged(value, index),
              deleteFunction: (context) => deleteTask(index),
              editFunction: (context) => editTask(index),
            );
          },
        ));
  }
}