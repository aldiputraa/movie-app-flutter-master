import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class AddMoviePage extends StatefulWidget {
  @override
  _AddMoviePageState createState() => _AddMoviePageState();
}

class _AddMoviePageState extends State<AddMoviePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _genreController = TextEditingController();
  final _ratingController = TextEditingController();
  final _hargaController = TextEditingController();
  final _imageUrlController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _genreController.dispose();
    _ratingController.dispose();
    _hargaController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _submitMovie() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Simulasi penambahan film ke API
        await Future.delayed(Duration(seconds: 2));
        
        // Tambahkan film ke daftar lokal
        final newMovie = Movie(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: _titleController.text,
          imagePath: _imageUrlController.text.isEmpty 
              ? 'assets/siksakubur.png' // Default image
              : _imageUrlController.text,
          genres: _genreController.text,
          rating: _ratingController.text,
          harga: _hargaController.text,
        );
        
        // Tambahkan ke cache lokal jika diperlukan
        ApiService.addLocalMovie(newMovie);
        
        setState(() {
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Film berhasil ditambahkan')),
        );
        
        Navigator.pop(context, true); // Kembali dengan status sukses
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan film: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Film Baru'),
        backgroundColor: const Color.fromARGB(255, 26, 158, 223),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Judul Film',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Judul film tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _genreController,
                  decoration: InputDecoration(
                    labelText: 'Genre (pisahkan dengan koma)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Genre tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _ratingController,
                  decoration: InputDecoration(
                    labelText: 'Rating (contoh: 8.5/10)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Rating tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _hargaController,
                  decoration: InputDecoration(
                    labelText: 'Harga (tanpa Rp)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Harga tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _imageUrlController,
                  decoration: InputDecoration(
                    labelText: 'URL Gambar (opsional)',
                    border: OutlineInputBorder(),
                    helperText: 'Kosongkan untuk menggunakan gambar default',
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitMovie,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : Text('Tambahkan Film'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}