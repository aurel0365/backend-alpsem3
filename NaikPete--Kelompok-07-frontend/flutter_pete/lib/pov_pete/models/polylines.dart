import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class RoutePolyline {
  final List<LatLng> points;
  final Color color;

  RoutePolyline({required this.points, this.color = Colors.blue});
}