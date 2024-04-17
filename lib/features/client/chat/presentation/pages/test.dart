import 'package:flutter/material.dart';

class ListItem {
  final String title;
  bool isSelected;

  ListItem(this.title, {this.isSelected = false});
}

class SelectableListView extends StatefulWidget {
  @override
  _SelectableListViewState createState() => _SelectableListViewState();
}

class _SelectableListViewState extends State<SelectableListView> {
  List<ListItem> items = [
    ListItem('Item 1'),
    ListItem('Item 2'),
    ListItem('Item 3'),
    ListItem('Item 4'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selectable ListView'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () {
              // Perform action when "Done" button is pressed
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index].title),
            trailing: items[index].isSelected
                ? Icon(Icons.check_circle, color: Colors.green)
                : null,
            onTap: () {
              setState(() {
                // Toggle the selected state of the tapped item
                items[index].isSelected = !items[index].isSelected;
              });
            },
            onLongPress: () {
              setState(() {
                // If an item is long-pressed, toggle its selection state
                items[index].isSelected = !items[index].isSelected;
              });
            },
          );
        },
      ),
    );
  }
}

