import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddCategoryPage extends StatefulWidget {
  @override
  _AddCategoryPageState createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> createCategory() async {
    final String category_name = _nameController.text;
    final String description = _descriptionController.text;

    if (category_name.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('All fields are required'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    final response = await http.post(
      Uri.parse(
          'https://mobilecomputing.my.id/api_farid/category.php?action=create'),
      body: {
        'category_name': category_name,
        'description': description,
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Category created successfully'),
        backgroundColor: Colors.green,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Category Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: createCategory,
              child: Text('Add Category'),
            ),
          ],
        ),
      ),
    );
  }
}
