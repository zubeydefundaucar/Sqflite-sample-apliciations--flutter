import 'package:flutter/material.dart';
import 'package:flutter_localdatabasereal/Widget/appbar.dart';
import 'package:flutter_localdatabasereal/Widget/futurelistwidget.dart';
import 'package:flutter_localdatabasereal/Widget/todo_widget.dart';
import 'package:flutter_localdatabasereal/db/dbhelper.dart';
import 'package:flutter_localdatabasereal/db/questionmodel.dart';
import 'package:flutter_localdatabasereal/screens/todosscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      routes:  {
      '/todopage':(context)=>todoscreen(),
    },
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Sqflite'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isSelectionMode = false;
  bool selectAll = false;
  List<bool> selected = [];
  late int listLength;
  List<Todo> todos = [];
  final dbhlp = Dbhelper();

  void initialize() async {
    await dbhlp.fetchAll().then((value) {
      setState(() {
        todos = value;
      });
    });

    selected = List<bool>.generate(todos.length, (_) => false);
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createbar(
        selected: selected,
        isSelectionMode: isSelectionMode,
        selectAll: selectAll,
        selectionbuttonfunc: () {
         
          initialize();
          setState(() {
            isSelectionMode = false;
          });
        },
        removeselecteds: () {
          for (var i = 0; i < selected.length; i++) {
            if (selected[i] == true) dbhlp.delete(todos[i].id);
            setState(() {
              isSelectionMode = false;
              initialize();
            });
          }
        },
        whenselectionmode: () {
          setState(() {
            var status = getselectionstatus(selected);
             selectAll =!selectAll;
            if (status == selected.length) {
              selected = List<bool>.generate(todos.length, (_) => false);
            } else {
              selected = List<bool>.generate(todos.length, (_) => true);
            }
          });
        },
      ),
      body: ListBuilder(

        dbhlp: dbhlp,
        data: todos,
        isSelectionMode: isSelectionMode,
        onSelectionChange: (bool x) {
          setState(() {
            isSelectionMode = x;
          });
        },
        ondatachange: (){
          setState(() {
            initialize();
          });
        },
        selectedList: selected,
      ),
      floatingActionButton: FloatingActionButton(
      
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => CreateTodoWidget(
              onSubmit: (value) async {
                await dbhlp.rawinsert(title: value);
                if (!mounted) return;
                initialize();
                
              },
            ),
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

int getselectionstatus(List<bool> selected) {
  int status = 0;

  for (bool i in selected) {
    if (i == true) {
      status += 1;
    }
  }
  return statu
