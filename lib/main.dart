import 'package:flutter/material.dart';
import 'login_page.dart'; // Import halaman login
import 'profil_page.dart'; // Import halaman profil
import 'tiket_page.dart'; // Import halaman tiket
import 'disimpan_page.dart'; // Import halaman disimpan dari file terpisah
import 'tentang_page.dart'; // Import halaman tentang
import 'pengaturan_page.dart'; // Import halaman pengaturan
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Filmku"), // Judul untuk app bar.
        backgroundColor: const Color.fromARGB(
            255, 26, 158, 223), // Warna latar belakang untuk app bar.
      ),
      backgroundColor:
          Colors.black26, // Warna latar belakang untuk layar utama.
      drawer: Drawer(
        // Widget drawer untuk menu navigasi.
        child: ListView(
          children: [
            // Header drawer akun pengguna.
            UserAccountsDrawerHeader(
              accountName: Text(
                "Fitra Putra Aldi Wijaya", // Nama pengguna.
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              accountEmail: Text("aldip7669@gmail.com"), // Email pengguna.
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage(
                    'assets/poto.jpg'), // Sesuaikan dengan nama file dan path yang benar.
                backgroundColor: Colors.grey,
              ),

              decoration: BoxDecoration(
                  color: Colors.blue), // Dekorasi untuk header drawer.
            ),
            // List tile untuk opsi navigasi.
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Profil"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.airplane_ticket_outlined),
              title: Text("Tiket Anda"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TiketPage()),
                );
              },
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _deleteTicketList(context);
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.save),
              title: Text("Disimpan"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DisimpanPage()),
                );
              },
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _deleteSavedList(context);
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text("Tentang"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TentangPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Pengaturan"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PengaturanPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Keluar"),
              onTap: () {
                _showLogoutDialog(context);
              },
            ),
          ],
        ),
      ),
      body:
          MovieTicketBooking(), // Tubuh aplikasi berisi widget MovieTicketBooking.
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Keluar'),
          content: Text('Apakah Anda yakin ingin keluar?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _logout(context);
              },
              child: Text('Keluar'),
            ),
          ],
        );
      },
    );
  }

  void _logout(BuildContext context) {
    // Implementasi aksi keluar, misalnya membersihkan data pengguna dan navigasi ke halaman login
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  // Fungsi untuk menghapus daftar tiket dari SharedPreferences
  void _deleteTicketList(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('tiket_list');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Daftar tiket berhasil dihapus!'),
      ),
    );
  }

  // Fungsi untuk menghapus daftar disimpan dari SharedPreferences
  void _deleteSavedList(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('saved_list');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Daftar disimpan berhasil dihapus!'),
      ),
    );
  }
}

// Kelas MovieTicketBooking merepresentasikan widget untuk menampilkan kartu film.
class MovieTicketBooking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // Widget scrollable untuk menampilkan beberapa kartu film.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Membangun kartu film menggunakan fungsi _buildMovieCard.
          _buildMovieCard(context, 'Siksa Kubur', 'assets/siksakubur.png',
              'Horor', '8.5/10', '35.000'),
          _buildMovieCard(context, 'Ancika', 'assets/ancika.jpeg',
              'Romance, Drama', '8.3/10', '35.000'),
          _buildMovieCard(context, 'Agak Laen', 'assets/agaklain.jpeg',
              'Horor, Komedi', '8.7/10', '35.000'),
          _buildMovieCard(context, 'Badarawuhi', 'assets/badarawuhi.jpg',
              'Horor', '8.2/10', '35.000'),
          _buildMovieCard(
              context,
              'Petualangan Anak Penangkap Hantu',
              'assets/petualangan.jpg',
              'Horor, Petualangan, Komedi',
              '8/10',
              '35.000'),
          _buildMovieCard(context, 'Sehidup Semati', 'assets/sehidupsemati.jpg',
              'Horor, Tegang', '7.8/10', '35.000'),
        ],
      ),
    );
  }

  // Fungsi untuk membangun kartu film individu.
  Widget _buildMovieCard(BuildContext context, String title, String imagePath,
      String genres, String rating, String harga) {
    return GestureDetector(
      // Gesture detector untuk menangani ketukan pada kartu film.
      onTap: () {
        // Navigasi ke MovieDetailsPage ketika kartu film ditekan.
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MovieDetailsPage(
                  title: title,
                  imagePath: imagePath,
                  genres: genres,
                  rating: rating,
                  harga: harga)),
        );
      },
      child: Card(
        margin: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
              child: Image.asset(
                imagePath,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title, // Judul film.
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Genre: $genres', // Genre film.
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Rating: $rating', // Rating film.
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Harga: $harga', // Harga tiket film.
                    style: TextStyle(fontSize: 16),
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

// Kelas MovieDetailsPage merepresentasikan widget untuk menampilkan detail film.
class MovieDetailsPage extends StatelessWidget {
  final String title;
  final String imagePath;
  final String genres;
  final String rating;
  final String harga;

  const MovieDetailsPage({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.genres,
    required this.rating,
    required this.harga,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset(
              imagePath,
              height: 300,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Judul: $title',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Genre: $genres',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Rating: $rating',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Harga: $harga',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _showPurchaseDialog(context);
                    },
                    child: Text('Beli Tiket'),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      _saveToSavedList(context);
                    },
                    child: Text('Simpan Film'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPurchaseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Pembelian'),
          content: Text('Apakah Anda yakin ingin membeli tiket?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _saveTicket(context);
              },
              child: Text('Beli'),
            ),
          ],
        );
      },
    );
  }

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

  Future<void> _saveToSavedList(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedList = prefs.getStringList('saved_list') ?? [];
    savedList.add(title);
    await prefs.setStringList('saved_list', savedList);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Film berhasil disimpan!'),
      ),
    );
  }
}
