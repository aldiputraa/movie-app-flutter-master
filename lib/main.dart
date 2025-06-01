import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'profil_page.dart';
import 'tiket_page.dart';
import 'disimpan_page.dart';
import 'tentang_page.dart';
import 'pengaturan_page.dart';
import 'payment_page.dart';
import 'movie_details_page.dart';
import 'search_page.dart';
import 'notification_page.dart';
import 'notification_service.dart';
import 'recommendation_page.dart';
import 'recommendation_service.dart';
import 'offline_page.dart';
import 'offline_service.dart';
import 'wishlist_page.dart';
import 'wishlist_service.dart';
import 'my_movies_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool isLoggedIn = await checkLoginStatus(); // Memeriksa status login

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoggedIn
          ? HomePage()
          : LoginPage(), // Menyesuaikan halaman berdasarkan status login
    ),
  );
}

Future<bool> checkLoginStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // Misalkan Anda menyimpan status login dengan key 'isLoggedIn'
  return prefs.getBool('isLoggedIn') ??
      false; // Mengembalikan default false jika tidak ada data
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Data film untuk digunakan di seluruh aplikasi
  final Map<String, Map<String, String>> movieDetails = {
    'Siksa Kubur': {
      'imagePath': 'assets/siksakubur.png',
      'genres': 'Horor',
      'rating': '8.5/10',
      'harga': '35.000'
    },
    'Ancika': {
      'imagePath': 'assets/ancika.jpeg',
      'genres': 'Romance, Drama',
      'rating': '8.3/10',
      'harga': '35.000'
    },
    'Agak Laen': {
      'imagePath': 'assets/agaklain.jpeg',
      'genres': 'Horor, Komedi',
      'rating': '8.7/10',
      'harga': '35.000'
    },
    'Badarawuhi': {
      'imagePath': 'assets/badarawuhi.jpg',
      'genres': 'Horor',
      'rating': '8.2/10',
      'harga': '35.000'
    },
    'Petualangan Anak Penangkap Hantu': {
      'imagePath': 'assets/petualangan.jpg',
      'genres': 'Horor, Petualangan, Komedi',
      'rating': '8/10',
      'harga': '35.000'
    },
    'Sehidup Semati': {
      'imagePath': 'assets/sehidupsemati.jpg',
      'genres': 'Horor, Tegang',
      'rating': '7.8/10',
      'harga': '35.000'
    },
  };

  @override
  void initState() {
    super.initState();
    // Simulasi notifikasi film baru saat aplikasi dibuka
    _addSampleNotifications();
  }

  Future<void> _addSampleNotifications() async {
    // Cek apakah notifikasi sudah ada
    List<MovieNotification> existingNotifications = await NotificationService.getNotifications();
    if (existingNotifications.isEmpty) {
      // Tambahkan beberapa notifikasi contoh
      await NotificationService.addNewMovieNotification('Siksa Kubur', 'assets/siksakubur.png');
      await Future.delayed(Duration(milliseconds: 100));
      await NotificationService.addNewMovieNotification('Ancika', 'assets/ancika.jpeg');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Filmkitaa"),
        backgroundColor: const Color.fromARGB(255, 26, 158, 223),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchPage(movieDetails: movieDetails),
                ),
              );
            },
          ),
          FutureBuilder<int>(
            future: NotificationService.getUnreadCount(),
            builder: (context, snapshot) {
              int unreadCount = snapshot.data ?? 0;
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.notifications),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationPage(movieDetails: movieDetails),
                        ),
                      ).then((_) {
                        // Refresh setelah kembali dari halaman notifikasi
                        setState(() {});
                      });
                    },
                  ),
                  if (unreadCount > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          unreadCount.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.black26,
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                "Fitra Putra Aldi Wijaya",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              accountEmail: Text("aldip7669@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/poto.jpg'),
                backgroundColor: Colors.grey,
              ),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            ListTile(
              leading: Icon(Icons.recommend),
              title: Text("Rekomendasi Film"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecommendationPage(movieDetails: movieDetails)),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.offline_bolt),
              title: Text("Film Offline"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OfflinePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.bookmark),
              title: Text("Wishlist Film"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WishlistPage()),
                );
              },
            ),
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
              leading:
                  Icon(Icons.movie), // Menggunakan ikon film untuk tiket Anda
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
              leading: Icon(Icons.movie_filter),
              title: Text("Film Saya"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyMoviesPage()),
                );
              },
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
      body: MovieTicketBooking(movieDetails: movieDetails),
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
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  void _deleteTicketList(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('tiket_list');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Daftar tiket berhasil dihapus!'),
      ),
    );
  }

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

class MovieTicketBooking extends StatelessWidget {
  final Map<String, Map<String, String>> movieDetails;

  const MovieTicketBooking({Key? key, required this.movieDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: movieDetails.entries.map((entry) {
          String title = entry.key;
          Map<String, String> details = entry.value;
          return _buildMovieCard(
            context, 
            title, 
            details['imagePath'] ?? '', 
            details['genres'] ?? '', 
            details['rating'] ?? '', 
            details['harga'] ?? ''
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMovieCard(BuildContext context, String title, String imagePath,
      String genres, String rating, String harga) {
    return GestureDetector(
      onTap: () {
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
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Genre: $genres',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: <Widget>[
                      Icon(Icons.star, size: 16, color: Colors.yellow),
                      SizedBox(width: 5),
                      Text(
                        'Rating: $rating',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Harga: Rp $harga',
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