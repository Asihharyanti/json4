import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TabScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dki Jakarta "Open Data"'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home), text: 'Welcome'),
              Tab(icon: Icon(Icons.place), text: 'Pariwisata'),
              Tab(icon: Icon(Icons.local_hospital), text: 'Kesehatan'),
              Tab(icon: Icon(Icons.person), text: 'Profile'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            WelcomesTab(),
            PariwisataTab(),
            KesehatanTab(),
            ProfileTab(),
          ],
        ),
      ),
    );
  }
}

class WelcomesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Selamat datang'),
    );
  }
}

class PariwisataTab extends StatelessWidget {
  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse(
        'https://ws.jakarta.go.id/gateway/DataPortalSatuDataJakarta/1.0/satudata?kategori=dataset&tipe=detail&url=indeks-kepuasan-layanan-penunjang-urusan-pemerintahan-daerah-pada-dinas-pariwisata-dan-ekonomi-kreatif'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
      future: fetchUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data found'));
        } else {
          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text(user.periode_data),
                subtitle: Text(user.triwulan),
              );
            },
          );
        }
      },
    );
  }
}

class KesehatanTab extends StatelessWidget {
  Future<List<Hospital>> fetchHospitals() async {
    final response = await http.get(Uri.parse(
        'https://ws.jakarta.go.id/gateway/DataPortalSatuDataJakarta/1.0/satudata?kategori=dataset&tipe=detail&url=perempuan-dan-anak-korban-kekerasan-yang-mendapatkan-layanan-kesehatan-oleh-tenaga-kesehatan-terlatih-di-puskesmas-mampu-tatalaksana-kekerasan-terhadap-perempuananak-ktpa-dan-pusat-pelayanan-terpadupusat-krisis-terpadu-pptpkt-di-rumah-sakit'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((hospital) => Hospital.fromJson(hospital)).toList();
    } else {
      throw Exception('Failed to load hospitals');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Hospital>>(
      future: fetchHospitals(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data found'));
        } else {
          final hospitals = snapshot.data!;
          return ListView.builder(
            itemCount: hospitals.length,
            itemBuilder: (context, index) {
              final hospital = hospitals[index];
              return ListTile(
                title: Text(hospital.lokasi),
                subtitle: Text(hospital.wilayah),
              );
            },
          );
        }
      },
    );
  }
}

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Profile information goes here'),
    );
  }
}

class User {
  final String periode_data;
  final String triwulan;

  User({required this.periode_data, required this.triwulan});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      periode_data: json['periode_data'],
      triwulan: json['triwulan'],
    );
  }
}

class Hospital {
  final String lokasi;
  final String wilayah;

  Hospital({required this.lokasi, required this.wilayah});

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      lokasi: json['lokasi'],
      wilayah: json['wilayah'],
    );
  }
}
