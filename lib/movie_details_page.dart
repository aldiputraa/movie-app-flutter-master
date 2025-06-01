import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'review_page.dart';
import 'social_share_service.dart';
import 'offline_service.dart';
import 'trailer_service.dart';
import 'wishlist_service.dart';

class MovieDetailsPage extends StatefulWidget {
  final String title;
  final String imagePath;
  final String genres;
  final String rating;
  final String harga;

  const MovieDetailsPage({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.genres,
    required this.rating,
    required this.harga,
  }) : super(key: key);

  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.movie),
            onPressed: () {
              TrailerService.showTrailerDialog(context, widget.title);
            },
            tooltip: 'Tonton Trailer',
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              SocialShareService.shareMovie(context, widget.title, widget.genres, widget.rating);
            },
            tooltip: 'Bagikan Film',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset(
              widget.imagePath,
              height: 300,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Genre: ${widget.genres}',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Rating: ${widget.rating}',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Harga: Rp ${widget.harga}',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _showPurchaseDialog(context);
                          },
                          child: const Text('Pesan Tiket'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReviewPage(movieTitle: widget.title),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text('Lihat Review'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: FutureBuilder<bool>(
                          future: OfflineService.isMovieSavedOffline(widget.title),
                          builder: (context, snapshot) {
                            bool isSaved = snapshot.data ?? false;
                            return ElevatedButton.icon(
                              onPressed: () async {
                                if (isSaved) {
                                  await OfflineService.removeMovieFromOffline(widget.title);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Film dihapus dari akses offline')),
                                  );
                                } else {
                                  Map<String, String> movieDetails = {
                                    'imagePath': widget.imagePath,
                                    'genres': widget.genres,
                                    'rating': widget.rating,
                                    'harga': widget.harga,
                                  };
                                  await OfflineService.saveMovieForOffline(widget.title, movieDetails);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Film disimpan untuk akses offline')),
                                  );
                                }
                                // Refresh state untuk memperbarui tombol
                                setState(() {});
                              },
                              icon: Icon(isSaved ? Icons.offline_pin : Icons.offline_bolt),
                              label: Text(isSaved ? 'Hapus Offline' : 'Simpan Offline'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isSaved ? Colors.red : Colors.blue,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FutureBuilder<bool>(
                          future: WishlistService.isInWishlist(widget.title),
                          builder: (context, snapshot) {
                            bool isInWishlist = snapshot.data ?? false;
                            return ElevatedButton.icon(
                              onPressed: () async {
                                if (isInWishlist) {
                                  await WishlistService.removeFromWishlist(widget.title);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Film dihapus dari wishlist')),
                                  );
                                } else {
                                  Map<String, String> movieDetails = {
                                    'imagePath': widget.imagePath,
                                    'genres': widget.genres,
                                    'rating': widget.rating,
                                    'harga': widget.harga,
                                  };
                                  await WishlistService.addToWishlist(widget.title, movieDetails);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Film ditambahkan ke wishlist')),
                                  );
                                }
                                // Refresh state untuk memperbarui tombol
                                setState(() {});
                              },
                              icon: Icon(isInWishlist ? Icons.bookmark : Icons.bookmark_border),
                              label: Text(isInWishlist ? 'Hapus Wishlist' : 'Tambah Wishlist'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isInWishlist ? Colors.purple : Colors.deepPurple,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPurchaseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Pembelian'),
          content: Text('Anda yakin ingin membeli tiket untuk ${widget.title}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _purchaseTicket(context);
              },
              child: const Text('Pesan'),
            ),
          ],
        );
      },
    );
  }

  void _purchaseTicket(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tiketList = prefs.getStringList('tiket_list') ?? [];
    tiketList.add(widget.title); // Tambahkan judul film sebagai tiket
    await prefs.setStringList('tiket_list', tiketList);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tiket berhasil ditambahkan!'),
      ),
    );
  }
}