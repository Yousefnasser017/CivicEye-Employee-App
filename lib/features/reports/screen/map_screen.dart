import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  final double? reportLat;
  final double? reportLng;

  const MapScreen({super.key, required this.reportLat, required this.reportLng});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? currentLocation;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    final hasPermission = await Geolocator.checkPermission();
    if (hasPermission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.reportLat == null || widget.reportLng == null) {
      return const Scaffold(
        body: Center(child: Text('لا توجد إحداثيات لهذا البلاغ')),
      );
    }

    final reportLocation = LatLng(widget.reportLat!, widget.reportLng!);

    return Scaffold(
      appBar: AppBar(title: const Text("الخريطة")),
      body: FlutterMap(
        mapController: MapController(),
        options: MapOptions(
          initialCenter: reportLocation,
          initialZoom: 15,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: 'com.example.civiceye',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: reportLocation,
                width: 60,
                height: 60,
                child: const Icon(Icons.location_on, color: Colors.red, size: 40),
              ),
              if (currentLocation != null)
                Marker(
                  point: currentLocation!,
                  width: 60,
                  height: 60,
                  child: const Icon(Icons.person_pin_circle, color: Colors.blue, size: 35),
                ),
            ],
          ),
          if (currentLocation != null)
            PolylineLayer(
              polylines: [
                Polyline(
                  points: [currentLocation!, reportLocation],
                  strokeWidth: 4,
                  color: Colors.blue,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
