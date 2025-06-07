import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
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
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    if (widget.latitude == null || widget.longitude == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("الخريطة")),
        body: const Center(child: Text('لا توجد إحداثيات متاحة لهذا البلاغ')),
      );
    }

    final reportLocation = LatLng(widget.latitude!, widget.longitude!);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "openGoogleMaps",
        onPressed: _openInGoogleMaps,
        icon: const Icon(Icons.navigation),
        label: const Text('افتح في Google Maps'),
        backgroundColor: const Color(0xFF725DFE),
      ),
      body: Stack(
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
                    child: const Icon(Icons.location_on,
                        color: Colors.red, size: 40),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 40,
            right: 16,
            child: FloatingActionButton(
              heroTag: "backButton",
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

  void _openInGoogleMaps() {
    final lat = widget.latitude;
    final lng = widget.longitude;
    final uri = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng');
    launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
