import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
//import 'package:flutterapp2/modules/archived_tasks/archived_tasks_screen.dart';
//import 'package:flutterapp2/modules/done_tasks/done_tasks_screen.dart';
//import 'package:flutterapp2/modules/new_tasks/new_tasks_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/layout/cubit/cubit.dart';
import 'package:todo/layout/cubit/states.dart';
import 'package:todo/shared/components/components.dart';

class AppLayout extends StatelessWidget
{


  var scaffoldkey = GlobalKey<ScaffoldState>();
  var formkey =GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();




  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state)
        {
          if(state is AppInsertDatabaseState)
            {
              Navigator.pop(context);

            }

        } ,
        builder: (context,state){

          AppCubit cubit = AppCubit.get(context);

          return Scaffold(
            key: scaffoldkey,
            appBar: AppBar(
              title: Text(
                cubit.titles[cubit.currentState],
              ),
            ),
            body:  (state is! AppGetDatabaseLoadingState) ? cubit.screens[cubit.currentState]
              : Center(child: CircularProgressIndicator()),

            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if(cubit.isButtonSheetShown)
                {

                  if(formkey.currentState!.validate())
                  {
                   cubit.insertToDatabase(title: titleController.text,
                       time: timeController.text,
                       date: dateController.text
                   );
                    // insertToDatabase(
                    //   title: titleController.text,
                    //   time: timeController.text,
                    //   date: dateController.text,
                    // ).then((value) {
                    //   getDataFromDatabase(database).then((value){
                    //     Navigator.pop(context);
                    //     // setState(() {
                    //     //   isButtonSheetShown = false;
                    //     //   fabIcon = Icons.edit;
                    //     //   tasks= value;
                    //     //   print(tasks[0]);
                    //     //
                    //     // });
                    //   });
                    // });
                    titleController.text="";
                    timeController.text="";
                    dateController.text="";

                  }
                }


                else {
                  scaffoldkey.currentState!.showBottomSheet(
                        (context) =>
                        Container(
                          color: Colors.grey[200],
                          padding: const EdgeInsets.all(10.0),
                          child: Form(
                            key: formkey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children:
                              [
                                defaultFormField(textController: titleController,
                                    type: TextInputType.text,
                                    validate: (String value) {
                                      if (value.isEmpty) {
                                        return "Title must Not be empty";
                                      }
                                      return null;
                                    },
                                    onTap: (){
                                      print("hhhhhhhhhhh");

                                    },
                                    label: "Task Title",
                                    prefix: Icons.title),
                                SizedBox(
                                  height: 10.0,
                                ),

                                defaultFormField(textController: timeController,
                                    type: TextInputType.datetime,
                                    validate: (String value) {
                                      if (value.isEmpty) {
                                        return "Time must Not be empty";
                                      }
                                      return null;
                                    },
                                    readOnly: true,
                                    onTap: () {
                                      showTimePicker(context: context,
                                        initialTime: TimeOfDay.now()).then((value) {
                                        timeController.text = value!.format(context);
                                      });
                                    },
                                    label: "Task Time",
                                    prefix: Icons.watch_later_outlined),

                                SizedBox(
                                  height: 10.0,
                                ),

                                defaultFormField(textController: dateController,
                                    type: TextInputType.datetime,
                                    validate: (String value) {
                                      if (value.isEmpty) {
                                        return "Date must Not be empty";
                                      }
                                      return null;
                                    },
                                    onTap: () {
                                      showDatePicker(context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime.parse("2023-08-31")).then((value) {
                                        dateController.text=DateFormat.yMMMd().format(value!);
                                      });
                                    },
                                    readOnly: true,
                                    label: "Task Date",
                                    prefix: Icons.calendar_today),
                              ],
                            ),
                          ),
                        ),
                  ).closed.then((value) {
                    cubit.changeBottomSheetState(
                        icon: Icons.edit,
                        isShow: false
                    );
                  });

                  cubit.changeBottomSheetState(
                      icon: Icons.add,
                      isShow: true
                  );

                }


              },
              child: Icon(
                  cubit.fabIcon
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentState,
              onTap: (index) {

                cubit.changeIndex(index);
              },
              items:
              [
                BottomNavigationBarItem(
                    icon: Icon(
                        Icons.menu
                    ),
                    label: "Tasks"
                ),
                BottomNavigationBarItem(
                    icon: Icon(
                        Icons.check_circle_outline
                    ),
                    label: "Done"
                ),
                BottomNavigationBarItem(
                    icon: Icon(
                        Icons.archive_outlined
                    ),
                    label: "Archived"
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Future<String> getname() async
  // {
  //   return "Abanoub";
  // }




}

