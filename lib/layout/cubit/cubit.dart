import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/layout/cubit/states.dart';
import 'package:todo/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo/modules/new_tasks/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  bool isButtonSheetShown = false;
  IconData fabIcon = Icons.edit;
  int currentState = 0;
  List<Widget> screens =
  [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  List<String> titles =
  [
    "New Tasks",
    "Done Tasks",
    "Archived Tasks",
  ];


  void changeIndex(int index) {
    currentState = index;
    emit(AppChangeBottomNavBarState());
  }


  late Database database;

  void createDataBase() async
  {
    openDatabase(
        "todo.db",
        version: 1,
        onCreate: (database, version) {
          print("database is created");
          database.execute(
              'CREATE TABLE tasks(id INTEGER PRIMARY KEY,title TEXT ,date TEXT ,time TEXT,status TEXT)')
              .then((value) {
            print("table is created");
          });
        },

        onOpen: (database) {
          getDataFromDatabase(database);
          print("database is opened");
        }
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }


  Future insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database.transaction((txn) {
    return  txn.rawInsert(
          'INSERT INTO tasks(title, date, time, status)' 'VALUES("$title", "$date", "$time", "new")'
      ).then((value) {
        print("$value Insert is Done");
        emit(AppInsertDatabaseState());

        getDataFromDatabase(database);
      }).catchError((onError) {
        print("${onError.toString()} is the Error");
      });
      //     .catchError((onError) {
      //   print("${onError.toString()} is occured");
      // });
    });
  }


  void updateData({
    required String status,
    required int id,
  }) async
  {
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteData({
    required int id,
  }) async
  {
    database.rawDelete(
        'DELETE FROM tasks WHERE id = ?',
        [id]).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }


  void getDataFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element["status"] == "new") {
          newTasks.add(element);
        }
        else if (element["status"] == "done") {
          doneTasks.add(element);
        }
        else {
          archivedTasks.add(element);
        }
      });


      emit(AppGetDatabaseState());
    });
  }


  void changeBottomSheetState({
    required IconData icon,
    required bool isShow,
  }) {
    isButtonSheetShown = isShow;
    fabIcon = icon;

    emit(AppChangeBottomSheetState());
  }



}