import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisimpanPage extends StatefulWidget {
  @override
  _DisimpanPageState createState() => _DisimpanPageState();
}

class _DisimpanPageState extends State<DisimpanPage> {
  List<String> savedTickets = [];

  @override
  void initState() {
    super.initState();
    _loadSavedTickets();
  }

  void _loadSavedTickets() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      savedTickets = prefs.getStringList('saved_list') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tiket Disimpan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: savedTickets.isEmpty
            ? Center(child: Text('Belum ada tiket disimpan.'))
            : ListView.builder(
                itemCount: savedTickets.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(savedTickets[index]),
                  );
                },
              ),
      ),
    );
  }
}
