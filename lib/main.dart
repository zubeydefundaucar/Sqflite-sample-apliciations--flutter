import 'package:flutter/material.dart';
import 'package:flutter_localdatabasereal/Widget/futurelistwidget.dart';
import 'package:flutter_localdatabasereal/Widget/todo_widget.dart';
import 'package:flutter_localdatabasereal/db/dbhelper.dart';
import 'package:flutter_localdatabasereal/db/questionmodel.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  Future<List<Todo>>? futureTodos;
  final dbhlp = Dbhelper();

  @override
  void initState() {
    super.initState();
    fettchtodos();
  }

  void fettchtodos() {
    setState(() {
      futureTodos = dbhlp.fetchAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: futurelist(futureTodos,dbhlp,fettchtodos), 
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => CreateTodoWidget(
              onSubmit: (value) async {
                await dbhlp.rawinsert(title: value);
                if (!mounted) return;
                fettchtodos();
                Navigator.of(context).pop();
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

