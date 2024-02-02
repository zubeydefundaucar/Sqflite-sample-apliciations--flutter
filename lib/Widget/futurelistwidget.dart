import 'package:flutter/material.dart';
import 'package:flutter_localdatabasereal/Widget/todo_widget.dart';
import 'package:flutter_localdatabasereal/db/dbhelper.dart';
import 'package:flutter_localdatabasereal/db/questionmodel.dart';
import 'package:intl/intl.dart';

futurelist(
    Future<List<Todo>>? futureTodos, Dbhelper dbhlp, VoidCallback fettchtodos) {
  return FutureBuilder<List<Todo>>(
    future: futureTodos,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else {
        final todos = snapshot.data;

        if (todos == null) {
          return const Text("No");
        } else {
          return ListView.separated(
              itemBuilder: (context, index) {
                final todo = todos[index];
                final subtitle = DateFormat('yyyy/mm/dd')
                    .format(DateTime.parse(todo.updatedat ?? todo.createdat));
                return ListTile(
                  title: Text(todo.title),
                  subtitle: Text(subtitle),
                  trailing: Container(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.settings),
                          onPressed: () {
                            showDialog(
            context: context,
            builder: (_) => CreateTodoWidget(todo: todo,
              onSubmit: (value) async {
                await dbhlp.update(id: todo.id,title:todo.title );
                fettchtodos();
                Navigator.of(context).pop();
              }, 
              onSubmit2: (value) async {
                await dbhlp.update(id :todo.id ,title: value);
            
                fettchtodos();
                Navigator.of(context).pop();
              },
            ),
          );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            dbhlp
                                .delete(todo.id)
                                .then((value) => fettchtodos());
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(
                    height: 12,
                  ),
              itemCount: todos.length);
        }
      }
    },
  );
}
