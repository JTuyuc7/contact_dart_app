import 'package:flutter/material.dart';

class LineItem extends StatelessWidget {
  final String line;

  const LineItem({super.key, required this.line});

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable(
      feedback: Container(
        key: GlobalKey(),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          // color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        child: Text(
          line,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            // color: Colors.white,
              fontWeight: FontWeight.w500,
              // backgroundColor: Colors.red
          ),
        ),
      ),
      data: line,
      dragAnchorStrategy: childDragAnchorStrategy,
      child: Chip(label: Text(line)),

    );
  }
}
