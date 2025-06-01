import 'package:flutter/material.dart';
import 'wishlist_service.dart';
import 'movie_details_page.dart';

class WishlistPage extends StatefulWidget {
  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  Map<String, dynamic> wishlistMovies = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    Map<String, dynamic> wishlist = await WishlistService.getWishlist();
    setState(() {
      wishlistMovies = wishlist;
      isLoading = false;
    });
  }

  Future<void> _removeFromWishlist(String title) async {
    await WishlistService.removeFromWishlist(title);
    await _loadWishlist();
  }

  Future<void> _clearWishlist() async {
    await WishlistService.clearWishlist();
    await _loadWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wishlist Film'),
        actions: [
          if (wishlistMovies.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete_sweep),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Hapus Semua Film dari Wishlist'),
                    content: Text('Apakah Anda yakin ingin menghapus semua film dari wishlist?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _clearWishlist();
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
          : wishlistMovies.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bookmark_border,
                        size: 80,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Wishlist Anda kosong',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tambahkan film yang ingin Anda tonton di masa mendatang',
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
                  itemCount: wishlistMovies.length,
                  itemBuilder: (context, index) {
                    String title = wishlistMovies.keys.elementAt(index);
                    Map<String, dynamic> details = wishlistMovies[title];
                    
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
                          ).then((_) => _loadWishlist());
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
                                      'Ditambahkan ke wishlist',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.purple,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete_outline),
                              onPressed: () => _removeFromWishlist(title),
                              tooltip: 'Hapus dari wishlist',
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