import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Movie {
  final String id;
  final String title;
  final String imagePath;
  final String genres;
  final String rating;
  final String harga;
  
  Movie({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.genres,
    required this.rating,
    required this.harga
  });
  
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      imagePath: json['poster_path'] ?? '',
      genres: json['genres'] ?? '',
      rating: json['vote_average']?.toString() ?? '0',
      harga: json['price'] ?? '35.000'
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'poster_path': imagePath,
      'genres': genres,
      'vote_average': rating,
      'price': harga
    };
  }
}

class ApiService {
  // Menggunakan API key demo untuk contoh
  static const String apiKey = '3e12eadf28d67ef8dea9b90c3b0d7ae5';
  static const String baseUrl = 'https://api.themoviedb.org/3';
  
  // Daftar film lokal
  static List<Movie> _localMovies = [];
  
  // Mendapatkan daftar film populer
  static Future<List<Movie>> getPopularMovies() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/movie/popular?api_key=$apiKey&language=id-ID')
      );
      
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> results = data['results'];
        
        List<Movie> movies = results.map((movieData) {
          return Movie.fromJson({
            'id': movieData['id'].toString(),
            'title': movieData['title'],
            'poster_path': 'https://image.tmdb.org/t/p/w500${movieData['poster_path']}',
            'genres': 'Film Populer',
            'vote_average': '${movieData['vote_average']}/10',
            'price': '35.000'
          });
        }).toList();
        
        // Tambahkan film lokal ke daftar
        return [...movies, ..._localMovies];
      } else {
        debugPrint('Error API: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        throw Exception('Gagal memuat data film: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Exception: $e');
      // Jika API gagal, kembalikan film lokal saja
      return _localMovies;
    }
  }
  
  // Mendapatkan daftar film yang sedang tayang
  static Future<List<Movie>> getNowPlayingMovies() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/movie/now_playing?api_key=$apiKey&language=id-ID')
      );
      
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> results = data['results'];
        
        return results.map((movieData) {
          return Movie.fromJson({
            'id': movieData['id'].toString(),
            'title': movieData['title'],
            'poster_path': 'https://image.tmdb.org/t/p/w500${movieData['poster_path']}',
            'genres': 'Sedang Tayang',
            'vote_average': '${movieData['vote_average']}/10',
            'price': '35.000'
          });
        }).toList();
      } else {
        throw Exception('Gagal memuat data film: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Exception: $e');
      throw Exception('Terjadi kesalahan: $e');
    }
  }
  
  // Mendapatkan daftar film lokal
  static Future<List<Movie>> getLocalMovies() async {
    await _loadLocalMovies();
    return _localMovies;
  }
  
  // Menambahkan film baru ke daftar lokal
  static Future<void> addLocalMovie(Movie movie) async {
    _localMovies.add(movie);
    await _saveLocalMovies();
  }
  
  // Menyimpan daftar film lokal ke SharedPreferences
  static Future<void> _saveLocalMovies() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final moviesJson = _localMovies.map((movie) => movie.toJson()).toList();
      await prefs.setString('local_movies', jsonEncode(moviesJson));
    } catch (e) {
      debugPrint('Error saving local movies: $e');
    }
  }
  
  // Memuat daftar film lokal dari SharedPreferences
  static Future<void> _loadLocalMovies() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final moviesString = prefs.getString('local_movies');
      
      if (moviesString != null) {
        final List<dynamic> moviesJson = jsonDecode(moviesString);
        _localMovies = moviesJson.map((json) => Movie.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Error loading local movies: $e');
      _localMovies = [];
    }
  }
}