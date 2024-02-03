import 'package:flutter/material.dart';
import 'package:flutter_localdatabasereal/db/dbhelper.dart';
import 'package:flutter_localdatabasereal/db/questionmodel.dart';
import 'package:intl/intl.dart';

futurelist(
    Future<List<Todo>>? futureTodos, 
    Dbhelper dbhlp, 
    VoidCallback fettchtodos,
    List<bool> selectedList,
    bool isSelectionMode,
    ValueChanged<bool>? onSelectionChange) {
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
                return ListBuilder(
                  ondatachange: () {
                    
                  },
                  dbhlp: dbhlp,
                  selectedList: selectedList, 
                  isSelectionMode: isSelectionMode, 
                  onSelectionChange: onSelectionChange, 
                  data: todos);
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

class ListBuilder extends StatefulWidget {
   ListBuilder({
    super.key,
    required this.selectedList,
    required this.isSelectionMode,
    required this.onSelectionChange,
    required this.data,
    required this.dbhlp,
    required this.ondatachange
    
  
    
  });

  final bool isSelectionMode;
  final List<bool> selectedList;
  final ValueChanged<bool>? onSelectionChange;
  final List<Todo> data;
  final Dbhelper dbhlp;
  late VoidCallback ondatachange;

  @override
  State<ListBuilder> createState() => _ListBuilderState();
}

class _ListBuilderState extends State<ListBuilder> {
  void _toggle(int index) {
    if (widget.isSelectionMode) {
      setState(() {
        widget.selectedList[index] = !widget.selectedList[index];
      });
    }
    else{
      Navigator.pushNamed(context, '/todopage',arguments:[widget.data[index],widget.dbhlp,widget.ondatachange] ,);
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return ListView.builder(
      
        itemCount: widget.data.length,
        itemBuilder: (_, int index) {
          Todo todo = widget.data[index];
    final subtitle = DateFormat('yyyy/mm/dd')
                    .format(DateTime.parse(todo.updatedat ?? todo.createdat));
          return ListTile(
            
              onTap: () => _toggle(index),
              onLongPress: () {
                if (!widget.isSelectionMode) {
                  setState(() {
                    widget.selectedList[index] = true;
                  });
                  widget.onSelectionChange!(true);
                }
              },
              trailing: widget.isSelectionMode
                  ? Checkbox(
                      value: widget.selectedList[index],
                      onChanged: (bool? x) => _toggle(index),
                    )
                  : const SizedBox.shrink(),
              title: Text(todo.title),
              subtitle: Text(subtitle),)
              ;     
        });
  }
}