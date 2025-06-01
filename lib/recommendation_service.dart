import 'package:shared_preferences/shared_preferences.dart';

class RecommendationService {
  // Mendapatkan rekomendasi film berdasarkan riwayat tontonan
  static Future<List<String>> getRecommendedMovies(
      Map<String, Map<String, String>> allMovies) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      
      // Mendapatkan daftar tiket yang dibeli (film yang ditonton)
      List<String> watchedMovies = prefs.getStringList('tiket_list') ?? [];
      
      // Jika belum ada film yang ditonton, kembalikan film dengan rating tertinggi
      if (watchedMovies.isEmpty) {
        return _getTopRatedMovies(allMovies);
      }
      
      // Mengumpulkan genre dari film yang ditonton
      Map<String, int> genrePreferences = {};
      
      for (String movie in watchedMovies) {
        if (allMovies.containsKey(movie)) {
          String genresStr = allMovies[movie]?['genres'] ?? '';
          List<String> genres = genresStr.split(', ');
          
          for (String genre in genres) {
            if (genre.isNotEmpty) {
              genrePreferences[genre] = (genrePreferences[genre] ?? 0) + 1;
            }
          }
        }
      }
      
      // Jika tidak ada preferensi genre yang ditemukan, kembalikan film dengan rating tertinggi
      if (genrePreferences.isEmpty) {
        return _getTopRatedMovies(allMovies);
      }
      
      // Mengurutkan genre berdasarkan preferensi (dari yang paling disukai)
      List<String> preferredGenres = genrePreferences.keys.toList();
      preferredGenres.sort((a, b) {
        int prefA = genrePreferences[a] ?? 0;
        int prefB = genrePreferences[b] ?? 0;
        return prefB.compareTo(prefA);
      });
      
      // Mencari film yang belum ditonton dengan genre yang disukai
      List<String> recommendations = [];
      
      for (String genre in preferredGenres) {
        if (recommendations.length >= 3) break;
        
        for (var entry in allMovies.entries) {
          if (recommendations.length >= 3) break;
          
          String movieTitle = entry.key;
          Map<String, String> details = entry.value;
          
          // Lewati film yang sudah ditonton
          if (watchedMovies.contains(movieTitle)) {
            continue;
          }
          
          // Jika film memiliki genre yang disukai, tambahkan ke rekomendasi
          String movieGenres = details['genres'] ?? '';
          if (movieGenres.contains(genre) && !recommendations.contains(movieTitle)) {
            recommendations.add(movieTitle);
          }
        }
      }
      
      // Jika rekomendasi masih kurang, tambahkan film dengan rating tertinggi
      if (recommendations.length < 3) {
        List<String> topRated = _getTopRatedMovies(allMovies);
        
        for (String movie in topRated) {
          if (recommendations.length >= 3) break;
          
          if (!recommendations.contains(movie) && !watchedMovies.contains(movie)) {
            recommendations.add(movie);
          }
        }
      }
      
      return recommendations;
    } catch (e) {
      // Jika terjadi error, kembalikan list kosong
      print('Error in getRecommendedMovies: $e');
      return [];
    }
  }
  
  // Mendapatkan film dengan rating tertinggi
  static List<String> _getTopRatedMovies(Map<String, Map<String, String>> allMovies) {
    try {
      if (allMovies.isEmpty) return [];
      
      List<MapEntry<String, Map<String, String>>> sortedMovies = 
          allMovies.entries.toList();
      
      // Mengurutkan film berdasarkan rating (dari tertinggi)
      sortedMovies.sort((a, b) {
        double ratingA = _parseRating(a.value['rating'] ?? '0/10');
        double ratingB = _parseRating(b.value['rating'] ?? '0/10');
        return ratingB.compareTo(ratingA);
      });
      
      // Mengambil judul film dengan rating tertinggi (maksimal 3)
      int count = sortedMovies.length > 3 ? 3 : sortedMovies.length;
      return sortedMovies.take(count).map((entry) => entry.key).toList();
    } catch (e) {
      print('Error in _getTopRatedMovies: $e');
      return [];
    }
  }
  
  // Mengubah string rating menjadi nilai double
  static double _parseRating(String rating) {
    try {
      if (rating.isEmpty) return 0.0;
      
      List<String> parts = rating.split('/');
      if (parts.isEmpty) return 0.0;
      
      return double.tryParse(parts[0]) ?? 0.0;
    } catch (e) {
      print('Error parsing rating: $e');
      return 0.0;
    }
  }
}