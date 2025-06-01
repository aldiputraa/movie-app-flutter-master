import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SocialShareService {
  // Fungsi untuk berbagi ke media sosial
  static void shareMovie(BuildContext context, String title, String genre, String rating) {
    try {
      String shareText = "Saya merekomendasikan film \"$title\"!\n"
          "Genre: $genre\n"
          "Rating: $rating\n\n"
          "Tonton sekarang di aplikasi Filmkitaa!";
      
      // Tampilkan dialog berbagi
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Bagikan Film',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSocialButton(
                      context,
                      'WhatsApp',
                      Icons.message,
                      Colors.green,
                      () => _shareToWhatsApp(context, shareText),
                    ),
                    _buildSocialButton(
                      context,
                      'Facebook',
                      Icons.facebook,
                      Colors.blue,
                      () => _shareToFacebook(context, shareText),
                    ),
                    _buildSocialButton(
                      context,
                      'Twitter',
                      Icons.chat,
                      Colors.lightBlue,
                      () => _shareToTwitter(context, shareText),
                    ),
                    _buildSocialButton(
                      context,
                      'Copy',
                      Icons.copy,
                      Colors.grey,
                      () => _copyToClipboard(context, shareText),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      print('Error sharing movie: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal membagikan film. Silakan coba lagi.')),
      );
    }
  }

  // Fungsi untuk membuat tombol media sosial
  static Widget _buildSocialButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onPressed,
          child: CircleAvatar(
            radius: 25,
            backgroundColor: color,
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(label),
      ],
    );
  }

  // Fungsi untuk berbagi ke WhatsApp
  static void _shareToWhatsApp(BuildContext context, String text) {
    try {
      Navigator.pop(context);
      // Dalam aplikasi nyata, gunakan package seperti url_launcher atau share_plus
      // untuk membuka WhatsApp dengan teks yang sudah diisi
      _showShareSimulation(context, 'WhatsApp', text);
    } catch (e) {
      print('Error sharing to WhatsApp: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal membagikan ke WhatsApp')),
      );
    }
  }

  // Fungsi untuk berbagi ke Facebook
  static void _shareToFacebook(BuildContext context, String text) {
    try {
      Navigator.pop(context);
      // Dalam aplikasi nyata, gunakan package seperti url_launcher atau share_plus
      // untuk membuka Facebook dengan teks yang sudah diisi
      _showShareSimulation(context, 'Facebook', text);
    } catch (e) {
      print('Error sharing to Facebook: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal membagikan ke Facebook')),
      );
    }
  }

  // Fungsi untuk berbagi ke Twitter
  static void _shareToTwitter(BuildContext context, String text) {
    try {
      Navigator.pop(context);
      // Dalam aplikasi nyata, gunakan package seperti url_launcher atau share_plus
      // untuk membuka Twitter dengan teks yang sudah diisi
      _showShareSimulation(context, 'Twitter', text);
    } catch (e) {
      print('Error sharing to Twitter: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal membagikan ke Twitter')),
      );
    }
  }

  // Fungsi untuk menyalin ke clipboard
  static void _copyToClipboard(BuildContext context, String text) {
    try {
      Clipboard.setData(ClipboardData(text: text));
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Teks berhasil disalin ke clipboard!'),
        ),
      );
    } catch (e) {
      print('Error copying to clipboard: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyalin teks')),
      );
    }
  }

  // Fungsi untuk mensimulasikan berbagi (untuk demo)
  static void _showShareSimulation(BuildContext context, String platform, String text) {
    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Berbagi ke $platform'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Teks yang akan dibagikan:'),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(text),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Tutup'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error showing share simulation: $e');
    }
  }
}