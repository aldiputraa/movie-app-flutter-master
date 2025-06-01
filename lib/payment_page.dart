import 'package:flutter/material.dart';

class PaymentPage extends StatelessWidget {
  final List<String> selectedTickets;
  final Function(String) onPaymentSuccess;

  PaymentPage({required this.selectedTickets, required this.onPaymentSuccess});

  @override
  Widget build(BuildContext context) {
    // Menghitung total harga tiket yang dipilih
    int totalHarga =
        selectedTickets.length * 35000; // Harga tiket per film 35.000

    return Scaffold(
      appBar: AppBar(
        title: Text('Pembayaran'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Detail Pembayaran:'),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: selectedTickets.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(selectedTickets[index]),
                  trailing: Text('Rp 35.000'), // Harga per tiket
                );
              },
            ),
            Divider(),
            ListTile(
              title: Text('Total Pembayaran:'),
              trailing: Text('Rp $totalHarga'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                onPaymentSuccess(
                    'Pembayaran berhasil dan cek tiket ada di halaman disimpan!');
                Navigator.of(context).pop();
              },
              child: Text('Bayar'),
            ),
          ],
        ),
      ),
    );
  }
}
