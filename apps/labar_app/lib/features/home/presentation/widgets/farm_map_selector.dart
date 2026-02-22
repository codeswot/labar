import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:maps_toolkit/maps_toolkit.dart' as mt;
import 'package:ui_library/ui_library.dart';

class FarmMapSelector extends StatefulWidget {
  final List<ll.LatLng> initialPoints;
  const FarmMapSelector({super.key, this.initialPoints = const []});

  @override
  State<FarmMapSelector> createState() => _FarmMapSelectorState();
}

class _FarmMapSelectorState extends State<FarmMapSelector> {
  late List<ll.LatLng> _points;
  double _calculatedHectares = 0.0;

  @override
  void initState() {
    super.initState();
    _points = List.from(widget.initialPoints);
    _calculateArea();
  }

  void _calculateArea() {
    if (_points.length < 3) {
      setState(() {
        _calculatedHectares = 0.0;
      });
      return;
    }
    final toolkitPoints =
        _points.map((p) => mt.LatLng(p.latitude, p.longitude)).toList();
    final areaSqMeters = mt.SphericalUtil.computeArea(toolkitPoints);
    setState(() {
      _calculatedHectares = areaSqMeters / 10000.0;
    });
  }

  void _handleTap(TapPosition tapPosition, ll.LatLng point) {
    setState(() {
      _points.add(point);
    });
    _calculateArea();
  }

  void _undo() {
    if (_points.isNotEmpty) {
      setState(() {
        _points.removeLast();
      });
      _calculateArea();
    }
  }

  void _clear() {
    setState(() {
      _points.clear();
    });
    _calculateArea();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trace Farm Area'),
        actions: [
          TextButton(
            onPressed: _points.length >= 3
                ? () => Navigator.of(context)
                    .pop({'area': _calculatedHectares, 'points': _points})
                : null,
            child: Text(
              'Confirm',
              style: TextStyle(
                color: _points.length >= 3
                    ? context.moonColors?.piccolo
                    : context.moonColors?.trunks,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: _points.isNotEmpty
                  ? _points.first
                  : const ll.LatLng(9.0820, 8.6753), // Nigeria roughly
              initialZoom: 6,
              onTap: _handleTap,
              interactionOptions:
                  const InteractionOptions(flags: InteractiveFlag.all),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.codeswot.labar_app',
              ),
              PolygonLayer(
                polygons: [
                  if (_points.length >= 3)
                    Polygon(
                      points: _points,
                      color: Colors.purple.withValues(alpha: 0.3),
                      borderColor: Colors.purple,
                      borderStrokeWidth: 2,
                      isFilled: true,
                    ),
                ],
              ),
              MarkerLayer(
                markers: _points
                    .map((p) => Marker(
                          point: p,
                          width: 12,
                          height: 12,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.moonColors?.gohan ?? Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Farm Size: ${_calculatedHectares.toStringAsFixed(2)} Hectares',
                    style: context.moonTypography?.heading.text16,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AppButton.outlined(
                        label: const Text('Undo Last'),
                        onTap: _points.isNotEmpty ? _undo : null,
                        isFullWidth: false,
                      ),
                      AppButton.outlined(
                        label: const Text('Clear All'),
                        onTap: _points.isNotEmpty ? _clear : null,
                        isFullWidth: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
