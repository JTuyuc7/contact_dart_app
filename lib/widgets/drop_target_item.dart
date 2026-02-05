import 'package:flutter/material.dart';

class DropTargetItem extends StatefulWidget {
  final String? property;
  final Function(String, String) onDrop;

  const DropTargetItem({super.key, this.property, required this.onDrop});

  @override
  State<DropTargetItem> createState() => _DropTargetItemState();
}

class _DropTargetItemState extends State<DropTargetItem> {
  String _dragItem = '';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            widget.property ?? 'Undefined',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          flex: 2,
          child: DragTarget<String>(
            onAcceptWithDetails: (details) {
              setState(() {
                if (_dragItem.isEmpty) {
                  // _isHighlighted = true;
                  _dragItem = details.data;
                } else {
                  // _isHighlighted = false;
                  _dragItem += ' ${details.data}';
                }
              });
              widget.onDrop(widget.property!, _dragItem);
            },
            onWillAcceptWithDetails: (details) {
              return true;
            },
            builder: (context, candidateData, rejectedData) {
              return Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: candidateData.isNotEmpty
                      ? Border.all(color: Colors.red, width: 1.0)
                      : Border.all(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _dragItem.isEmpty ? 'Drop Here' : _dragItem,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: _dragItem.isEmpty ? Colors.grey : Colors.white,
                        ),
                      ),
                    ),
                    if (_dragItem.isNotEmpty)
                      InkWell(
                        onTap: () {
                          setState(() {
                            _dragItem = '';
                          });
                        },
                        child: Icon(
                          Icons.clear,
                          size: 16,
                          color: _dragItem.isEmpty
                              ? Colors.transparent
                              : Colors.white,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
