import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'payment_page.dart';
import 'disimpan_page.dart'; // Pastikan file ini diimpor

class TiketPage extends StatefulWidget {
  @override
  _TiketPageState createState() => _TiketPageState();
}

class _TiketPageState extends State<TiketPage> {
  List<String> selectedTickets = [];

  @override
  void initState() {
    super.initState();
    _loadSelectedTickets();
  }

  void _loadSelectedTickets() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedTickets = prefs.getStringList('tiket_list') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tiket Anda'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Daftar Tiket Dipilih:'),
            selectedTickets.isEmpty
                ? Text('Belum ada tiket dipilih.')
                : Column(
                    children: selectedTickets
                        .map((ticket) => ListTile(
                              title: Text(ticket),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  _deleteTicket(ticket);
                                },
                              ),
                            ))
                        .toList(),
                  ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  selectedTickets.isNotEmpty ? _navigateToPaymentPage : null,
              child: Text('Bayar'),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToPaymentPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(
          selectedTickets: selectedTickets,
          onPaymentSuccess: (message) async {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
              ),
            );
            // Hapus daftar tiket dari SharedPreferences setelah pembayaran berhasil
            await prefs.remove('tiket_list');
            // Pindahkan daftar tiket ke halaman Disimpan
            _moveToDisimpanPage(selectedTickets);
            // Refresh daftar tiket yang dipilih
            _loadSelectedTickets();
          },
        ),
      ),
    );
  }

  void _deleteTicket(String ticket) async {
    setState(() {
      selectedTickets.remove(ticket);
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('tiket_list', selectedTickets);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tiket berhasil dihapus dari daftar.'),
      ),
    );
  }

  void _moveToDisimpanPage(List<String> selectedTickets) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedTickets = prefs.getStringList('saved_list') ?? [];
    savedTickets.addAll(selectedTickets);
    await prefs.setStringList('saved_list', savedTickets);
  }
}
