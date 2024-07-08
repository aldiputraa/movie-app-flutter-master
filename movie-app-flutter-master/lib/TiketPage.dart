import 'package:flutter/material.dart';

class TiketPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tiket Anda'),
      ),
      body: Center(
        child: Text(
          'Belum ada tiket yang dipesan',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
