import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class OfflineService {
  static const String _offlineMoviesKey = 'offline_movies';

  // Menyimpan film untuk akses offline
  static Future<void> saveMovieForOffline(String title, Map<String, String> details) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Map<String, dynamic> offlineMovies = await getOfflineMovies();
      
      // Tambahkan atau perbarui film dalam daftar offline
      offlineMovies[title] = details;
      
      // Simpan kembali ke SharedPreferences
      await prefs.setString(_offlineMoviesKey, jsonEncode(offlineMovies));
    } catch (e) {
      print('Error saving movie offline: $e');
    }
  }

  // Mendapatkan semua film yang tersimpan untuk akses offline
  static Future<Map<String, dynamic>> getOfflineMovies() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? offlineMoviesJson = prefs.getString(_offlineMoviesKey);
      
      if (offlineMoviesJson == null || offlineMoviesJson.isEmpty) {
        return {};
      }
      
      Map<String, dynamic> result = jsonDecode(offlineMoviesJson);
      return result is Map<String, dynamic> ? result : {};
    } catch (e) {
      print('Error getting offline movies: $e');
      return {};
    }
  }

  // Memeriksa apakah film tersimpan untuk akses offline
  static Future<bool> isMovieSavedOffline(String title) async {
    try {
      if (title.isEmpty) return false;
      Map<String, dynamic> offlineMovies = await getOfflineMovies();
      return offlineMovies.containsKey(title);
    } catch (e) {
      print('Error checking if movie is saved offline: $e');
      return false;
    }
  }

  // Menghapus film dari penyimpanan offline
  static Future<void> removeMovieFromOffline(String title) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Map<String, dynamic> offlineMovies = await getOfflineMovies();
      
      if (offlineMovies.containsKey(title)) {
        offlineMovies.remove(title);
        await prefs.setString(_offlineMoviesKey, jsonEncode(offlineMovies));
      }
    } catch (e) {
      print('Error removing movie from offline: $e');
    }
  }

  // Menghapus semua film dari penyimpanan offline
  static Future<void> clearOfflineMovies() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(_offlineMoviesKey);
    } catch (e) {
      print('Error clearing offline movies: $e');
    }
  }
}