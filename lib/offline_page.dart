import 'package:flutter/material.dart';
import 'offline_service.dart';
import 'movie_details_page.dart';

class OfflinePage extends StatefulWidget {
  @override
  _OfflinePageState createState() => _OfflinePageState();
}

class _OfflinePageState extends State<OfflinePage> {
  Map<String, dynamic> offlineMovies = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOfflineMovies();
  }

  Future<void> _loadOfflineMovies() async {
    Map<String, dynamic> movies = await OfflineService.getOfflineMovies();
    setState(() {
      offlineMovies = movies;
      isLoading = false;
    });
  }

  Future<void> _removeFromOffline(String title) async {
    await OfflineService.removeMovieFromOffline(title);
    await _loadOfflineMovies();
  }

  Future<void> _clearAllOfflineMovies() async {
    await OfflineService.clearOfflineMovies();
    await _loadOfflineMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Film Tersimpan Offline'),
        actions: [
          if (offlineMovies.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete_sweep),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Hapus Semua Film Offline'),
                    content: Text('Apakah Anda yakin ingin menghapus semua film yang tersimpan offline?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _clearAllOfflineMovies();
                        },
                        child: Text('Hapus'),
                      ),
                    ],
                  ),
                );
              },
              tooltip: 'Hapus Semua',
            ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : offlineMovies.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.offline_bolt,
                        size: 80,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Tidak ada film tersimpan offline',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Simpan film untuk diakses tanpa koneksi internet',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: offlineMovies.length,
                  itemBuilder: (context, index) {
                    String title = offlineMovies.keys.elementAt(index);
                    Map<String, dynamic> details = offlineMovies[title];
                    
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieDetailsPage(
                                title: title,
                                imagePath: details['imagePath'] ?? '',
                                genres: details['genres'] ?? '',
                                rating: details['rating'] ?? '',
                                harga: details['harga'] ?? '',
                              ),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4),
                                bottomLeft: Radius.circular(4),
                              ),
                              child: Image.asset(
                                details['imagePath'] ?? '',
                                width: 100,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Genre: ${details['genres'] ?? ''}',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.star, size: 16, color: Colors.amber),
                                        SizedBox(width: 4),
                                        Text(
                                          'Rating: ${details['rating'] ?? ''}',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Tersedia untuk akses offline',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete_outline),
                              onPressed: () => _removeFromOffline(title),
                              tooltip: 'Hapus dari offline',
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}