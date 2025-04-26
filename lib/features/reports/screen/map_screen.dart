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
  bool isLoadingLocation = true; // للتحكم في اللودينج لما بيطلب الإذن

  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم رفض إذن الموقع.')),
        );
        Navigator.pop(context); // نرجعه بدري بدل ما يفضل واقف
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى تفعيل إذن الموقع من الإعدادات.')),
      );
      Navigator.pop(context);
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
      isLoadingLocation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.reportLat == null || widget.reportLng == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("الخريطة")),
        body: const Center(child: Text('لا توجد إحداثيات متاحة لهذا البلاغ')),
      );
    }

    final reportLocation = LatLng(widget.reportLat!, widget.reportLng!);

    return Scaffold(
      appBar: AppBar(title: const Text("الخريطة")),
      body: isLoadingLocation
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: reportLocation,
                initialZoom: 15,
                maxZoom: 18,
                minZoom: 5,
                interactionOptions: const InteractionOptions(
                  enableScrollWheel: true,
                  flags: InteractiveFlag.all,
                ),
                // تحديد حدود مصر كمثال بسيط
                cameraConstraint: CameraConstraint.contain(
                  bounds: LatLngBounds(
                    const LatLng(22.0, 25.0), // جنوب مصر
                    const LatLng(31.5, 35.0), // شمال مصر
                  ),
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
