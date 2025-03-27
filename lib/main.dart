import 'package:flutter/material.dart';
import 'package:sqlite_demo/UserDataDB/user_screen.dart';

import 'db_helper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQLite Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserList_screen(),
     // home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<Map<String, dynamic>> _items = [];

  // Fetch all items from the database
  void _fetchItems() async {
    final items = await DBHelper.getItems();
    setState(() {
      _items = items;
    });
  }

  // Insert item into the database
  void _insertItem() async {
    if (_titleController.text.isNotEmpty && _descriptionController.text.isNotEmpty) {
      final item = {
        'title': _titleController.text,
        'description': _descriptionController.text,
      };
      await DBHelper.insertItem(item);
      _fetchItems(); // Refresh the list
      _titleController.clear();
      _descriptionController.clear();
    }
  }

  // Delete item from the database
  void _deleteItem(int id) async {
    await DBHelper.deleteItem(id);
    _fetchItems(); // Refresh the list
  }

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SQLite Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input fields to insert item
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _insertItem,
              child: Text('Insert Item'),
            ),
            SizedBox(height: 20),
            // Display list of items
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return ListTile(
                    title: Text(item['title']),
                    subtitle: Text(item['description']),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteItem(item['id']),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
