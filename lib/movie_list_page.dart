import 'package:flutter/material.dart';
import 'api_service.dart';
import 'movie_details_page.dart';
import 'add_movie_page.dart';

class MovieListPage extends StatefulWidget {
  @override
  _MovieListPageState createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<Movie>> _popularMoviesFuture;
  late Future<List<Movie>> _nowPlayingMoviesFuture;
  late Future<List<Movie>> _localMoviesFuture;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadMovies();
  }
  
  void _loadMovies() {
    _popularMoviesFuture = ApiService.getPopularMovies();
    _nowPlayingMoviesFuture = ApiService.getNowPlayingMovies();
    _localMoviesFuture = ApiService.getLocalMovies();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Film dari API'),
        backgroundColor: const Color.fromARGB(255, 26, 158, 223),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Film Populer'),
            Tab(text: 'Sedang Tayang'),
            Tab(text: 'Film Saya'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMovieTab(_popularMoviesFuture),
          _buildMovieTab(_nowPlayingMoviesFuture),
          _buildMovieTab(_localMoviesFuture),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddMoviePage()),
              );
              
              if (result == true) {
                setState(() {
                  _loadMovies();
                });
              }
            },
            heroTag: 'add',
            child: Icon(Icons.add),
            tooltip: 'Tambah Film',
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _loadMovies();
              });
            },
            heroTag: 'refresh',
            child: Icon(Icons.refresh),
            tooltip: 'Refresh data',
          ),
        ],
      ),
    );
  }
  
  Widget _buildMovieTab(Future<List<Movie>> moviesFuture) {
    return FutureBuilder<List<Movie>>(
      future: moviesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${snapshot.error}'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _loadMovies();
                    });
                  },
                  child: Text('Coba Lagi'),
                ),
              ],
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Tidak ada film yang tersedia'));
        } else {
          return _buildMovieList(snapshot.data!);
        }
      },
    );
  }
  
  Widget _buildMovieList(List<Movie> movies) {
    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return _buildMovieCard(
          context,
          movie.title,
          movie.imagePath,
          movie.genres,
          movie.rating,
          movie.harga,
          movie.id
        );
      },
    );
  }
  
  Widget _buildMovieCard(BuildContext context, String title, String imagePath,
      String genres, String rating, String harga, String id) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailsPage(
              title: title,
              imagePath: imagePath,
              genres: genres,
              rating: rating,
              harga: harga,
            ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
              child: imagePath.startsWith('http')
                ? Image.network(
                    imagePath,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      print('Error loading image: $error');
                      return Container(
                        height: 200,
                        color: Colors.grey,
                        child: Center(child: Text('Gambar tidak tersedia')),
                      );
                    },
                  )
                : Image.asset(
                    imagePath,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Genre: $genres',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: <Widget>[
                      Icon(Icons.star, size: 16, color: Colors.yellow),
                      SizedBox(width: 5),
                      Text(
                        'Rating: $rating',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Harga: Rp $harga',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}