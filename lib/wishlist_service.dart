import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WishlistService {
  static const String _wishlistKey = 'movie_wishlist';

  // Menambahkan film ke wishlist
  static Future<void> addToWishlist(String title, Map<String, String> details) async {
    try {
      if (title.isEmpty) return;
      
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Map<String, dynamic> wishlist = await getWishlist();
      
      // Tambahkan film ke wishlist
      wishlist[title] = details;
      
      // Simpan kembali ke SharedPreferences
      await prefs.setString(_wishlistKey, jsonEncode(wishlist));
    } catch (e) {
      print('Error adding to wishlist: $e');
    }
  }

  // Mendapatkan semua film dalam wishlist
  static Future<Map<String, dynamic>> getWishlist() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? wishlistJson = prefs.getString(_wishlistKey);
      
      if (wishlistJson == null || wishlistJson.isEmpty) {
        return {};
      }
      
      Map<String, dynamic> result = jsonDecode(wishlistJson);
      return result is Map<String, dynamic> ? result : {};
    } catch (e) {
      print('Error getting wishlist: $e');
      return {};
    }
  }

  // Memeriksa apakah film ada dalam wishlist
  static Future<bool> isInWishlist(String title) async {
    try {
      if (title.isEmpty) return false;
      Map<String, dynamic> wishlist = await getWishlist();
      return wishlist.containsKey(title);
    } catch (e) {
      print('Error checking if movie is in wishlist: $e');
      return false;
    }
  }

  // Menghapus film dari wishlist
  static Future<void> removeFromWishlist(String title) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Map<String, dynamic> wishlist = await getWishlist();
      
      if (wishlist.containsKey(title)) {
        wishlist.remove(title);
        await prefs.setString(_wishlistKey, jsonEncode(wishlist));
      }
    } catch (e) {
      print('Error removing from wishlist: $e');
    }
  }

  // Menghapus semua film dari wishlist
  static Future<void> clearWishlist() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(_wishlistKey);
    } catch (e) {
      print('Error clearing wishlist: $e');
    }
  }
}