import 'package:flutter/material.dart';
import 'package:flutter_localdatabasereal/main.dart';

createbar1(bool isSelectionMode, bool selectAll,
    VoidCallback selectionbuttonfunc, VoidCallback whenselectionmode) {
  return AppBar(
    title: const Text(
      'ListTile selection',
    ),
    leading: isSelectionMode
        ? IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => selectionbuttonfunc(),
          )
        : const SizedBox(),
    actions: <Widget>[
      if (isSelectionMode)
        TextButton(
            child: !selectAll
                ? const Text(
                    'select all',
                    style: TextStyle(color: Colors.white),
                  )
                : const Text(
                    'unselect all',
                    style: TextStyle(color: Colors.white),
                  ),
            onPressed: () => whenselectionmode()),
    ],
  );
}

class createbar extends AppBar {
  createbar({
    required this.selected,
    required this.isSelectionMode,
    required this.selectAll,
    required this.selectionbuttonfunc,
    required this.whenselectionmode,
    required this.removeselecteds,
    super.key,
  });

  bool isSelectionMode;
  bool selectAll;
  VoidCallback selectionbuttonfunc;
  VoidCallback whenselectionmode;
  VoidCallback removeselecteds;
  List<bool> selected;
  @override
  State<createbar> createState() => _ListBuilderState();
  
 
}

class _ListBuilderState extends State<createbar> {
  @override
  Widget build(BuildContext context) {
    int status = getselectionstatus(widget.selected);

    return AppBar(
      title: const Text(
        'ListTile selection',
      ),
      leading: widget.isSelectionMode
          ? IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => widget.selectionbuttonfunc(),
            )
          : const SizedBox(),
      actions: <Widget>[
        if (widget.isSelectionMode)
          status == 0
              ? SizedBox()
              : IconButton(
                  onPressed: () => widget.removeselecteds(),
                  icon: Icon(Icons.delete)),
        if (widget.isSelectionMode)
          TextButton(
              child: !widget.selectAll
                  ? const Text(
                      'select all',
                      style: TextStyle(color: Color.fromARGB(255, 43, 37, 37)),
                    )
                  : const Text(
                      'unselect all',
                      style: TextStyle(color: Color.fromARGB(255, 32, 29, 29)),
                    ),
              onPressed: () => widget.whenselectionmode()),
      ],
    );
  }
}
