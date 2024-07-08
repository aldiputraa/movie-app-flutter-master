import 'package:flutter/material.dart';

class ProfilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              backgroundImage: AssetImage(
                  'assets/poto.jpg'), // Ganti dengan path dan nama file gambar profil Anda.
              radius: 50,
            ),
            SizedBox(height: 20),
            Text(
              'Fitra Putra Aldi Wijaya',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'aldip7669@gmail.com',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Aksi untuk mengedit profil
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfilPage()),
                );
              },
              child: Text('Edit Profil'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditProfilPage extends StatefulWidget {
  @override
  _EditProfilPageState createState() => _EditProfilPageState();
}

class _EditProfilPageState extends State<EditProfilPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Aksi untuk menyimpan perubahan profil
                _saveProfileChanges();
              },
              child: Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveProfileChanges() {
    // Implementasi logika untuk menyimpan perubahan profil
    String newName = _nameController.text;
    String newEmail = _emailController.text;

    // Contoh implementasi untuk menyimpan ke penyimpanan lokal atau server
    // Misalnya: simpan ke SharedPreferences atau kirim ke backend server
    // Disini kita hanya mencetak hasilnya
    print('Nama baru: $newName');
    print('Email baru: $newEmail');

    // Kembali ke halaman profil setelah menyimpan
    Navigator.pop(context);
  }
}
