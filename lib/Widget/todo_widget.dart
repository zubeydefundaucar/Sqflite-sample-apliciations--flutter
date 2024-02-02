import 'package:flutter/material.dart';

import 'package:flutter_localdatabasereal/db/questionmodel.dart';

class CreateTodoWidget extends StatefulWidget {
  final controller = TextEditingController();
  final formkey = GlobalKey<FormState>();
  final Todo? todo;
  final ValueChanged<String> onSubmit;
  final ValueChanged<String>? onSubmit2;

  CreateTodoWidget({super.key, this.todo, required this.onSubmit,  this.onSubmit2});

  @override
  State<CreateTodoWidget> createState() => _MyAppState();
}

class _MyAppState extends State<CreateTodoWidget> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final isEditing = widget.todo != null;

    return AlertDialog(
      title: Text(isEditing ? "Edit todo" : "Add Todo"),
      content: Form(
          key: widget.formkey,
          child: TextFormField(
              autofocus: true,
              controller: widget.controller,
              decoration: const InputDecoration(hintText: "Title"),
              validator: (value) =>
                  value != null && value.isEmpty ? "Title is required" : null)),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text("Cancel")),
        TextButton(
            onPressed: () {
              if (widget.formkey.currentState!.validate()) {
                if(widget.onSubmit2!=null)widget.onSubmit2!(widget.controller.text,);
                else widget.onSubmit(widget.controller.text);
              }
            },
            child: Text("Ok"))
      ],
    );
  }
}
