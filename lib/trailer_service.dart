import 'package:flutter/material.dart';

class TrailerService {
  // Dalam implementasi nyata, ini akan menggunakan YouTube API atau layanan video lainnya
  // Untuk demo, kita akan menggunakan URL trailer dummy
  static Map<String, String> trailerUrls = {
    'Siksa Kubur': 'https://www.youtube.com/watch?v=example1',
    'Ancika': 'https://www.youtube.com/watch?v=example2',
    'Agak Laen': 'https://www.youtube.com/watch?v=example3',
    'Badarawuhi': 'https://www.youtube.com/watch?v=example4',
    'Petualangan Anak Penangkap Hantu': 'https://www.youtube.com/watch?v=example5',
    'Sehidup Semati': 'https://www.youtube.com/watch?v=example6',
  };

  // Mendapatkan URL trailer untuk film tertentu
  static String? getTrailerUrl(String movieTitle) {
    try {
      if (movieTitle.isEmpty) return null;
      return trailerUrls[movieTitle];
    } catch (e) {
      print('Error getting trailer URL: $e');
      return null;
    }
  }

  // Menampilkan dialog trailer
  static void showTrailerDialog(BuildContext context, String movieTitle) {
    try {
      if (context == null || movieTitle.isEmpty) return;
      
      String? trailerUrl = getTrailerUrl(movieTitle);
      
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Trailer Film $movieTitle'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 200,
                  color: Colors.black,
                  child: Center(
                    child: trailerUrl != null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.play_circle_fill,
                                size: 64,
                                color: Colors.white,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Trailer $movieTitle',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'URL: $trailerUrl',
                                style: TextStyle(color: Colors.white, fontSize: 10),
                              ),
                            ],
                          )
                        : Text(
                            'Trailer tidak tersedia',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Catatan: Dalam aplikasi nyata, trailer akan diputar menggunakan YouTube Player atau video player lainnya.',
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Tutup'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error showing trailer dialog: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menampilkan trailer. Silakan coba lagi.')),
      );
    }
  }
}