import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TiketPage extends StatefulWidget {
  @override
  _TiketPageState createState() => _TiketPageState();
}

class _TiketPageState extends State<TiketPage> {
  List<String> tiketList = []; // List untuk menyimpan data tiket

  @override
  void initState() {
    super.initState();
    _loadTiketData();
  }

  // Fungsi untuk memuat data tiket dari penyimpanan lokal (SharedPreferences)
  Future<void> _loadTiketData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedTiketList = prefs.getStringList('tiket_list');

    if (savedTiketList != null) {
      setState(() {
        tiketList = savedTiketList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tiket Anda'),
      ),
      body: tiketList.isEmpty
          ? Center(
              child: Text(
                'Belum ada tiket yang dipesan',
                style: TextStyle(fontSize: 20),
              ),
            )
          : ListView.builder(
              itemCount: tiketList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Tiket ${index + 1}'),
                  subtitle: Text(tiketList[index]),
                );
              },
            ),
    );
  }
}

// Kelas MovieDetailsPage merepresentasikan widget untuk menampilkan detail film.
class MovieDetailsPage extends StatelessWidget {
  final String title;
  final String imagePath;
  final String genres;
  final String rating;
  final String harga;

  const MovieDetailsPage(
      {Key? key,
      required this.title,
      required this.imagePath,
      required this.genres,
      required this.rating,
      required this.harga})
      : super(key: key);

  Future<void> _saveTicket(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? tiketList = prefs.getStringList('tiket_list') ?? [];
    tiketList.add(title);
    await prefs.setStringList('tiket_list', tiketList);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tiket berhasil dibeli!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title), // Judul halaman detail film.
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset(
              imagePath, // Gambar film.
              height: 300,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Judul: $title', // Judul film.
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Genre: $genres', // Genre film.
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Rating: $rating', // Rating film.
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Harga: $harga', // Harga tiket film.
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Menampilkan dialog box saat tombol ditekan untuk konfirmasi pembelian.
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Konfirmasi Pembelian'),
                            content: Text(
                                'Anda telah berhasil memesan tiket untuk $title.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _saveTicket(context);
                                },
                                child: Text('Selesai'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text('Beli Sekarang'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
