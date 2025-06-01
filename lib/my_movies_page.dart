import 'package:flutter/material.dart';
import 'my_movies_service.dart';
import 'movie_details_page.dart';

class MyMoviesPage extends StatefulWidget {
  @override
  _MyMoviesPageState createState() => _MyMoviesPageState();
}

class _MyMoviesPageState extends State<MyMoviesPage> {
  late Future<List<MyMovie>> _moviesFuture;
  
  @override
  void initState() {
    super.initState();
    _loadMovies();
  }
  
  void _loadMovies() {
    _moviesFuture = MyMoviesService.getMyMovies();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Film Saya'),
        backgroundColor: const Color.fromARGB(255, 26, 158, 223),
      ),
      body: FutureBuilder<List<MyMovie>>(
        future: _moviesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.movie_creation_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Belum ada film yang ditambahkan',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      _showAddMovieDialog(context);
                    },
                    child: Text('Tambah Film Baru'),
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final movie = snapshot.data![index];
                return _buildMovieCard(context, movie);
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddMovieDialog(context);
        },
        child: Icon(Icons.add),
        tooltip: 'Tambah Film',
      ),
    );
  }
  
  Widget _buildMovieCard(BuildContext context, MyMovie movie) {
    return Dismissible(
      key: Key(movie.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Konfirmasi'),
              content: Text('Apakah Anda yakin ingin menghapus film "${movie.title}"?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Batal'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Hapus'),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) async {
        await MyMoviesService.deleteMovie(movie.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Film "${movie.title}" telah dihapus')),
        );
        setState(() {
          _loadMovies();
        });
      },
      child: Card(
        margin: EdgeInsets.all(8),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetailsPage(
                  title: movie.title,
                  imagePath: movie.imagePath,
                  genres: movie.genres,
                  rating: movie.rating,
                  harga: movie.harga,
                ),
              ),
            );
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  bottomLeft: Radius.circular(4),
                ),
                child: movie.imagePath.startsWith('http') || movie.imagePath.startsWith('assets')
                  ? Image.network(
                      movie.imagePath.startsWith('http') ? movie.imagePath : 'https://via.placeholder.com/100x150?text=Film',
                      width: 100,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/siksakubur.png',
                          width: 100,
                          height: 150,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.asset(
                      movie.imagePath,
                      width: 100,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 100,
                          height: 150,
                          color: Colors.grey,
                          child: Icon(Icons.movie, color: Colors.white),
                        );
                      },
                    ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text('Genre: ${movie.genres}'),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.star, size: 16, color: Colors.amber),
                          SizedBox(width: 4),
                          Text('Rating: ${movie.rating}'),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text('Harga: Rp ${movie.harga}'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showAddMovieDialog(BuildContext context) {
    final _titleController = TextEditingController();
    final _genresController = TextEditingController();
    final _ratingController = TextEditingController();
    final _hargaController = TextEditingController();
    final _imagePathController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tambah Film Baru'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Judul Film',
                    hintText: 'Masukkan judul film',
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _genresController,
                  decoration: InputDecoration(
                    labelText: 'Genre',
                    hintText: 'Contoh: Action, Drama',
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _ratingController,
                  decoration: InputDecoration(
                    labelText: 'Rating',
                    hintText: 'Contoh: 8.5/10',
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _hargaController,
                  decoration: InputDecoration(
                    labelText: 'Harga',
                    hintText: 'Contoh: 35.000',
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _imagePathController,
                  decoration: InputDecoration(
                    labelText: 'URL Gambar (opsional)',
                    hintText: 'Masukkan URL gambar',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                if (_titleController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Judul film tidak boleh kosong')),
                  );
                  return;
                }
                
                final newMovie = MyMovie(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: _titleController.text,
                  genres: _genresController.text.isEmpty ? 'Tidak ada genre' : _genresController.text,
                  rating: _ratingController.text.isEmpty ? '0/10' : _ratingController.text,
                  harga: _hargaController.text.isEmpty ? '0' : _hargaController.text,
                  imagePath: _imagePathController.text.isEmpty ? 'assets/siksakubur.png' : _imagePathController.text,
                );
                
                bool success = await MyMoviesService.addMovie(newMovie);
                
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Film berhasil ditambahkan')),
                  );
                  setState(() {
                    _loadMovies();
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal menambahkan film')),
                  );
                }
                
                Navigator.of(context).pop();
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }
}