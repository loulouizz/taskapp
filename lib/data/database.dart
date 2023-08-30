import 'package:hive/hive.dart';

class ToDoDataBase{
  List toDoList = [];

  //reference the box
  final _myBox = Hive.box('mybox1');

  // run this method if this is the 1st time ever opening this app
  void createInitialData(){
    toDoList = [
      ["Example 1", "descrição 1",false],
      ["Example 2", "descrição 2",false]
    ];
  }

  // load the data from database
  void loadData(){
    toDoList = _myBox.get("TODOLIST");
  }

  // update the database
  void updateDataBase(){
    _myBox.put("TODOLIST", toDoList);
  }

}