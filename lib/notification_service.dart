import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MovieNotification {
  final String title;
  final String message;
  final DateTime date;
  final bool isRead;

  MovieNotification({
    required this.title,
    required this.message,
    required this.date,
    this.isRead = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'message': message,
      'date': date.toIso8601String(),
      'isRead': isRead,
    };
  }

  factory MovieNotification.fromJson(Map<String, dynamic> json) {
    try {
      return MovieNotification(
        title: json['title'] ?? '',
        message: json['message'] ?? '',
        date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
        isRead: json['isRead'] ?? false,
      );
    } catch (e) {
      print('Error parsing notification: $e');
      return MovieNotification(
        title: 'Error',
        message: 'Terjadi kesalahan saat memuat notifikasi',
        date: DateTime.now(),
      );
    }
  }
}

class NotificationService {
  static const String _notificationsKey = 'movie_notifications';

  // Mendapatkan semua notifikasi
  static Future<List<MovieNotification>> getNotifications() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? notificationsJson = prefs.getStringList(_notificationsKey);
      
      if (notificationsJson == null || notificationsJson.isEmpty) {
        return [];
      }
      
      List<MovieNotification> notifications = [];
      for (String json in notificationsJson) {
        try {
          Map<String, dynamic> data = jsonDecode(json);
          notifications.add(MovieNotification.fromJson(data));
        } catch (e) {
          print('Error decoding notification: $e');
        }
      }
      
      // Urutkan berdasarkan tanggal terbaru
      notifications.sort((a, b) => b.date.compareTo(a.date));
      return notifications;
    } catch (e) {
      print('Error getting notifications: $e');
      return [];
    }
  }

  // Menambahkan notifikasi baru
  static Future<void> addNotification(MovieNotification notification) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> notificationsJson = prefs.getStringList(_notificationsKey) ?? [];
      
      notificationsJson.add(jsonEncode(notification.toJson()));
      await prefs.setStringList(_notificationsKey, notificationsJson);
    } catch (e) {
      print('Error adding notification: $e');
    }
  }

  // Menandai notifikasi sebagai sudah dibaca
  static Future<void> markAsRead(int index) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? notificationsJson = prefs.getStringList(_notificationsKey);
      
      if (notificationsJson == null || index < 0 || index >= notificationsJson.length) {
        return;
      }
      
      List<MovieNotification> notifications = [];
      for (String json in notificationsJson) {
        try {
          Map<String, dynamic> data = jsonDecode(json);
          notifications.add(MovieNotification.fromJson(data));
        } catch (e) {
          print('Error decoding notification: $e');
        }
      }
      
      if (index < notifications.length) {
        notifications[index] = MovieNotification(
          title: notifications[index].title,
          message: notifications[index].message,
          date: notifications[index].date,
          isRead: true,
        );
        
        List<String> updatedNotificationsJson = notifications
            .map((notification) => jsonEncode(notification.toJson()))
            .toList();
        
        await prefs.setStringList(_notificationsKey, updatedNotificationsJson);
      }
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  // Menghapus semua notifikasi
  static Future<void> clearNotifications() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(_notificationsKey);
    } catch (e) {
      print('Error clearing notifications: $e');
    }
  }

  // Mendapatkan jumlah notifikasi yang belum dibaca
  static Future<int> getUnreadCount() async {
    try {
      List<MovieNotification> notifications = await getNotifications();
      return notifications.where((notification) => !notification.isRead).length;
    } catch (e) {
      print('Error getting unread count: $e');
      return 0;
    }
  }

  // Menambahkan notifikasi film baru
  static Future<void> addNewMovieNotification(String movieTitle, String imageUrl) async {
    try {
      if (movieTitle.isEmpty) return;
      
      MovieNotification notification = MovieNotification(
        title: 'Film Baru Dirilis!',
        message: 'Film "$movieTitle" telah ditambahkan ke daftar film. Jangan lewatkan!',
        date: DateTime.now(),
      );
      
      await addNotification(notification);
    } catch (e) {
      print('Error adding new movie notification: $e');
    }
  }
}