import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddRecipePage extends StatefulWidget {
  @override
  _AddRecipePageState createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List categories = [];
  String? selectedCategory;
  File? _image;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final response = await http.get(Uri.parse(
        'https://mobilecomputing.my.id/api_farid/category.php?action=read'));

    if (response.statusCode == 200) {
      setState(() {
        categories = json.decode(response.body);
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<void> createRecipe() async {
    final String name = _nameController.text;
    final String description = _descriptionController.text;

    if (name.isEmpty ||
        description.isEmpty ||
        selectedCategory == null ||
        _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('All fields and image are required'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    final request = http.MultipartRequest(
      'POST',
      Uri.parse(
          'https://mobilecomputing.my.id/api_farid/recipe.php?action=create'),
    );

    request.fields['name'] = name;
    request.fields['description'] = description;
    request.fields['category_id'] = selectedCategory!;
    request.files.add(await http.MultipartFile.fromPath('image', _image!.path));

    final response = await request.send();

    final responseBody = await response.stream.bytesToString();
    print('Response status: ${response.statusCode}');
    print('Response body: $responseBody');

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Recipe created successfully'),
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
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              items: categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category['id'].toString(),
                  child: Text(category['category_name']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
              decoration: InputDecoration(labelText: 'Category'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            _image != null ? Image.file(_image!) : Container(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: createRecipe,
              child: Text('Add Recipe'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditRecipePage extends StatefulWidget {
  final Map recipe;

  EditRecipePage({required this.recipe});

  @override
  _EditRecipePageState createState() => _EditRecipePageState();
}

class _EditRecipePageState extends State<EditRecipePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List categories = [];
  String? selectedCategory;
  File? _image;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.recipe['name'];
    _descriptionController.text = widget.recipe['description'];
    selectedCategory = widget.recipe['category_id'].toString();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final response = await http.get(Uri.parse(
        'https://mobilecomputing.my.id/api_farid/category.php?action=read'));

    if (response.statusCode == 200) {
      setState(() {
        categories = json.decode(response.body);
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<void> updateRecipe() async {
    final String name = _nameController.text;
    final String description = _descriptionController.text;

    if (name.isEmpty || description.isEmpty || selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('All fields are required'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    final request = http.MultipartRequest(
      'POST',
      Uri.parse(
          'https://mobilecomputing.my.id/api_farid/recipe.php?action=update'),
    );

    request.fields['id'] = widget.recipe['id'].toString();
    request.fields['name'] = name;
    request.fields['description'] = description;
    request.fields['category_id'] = selectedCategory!;

    if (_image != null) {
      request.files
          .add(await http.MultipartFile.fromPath('image', _image!.path));
    }

    final response = await request.send();

    final responseBody = await response.stream.bytesToString();
    print('Response status: ${response.statusCode}');
    print('Response body: $responseBody');

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Recipe updated successfully'),
        backgroundColor: Colors.green,
      ));
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Recipe'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category['id'].toString(),
                    child: Text(category['category_name']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Category'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Image'),
              ),
              _image != null
                  ? Image.file(_image!)
                  : widget.recipe['image'] != null
                      ? Image.network(
                          'https://mobilecomputing.my.id/api_farid/${widget.recipe['image']}',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        )
                      : Container(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateRecipe,
                child: Text('Update Recipe'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
