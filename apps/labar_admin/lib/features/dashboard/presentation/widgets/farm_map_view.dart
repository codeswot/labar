import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:ui_library/ui_library.dart';

class FarmMapView extends StatefulWidget {
  final dynamic app;
  const FarmMapView({super.key, required this.app});

  @override
  State<FarmMapView> createState() => _FarmMapViewState();
}

class _FarmMapViewState extends State<FarmMapView> {
  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  List<ll.LatLng> _extractPolygon() {
    final raw = widget.app['farm_polygon'];
    if (raw == null) return [];
    List<dynamic> points;
    if (raw is String) {
      try {
        points = (json.decode(raw) as List);
      } catch (_) {
        return [];
      }
    } else if (raw is List) {
      points = raw;
    } else {
      return [];
    }
    return points
        .map((p) {
          final map = p as Map<String, dynamic>;
          final lat = (map['lat'] as num?)?.toDouble();
          final lng = (map['lng'] as num?)?.toDouble();
          if (lat == null || lng == null) return null;
          return ll.LatLng(lat, lng);
        })
        .whereType<ll.LatLng>()
        .toList();
  }

  ll.LatLng? _centerPoint(List<ll.LatLng> pts) {
    if (pts.isEmpty) return null;
    final lat = pts.map((p) => p.latitude).reduce((a, b) => a + b) / pts.length;
    final lng =
        pts.map((p) => p.longitude).reduce((a, b) => a + b) / pts.length;
    return ll.LatLng(lat, lng);
  }

  @override
  Widget build(BuildContext context) {
    final polygonPoints = _extractPolygon();
    final lat = (widget.app['latitude'] as num?)?.toDouble();
    final lng = (widget.app['longitude'] as num?)?.toDouble();
    final farmSize = widget.app['farm_size']?.toString();

    ll.LatLng center = const ll.LatLng(9.0820, 8.6753); // Nigeria fallback
    double zoom = 5;

    if (polygonPoints.isNotEmpty) {
      center = _centerPoint(polygonPoints)!;
      zoom = 14;
    } else if (lat != null && lng != null) {
      center = ll.LatLng(lat, lng);
      zoom = 14;
    }

    final hasMapData = polygonPoints.isNotEmpty || (lat != null && lng != null);

    if (!hasMapData) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: context.moonColors?.goku,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(child: Text('No farm location data available')),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        height: 260,
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: center,
                initialZoom: zoom,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.codeswot.labar_admin',
                ),
                if (polygonPoints.length >= 3)
                  PolygonLayer(
                    polygons: [
                      Polygon(
                        points: polygonPoints,
                        color: Colors.purple.withOpacity(0.3),
                        borderColor: Colors.purple,
                        borderStrokeWidth: 2.5,
                      ),
                    ],
                  ),
                if (lat != null && lng != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: ll.LatLng(lat, lng),
                        width: 32,
                        height: 32,
                        child: const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            if (farmSize != null)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.straighten_rounded,
                          size: 14, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        '$farmSize ha',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
