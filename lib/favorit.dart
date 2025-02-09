import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List favoriteRecipes = [];

  @override
  void initState() {
    super.initState();
    fetchFavoriteRecipes();
  }

  Future<void> fetchFavoriteRecipes() async {
    final response = await http.get(Uri.parse(
        'https://mobilecomputing.my.id/api_farid/favorite.php?action=read'));
    if (response.statusCode == 200) {
      setState(() {
        favoriteRecipes = json.decode(response.body);
      });
    }
  }

  Future<void> deleteFavoriteRecipe(int id) async {
    final response = await http.post(
      Uri.parse(
          'https://mobilecomputing.my.id/api_farid/favorite.php?action=delete'),
      body: {'id': id.toString()},
    );

    if (response.statusCode == 200) {
      fetchFavoriteRecipes();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Recipe removed from favorites'),
        backgroundColor: Colors.green,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to remove recipe from favorites'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: favoriteRecipes.isEmpty
          ? Center(child: Text('Tidak ada data resep favorit'))
          : ListView.builder(
              itemCount: favoriteRecipes.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(10.0),
                  child: ListTile(
                    leading: favoriteRecipes[index]['image'] != null
                        ? Image.network(
                            'https://mobilecomputing.my.id/api_farid/${favoriteRecipes[index]['image']}',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/logo.png',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                    title: Text(favoriteRecipes[index]['name']),
                    subtitle: Text(
                        'Kategori: ${favoriteRecipes[index]['category_name']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        deleteFavoriteRecipe(
                            int.parse(favoriteRecipes[index]['id']));
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
