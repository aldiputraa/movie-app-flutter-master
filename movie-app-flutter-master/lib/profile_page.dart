import 'package:flutter/material.dart';

class ProfilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Fitra Putra Aldi Wijaya',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'aldip7669@gmail.com',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Nama'),
              subtitle: Text('Fitra Putra Aldi Wijaya'),
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Email'),
              subtitle: Text('aldip7669@gmail.com'),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Nomor Telepon'),
              subtitle: Text('+62 812 3456 7890'),
            ),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Alamat'),
              subtitle: Text('Jalan Merdeka No. 123, Jakarta, Indonesia'),
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Tanggal Lahir'),
              subtitle: Text('1 Januari 1990'),
            ),
          ],
        ),
      ),
    );
  }
}
