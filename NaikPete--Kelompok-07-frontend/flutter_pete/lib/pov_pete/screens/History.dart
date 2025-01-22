import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  final String username;

  const HistoryScreen({required this.username, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Riwayat Perjalanan"),
      ),
      body: ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          final trip = history[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(trip.trayekName),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Rute berangkat: ${trip.goRoute}"),
                  Text("Rute balik: ${trip.backRoute}"),
                  Text("Waktu: ${trip.timestamp.toString()}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class TripHistory {
  final String trayekName;
  final String goRoute;
  final String backRoute;
  final DateTime timestamp;

  TripHistory({
    required this.trayekName,
    required this.goRoute,
    required this.backRoute,
    required this.timestamp,
  });
}

// List untuk menyimpan riwayat perjalanan
List<TripHistory> history = [];