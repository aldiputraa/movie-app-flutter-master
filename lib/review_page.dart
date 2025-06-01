import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Review {
  final String username;
  final double rating;
  final String comment;
  final DateTime date;

  Review({
    required this.username,
    required this.rating,
    required this.comment,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'rating': rating,
      'comment': comment,
      'date': date.toIso8601String(),
    };
  }

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      username: json['username'],
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'],
      date: DateTime.parse(json['date']),
    );
  }
}

class ReviewPage extends StatefulWidget {
  final String movieTitle;

  const ReviewPage({Key? key, required this.movieTitle}) : super(key: key);

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  List<Review> reviews = [];
  bool isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadReviews();
  }
  
  Future<void> _loadReviews() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String reviewsKey = 'reviews_${widget.movieTitle}';
    List<String>? reviewsJson = prefs.getStringList(reviewsKey);
    
    if (reviewsJson != null) {
      setState(() {
        reviews = reviewsJson
            .map((json) => Review.fromJson(jsonDecode(json)))
            .toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _saveReview(Review review) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String reviewsKey = 'reviews_${widget.movieTitle}';
    List<String> reviewsJson = prefs.getStringList(reviewsKey) ?? [];
    
    reviewsJson.add(jsonEncode(review.toJson()));
    await prefs.setStringList(reviewsKey, reviewsJson);
    
    setState(() {
      reviews.add(review);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews - ${widget.movieTitle}'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                _showReviewDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Tulis Review', style: TextStyle(fontSize: 16)),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : reviews.isEmpty
                    ? const Center(
                        child: Text(
                          'Belum ada review untuk film ini',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: reviews.length,
                        itemBuilder: (context, index) {
                          return _buildReviewCard(reviews[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Review review) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  review.username,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                _buildRatingStars(review.rating),
              ],
            ),
            const SizedBox(height: 12),
            Text(review.comment),
            const SizedBox(height: 8),
            Text(
              '${review.date.day}/${review.date.month}/${review.date.year}',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingStars(double rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 18,
        );
      }),
    );
  }

  void _showReviewDialog(BuildContext context) {
    double userRating = 3.0;
    final commentController = TextEditingController();
    final usernameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Review Film ${widget.movieTitle}'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Anda',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Rating:'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < userRating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                          ),
                          onPressed: () {
                            setState(() {
                              userRating = index + 1.0;
                            });
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: commentController,
                      decoration: const InputDecoration(
                        labelText: 'Komentar',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Batal'),
                ),
                TextButton(
                  onPressed: () {
                    if (usernameController.text.isNotEmpty &&
                        commentController.text.isNotEmpty) {
                      Navigator.of(context).pop();
                      
                      Review newReview = Review(
                        username: usernameController.text,
                        rating: userRating,
                        comment: commentController.text,
                        date: DateTime.now(),
                      );
                      
                      _saveReview(newReview);
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Review berhasil ditambahkan!'),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Nama dan komentar harus diisi!'),
                        ),
                      );
                    }
                  },
                  child: const Text('Kirim'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}