import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisimpanPage extends StatefulWidget {
  @override
  _DisimpanPageState createState() => _DisimpanPageState();
}

class _DisimpanPageState extends State<DisimpanPage> {
  List<String> savedMovies = [];

  @override
  void initState() {
    super.initState();
    _loadSavedMovies();
  }

  Future<void> _loadSavedMovies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedList = prefs.getStringList('saved_list');
    if (savedList != null) {
      setState(() {
        savedMovies = savedList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Disimpan'),
      ),
      body: savedMovies.isEmpty
          ? Center(child: Text('Belum ada film yang disimpan'))
          : ListView.builder(
              itemCount: savedMovies.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(savedMovies[index]),
                  // Tambahkan aksi atau widget lain sesuai kebutuhan.
                );
              },
            ),
    );
  }
}
