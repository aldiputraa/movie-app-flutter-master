import 'package:flutter/material.dart';
import 'notification_service.dart';
import 'movie_details_page.dart';

class NotificationPage extends StatefulWidget {
  final Map<String, Map<String, String>> movieDetails;

  const NotificationPage({Key? key, required this.movieDetails}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<MovieNotification> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    List<MovieNotification> loadedNotifications = await NotificationService.getNotifications();
    setState(() {
      notifications = loadedNotifications;
      isLoading = false;
    });
  }

  Future<void> _markAsRead(int index) async {
    await NotificationService.markAsRead(index);
    await _loadNotifications();
  }

  Future<void> _clearAllNotifications() async {
    await NotificationService.clearNotifications();
    await _loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifikasi'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_sweep),
            onPressed: notifications.isEmpty ? null : _clearAllNotifications,
            tooltip: 'Hapus Semua Notifikasi',
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : notifications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_off,
                        size: 80,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Tidak ada notifikasi',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    MovieNotification notification = notifications[index];
                    String movieTitle = _extractMovieTitle(notification.message);
                    
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      color: notification.isRead ? null : Colors.blue.shade50,
                      child: ListTile(
                        leading: Icon(
                          Icons.movie,
                          color: Colors.blue,
                          size: 36,
                        ),
                        title: Text(
                          notification.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4),
                            Text(notification.message),
                            SizedBox(height: 4),
                            Text(
                              _formatDate(notification.date),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        isThreeLine: true,
                        onTap: () {
                          _markAsRead(index);
                          
                          // Jika notifikasi berisi judul film yang valid, buka halaman detail film
                          if (movieTitle.isNotEmpty && widget.movieDetails.containsKey(movieTitle)) {
                            Map<String, String> details = widget.movieDetails[movieTitle]!;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MovieDetailsPage(
                                  title: movieTitle,
                                  imagePath: details['imagePath'] ?? '',
                                  genres: details['genres'] ?? '',
                                  rating: details['rating'] ?? '',
                                  harga: details['harga'] ?? '',
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
    );
  }

  String _extractMovieTitle(String message) {
    // Ekstrak judul film dari pesan notifikasi
    RegExp regExp = RegExp(r'"([^"]*)"');
    Match? match = regExp.firstMatch(message);
    return match != null ? match.group(1) ?? '' : '';
  }

  String _formatDate(DateTime date) {
    // Format tanggal untuk tampilan
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}