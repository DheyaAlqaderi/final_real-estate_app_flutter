import 'package:flutter/material.dart';

class CustomAttributeInt extends StatefulWidget {
  final int initialValue;
  final ValueChanged<int> onChanged;
  final String label;

  const CustomAttributeInt({
    super.key,
    required this.initialValue,
    required this.onChanged,
    required this.label,
  });

  @override
  _CustomAttributeIntState createState() => _CustomAttributeIntState();
}

class _CustomAttributeIntState extends State<CustomAttributeInt> {
  late int count;

  @override
  void initState() {
    super.initState();
    count = widget.initialValue;
  }

  void _incrementCount() {
    setState(() {
      count++;
      widget.onChanged(count);
    });
  }

  void _decrementCount() {
    if (count > 0) {
      setState(() {
        count--;
        widget.onChanged(count);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: _decrementCount,
            icon: Icon(Icons.remove, color: Theme.of(context).colorScheme.onSurface),
          ),
          Text(
            '$count',
            style: TextStyle(fontSize: 18.0, color: Theme.of(context).colorScheme.onSurface),
          ),
          IconButton(
            onPressed: _incrementCount,
            icon: Icon(Icons.add, color: Theme.of(context).colorScheme.onSurface),
          ),
          const Spacer(),
          Text(
            widget.label,
            style: const TextStyle(fontSize: 18.0, color: Colors.grey),
          ),
        ],
      ),
    )
    ;
  }
}
