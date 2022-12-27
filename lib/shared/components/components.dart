import 'package:flutter/material.dart';
import 'package:todo/layout/cubit/cubit.dart';



Widget defaultFormField({
  required TextEditingController textController,
  required TextInputType type,
  Function? onSubmit,
  Function? onChanged,
  Function? onTap,
  required Function validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  bool isPassword = false,
  Function? suffixPressed,
  bool isClickable = true,
  bool readOnly = false,
  TextInputAction? inputAction,
}) =>
    TextFormField(
      controller: textController,
      keyboardType: type,
      obscureText: isPassword,
      onFieldSubmitted: (value) {
        onSubmit!(value);
      },
      //  onChanged: (value)
      //  {
      //    onChanged!(value);
      //  },
      onTap: ()
      {
        onTap!();
      },
      textInputAction: inputAction,

      validator: (value) {
        return validate(value);
      },
      enabled: isClickable,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                icon: Icon(
                  suffix,
                ),
                onPressed: () {
                  suffixPressed!();
                },
              )
            : null,
        border: const OutlineInputBorder(),
      ),
    );

Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model["id"].toString()),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              child: Text("${model["time"]}"),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${model["title"]}",
                    style:
                        const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${model["date"]}",
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateData(status: "done", id: model["id"]);
              },
              icon: const Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateData(status: "archive", id: model["id"]);
              },
              icon: const Icon(
                Icons.archive,
                color: Colors.black38,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        AppCubit.get(context).deleteData(id: model["id"]);
      },
    );

Widget tasksBuilder({required List<Map> tasks}) => tasks.length > 0
    ? ListView.separated(
        itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
        separatorBuilder: (context, index) => myDivider(),
        itemCount: tasks.length,
      )
    : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:const [
             Icon(
              Icons.menu,
              size: 50.0,
              color: Colors.grey,
            ),
             Text(
              "No Tasks Yet, Please Add some Tasks",
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );

Widget myDivider() => Container(
      width: double.infinity,
      height: 1.0,
      color: Colors.grey[300],
    );


