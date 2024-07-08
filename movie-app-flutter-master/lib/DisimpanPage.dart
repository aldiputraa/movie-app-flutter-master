import 'package:flutter/material.dart';

class DisimpanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Disimpan'),
      ),
      body: Center(
        child: Text(
          'Belum ada item yang disimpan',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
