import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyMovie {
  final String id;
  final String title;
  final String imagePath;
  final String genres;
  final String rating;
  final String harga;
  
  MyMovie({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.genres,
    required this.rating,
    required this.harga
  });
  
  factory MyMovie.fromJson(Map<String, dynamic> json) {
    return MyMovie(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      imagePath: json['imagePath'] ?? '',
      genres: json['genres'] ?? '',
      rating: json['rating'] ?? '',
      harga: json['harga'] ?? ''
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imagePath': imagePath,
      'genres': genres,
      'rating': rating,
      'harga': harga
    };
  }
}

class MyMoviesService {
  static const String _storageKey = 'my_movies';
  
  // Mendapatkan semua film
  static Future<List<MyMovie>> getMyMovies() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? moviesJson = prefs.getString(_storageKey);
      
      if (moviesJson == null) {
        return [];
      }
      
      List<dynamic> decoded = jsonDecode(moviesJson);
      return decoded.map((item) => MyMovie.fromJson(item)).toList();
    } catch (e) {
      debugPrint('Error loading movies: $e');
      return [];
    }
  }
  
  // Menambahkan film baru
  static Future<bool> addMovie(MyMovie movie) async {
    try {
      List<MyMovie> movies = await getMyMovies();
      movies.add(movie);
      return await _saveMovies(movies);
    } catch (e) {
      debugPrint('Error adding movie: $e');
      return false;
    }
  }
  
  // Menghapus film
  static Future<bool> deleteMovie(String id) async {
    try {
      List<MyMovie> movies = await getMyMovies();
      movies.removeWhere((movie) => movie.id == id);
      return await _saveMovies(movies);
    } catch (e) {
      debugPrint('Error deleting movie: $e');
      return false;
    }
  }
  
  // Menyimpan daftar film
  static Future<bool> _saveMovies(List<MyMovie> movies) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<Map<String, dynamic>> jsonList = movies.map((movie) => movie.toJson()).toList();
      return await prefs.setString(_storageKey, jsonEncode(jsonList));
    } catch (e) {
      debugPrint('Error saving movies: $e');
      return false;
    }
  }
}