import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  final double? longitude;
  final double? latitude;

  const MapScreen({super.key, required this.longitude, required this.latitude});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? currentLocation;
  bool isLoadingLocation = true;
  List<LatLng> routePoints = [];

  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    if (!(await Geolocator.isLocationServiceEnabled())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('يرجى تفعيل خدمة الموقع (GPS) من الإعدادات.')),
      );
      Navigator.pop(context);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم رفض إذن الموقع.')),
        );
        Navigator.pop(context);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('يرجى تفعيل إذن الموقع من إعدادات التطبيق.')),
      );
      Navigator.pop(context);
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    currentLocation = LatLng(position.latitude, position.longitude);
    isLoadingLocation = false;

    if (widget.latitude != null && widget.longitude != null) {
      await _fetchRoute();
    }

    setState(() {});
  }

  Future<void> _fetchRoute() async {
    final start = '${currentLocation!.longitude},${currentLocation!.latitude}';
    final end = '${widget.longitude},${widget.latitude}';

    final url = Uri.parse(
      'http://router.project-osrm.org/route/v1/driving/$start;$end?geometries=geojson',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final geometry = data['routes'][0]['geometry']['coordinates'] as List;
      routePoints =
          geometry.map((coord) => LatLng(coord[1], coord[0])).toList();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل في تحميل المسار.')),
      );
    }
  }

  void _openInGoogleMaps() {
    final lat = widget.latitude;
    final lng = widget.longitude;
    final uri = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng');
    launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.latitude == null || widget.longitude == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("الخريطة")),
        body: const Center(child: Text('لا توجد إحداثيات متاحة لهذا البلاغ')),
      );
    }

    final reportLocation = LatLng(widget.latitude!, widget.longitude!);

    return  Scaffold(
  floatingActionButton: FloatingActionButton.extended(
    onPressed: _openInGoogleMaps,
    icon: const Icon(Icons.navigation),
    label: const Text('افتح في Google Maps'),
    backgroundColor: const Color(0xFF725DFE),
  ),
  body: isLoadingLocation
      ? const Center(child: CircularProgressIndicator())
      : Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: reportLocation,
                initialZoom: 15,
                interactionOptions: const InteractionOptions(
                  enableScrollWheel: true,
                  flags: InteractiveFlag.all,
                ),
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
                if (routePoints.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: routePoints,
                        strokeWidth: 4,
                        color: Colors.blue,
                      ),
                    ],
                  ),
              ],
            ),
            Positioned(
              top: 40,
              right: 16,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: Colors.white,
                onPressed: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_forward, color: Colors.black),
              ),
            ),
          ],
        ),
);

  }
}
