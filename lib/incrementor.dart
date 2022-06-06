import 'package:flutter/material.dart';

class Incrementor extends StatelessWidget {
  final String name;
  final int count;
  final void Function(int) onSetCount;
  final ButtonStyle? buttonStyle;

  const Incrementor({
    required this.name,
    this.count = 0,
    required this.onSetCount,
    this.buttonStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: [
        IconButton(
          onPressed: () {
            if (count <= 0) return; 
            onSetCount(count-1);
          },
          icon: const Icon(Icons.chevron_left),
        ),
        ElevatedButton(
          onPressed: () => onSetCount(count+1),
          style: buttonStyle,
          child: Text(
            name,
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 15.0),
          width: 15,
          child: Text(
            count != 0 ? count.toString() : '',
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ],),
    );
  }
}