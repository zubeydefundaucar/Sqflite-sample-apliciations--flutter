

import 'package:flutter/material.dart';
import 'package:flutter_localdatabasereal/Widget/todo_widget.dart';
import 'package:flutter_localdatabasereal/db/dbhelper.dart';
import 'package:flutter_localdatabasereal/db/questionmodel.dart';
import 'package:flutter_localdatabasereal/main.dart';
import 'package:intl/intl.dart';



class todoscreen extends StatefulWidget {
  todoscreen({super.key});
  late Dbhelper dbhlp;
  
  @override
  State<todoscreen> createState() => _todoscreenState();
}

class _todoscreenState extends State<todoscreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
  final args1 = ModalRoute.of(context)?.settings.arguments! as List<Object>;
  Todo args = args1[0] as Todo;
  Dbhelper db = args1[1] as Dbhelper;
  VoidCallback ondatachange = args1[2] as VoidCallback;
  Text updttime = buildupdatetime(args);
  Text name= Text(args.title,style: TextStyle(fontSize: 50));

  final subtitle = DateFormat("ymd")
                    .format(DateTime.parse(args.updatedat ?? args.createdat));
                    print("object");

  
  Todo item1 =args;
  get_datas()async{
     List<Todo> item = await db.fetcbyid(id: args.id.toString());
     Todo item1 =item[0];
     
                    
      
      return item1;
    }
  
   
    return Scaffold(
      appBar: AppBar(
        title:const Text("Details page"),
        actions: [IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            showDialog(
            context: context,
            builder: (_) => CreateTodoWidget(
              onSubmit2: (value) {
                setState(() {
                  db.update(id: args.id,title: value).then((value) {
                    ondatachange();
                    updttime =  Text(DateFormat('kk:mm:ss \n EEE d MMM')
                    .format(DateTime.parse(item1.updatedat!)),);
                    name= Text(item1.title,style: TextStyle(fontSize: 50));
                  },);
                  
              
                 
                  
                 
                });
              },
              todo: args,
              onSubmit: (value) {

              }
            ),
          );
          },),]
        ),

        body: Center(
          child: Column(
            children: [
              name
             ,
            Text("Starting time",style: TextStyle(fontSize: 50)),
            Text(DateFormat('kk:mm:ss \n EEE d MMM')
                    .format(DateTime.parse(args.createdat)),
                    style: const TextStyle(fontSize: 50)),
           const Text("Ending time",style: TextStyle(fontSize: 50)),
           const Text("Null",style: TextStyle(fontSize: 50)),
           const Text("Updated time",style: TextStyle(fontSize: 50)),
           updttime,
           
            ]),
        ),
    )
    ;
  }
}

buildupdatetime(var args) {

  try {
    return
                Text(DateFormat('kk:mm:ss \n EEE d MMM')
                    .format(DateTime.parse(args.updatedat)),
                    style: const TextStyle(fontSize: 50));
  } catch (e) {
    return Text("Henüz güncelleme yapılmadı");
    
  }
  
}

