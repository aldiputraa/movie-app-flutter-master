import 'package:flutter/material.dart';
import 'movie_details_page.dart';

class SearchPage extends StatefulWidget {
  final Map<String, Map<String, String>> movieDetails;

  const SearchPage({Key? key, required this.movieDetails}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchQuery = '';
  String selectedGenre = 'Semua';
  String selectedRating = 'Semua';
  List<String> filteredMovies = [];
  
  List<String> genres = ['Semua'];
  List<String> ratings = ['Semua', '8.5+', '8.0+', '7.5+', '7.0+'];

  @override
  void initState() {
    super.initState();
    
    // Ekstrak semua genre yang unik dari film
    Set<String> uniqueGenres = {};
    widget.movieDetails.forEach((movie, details) {
      String genresStr = details['genres'] ?? '';
      genresStr.split(', ').forEach((genre) {
        if (genre.isNotEmpty) {
          uniqueGenres.add(genre);
        }
      });
    });
    
    genres.addAll(uniqueGenres);
    filteredMovies = widget.movieDetails.keys.toList();
  }

  void filterMovies() {
    setState(() {
      filteredMovies = widget.movieDetails.keys.where((movie) {
        // Filter berdasarkan judul
        bool matchesTitle = searchQuery.isEmpty || 
            movie.toLowerCase().contains(searchQuery.toLowerCase());
        
        // Filter berdasarkan genre
        bool matchesGenre = selectedGenre == 'Semua' || 
            (widget.movieDetails[movie]?['genres'] ?? '').contains(selectedGenre);
        
        // Filter berdasarkan rating
        bool matchesRating = true;
        if (selectedRating != 'Semua') {
          double minRating = double.parse(selectedRating.replaceAll('+', ''));
          String ratingStr = widget.movieDetails[movie]?['rating'] ?? '0/10';
          double movieRating = double.parse(ratingStr.split('/')[0]);
          matchesRating = movieRating >= minRating;
        }
        
        return matchesTitle && matchesGenre && matchesRating;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pencarian Film'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Cari Film',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                searchQuery = value;
                filterMovies();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Genre',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    value: selectedGenre,
                    items: genres.map((genre) {
                      return DropdownMenuItem(
                        value: genre,
                        child: Text(genre),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        selectedGenre = value;
                        filterMovies();
                      }
                    },
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Rating',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    value: selectedRating,
                    items: ratings.map((rating) {
                      return DropdownMenuItem(
                        value: rating,
                        child: Text(rating),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        selectedRating = value;
                        filterMovies();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: filteredMovies.isEmpty
                ? Center(
                    child: Text(
                      'Tidak ada film yang sesuai dengan kriteria pencarian',
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredMovies.length,
                    itemBuilder: (context, index) {
                      String movie = filteredMovies[index];
                      Map<String, String> details = widget.movieDetails[movie] ?? {};
                      
                      return ListTile(
                        leading: details['imagePath'] != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.asset(
                                  details['imagePath']!,
                                  width: 50,
                                  height: 70,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : null,
                        title: Text(movie),
                        subtitle: Text(
                          'Genre: ${details['genres'] ?? 'N/A'}\nRating: ${details['rating'] ?? 'N/A'}',
                        ),
                        isThreeLine: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieDetailsPage(
                                title: movie,
                                imagePath: details['imagePath'] ?? '',
                                genres: details['genres'] ?? '',
                                rating: details['rating'] ?? '',
                                harga: details['harga'] ?? '',
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}