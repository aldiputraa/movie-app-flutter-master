import 'package:flutter/material.dart';
import 'recommendation_service.dart';
import 'movie_details_page.dart';

class RecommendationPage extends StatefulWidget {
  final Map<String, Map<String, String>> movieDetails;

  const RecommendationPage({Key? key, required this.movieDetails}) : super(key: key);

  @override
  _RecommendationPageState createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage> {
  List<String> recommendedMovies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecommendations();
  }

  Future<void> _loadRecommendations() async {
    List<String> recommendations = await RecommendationService.getRecommendedMovies(widget.movieDetails);
    setState(() {
      recommendedMovies = recommendations;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rekomendasi Film Untuk Anda'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : recommendedMovies.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.movie_filter,
                        size: 80,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Belum ada rekomendasi film',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Beli tiket film untuk mendapatkan rekomendasi',
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
                  itemCount: recommendedMovies.length,
                  itemBuilder: (context, index) {
                    String movieTitle = recommendedMovies[index];
                    Map<String, String> details = widget.movieDetails[movieTitle] ?? {};
                    
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: InkWell(
                        onTap: () {
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
                                      movieTitle,
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
                                      'Direkomendasikan berdasarkan riwayat tontonan Anda',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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