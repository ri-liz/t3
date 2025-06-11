import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<dynamic> hariLibur = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  //ambil data json dari link/API
  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse('https://api-harilibur.vercel.app/api'),
    );
    if (response.statusCode == 200) {
      setState(() {
        hariLibur = json.decode(response.body);
      });
    } else {
      debugPrint('gagal load data');
    }
  }

  //blok untuk menampilkan data yang diambil dari api
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: hariLibur.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: hariLibur.length,
              itemBuilder: (context, index) {
                var item = hariLibur[index];
                var date = item['holiday_date'];
                var name = item['holiday_name'];
                var nasional = item['is_national_holiday'] == true;

                return ListTile(
                  leading: Icon(
                    nasional ? Icons.flag : Icons.event,
                    color: nasional ? Colors.red : Colors.blueGrey,
                  ),

                  title: Text(name),
                  subtitle: Text("tanggal: $date"),
                  trailing: nasional
                      ? const Text(
                          "hari libur nasional",
                          style: TextStyle(color: Colors.red),
                        )
                      : const Text(
                          "hari libur",
                          style: TextStyle(color: Colors.grey),
                        ),
                );
              },
            ),
    );
  }

  // akhir untuk menampilkan data yang diambil dari api
}
