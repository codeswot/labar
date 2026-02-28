import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:maps_toolkit/maps_toolkit.dart' as mt;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
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
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isSearching = false;
  bool _showSearchResults = false;
  Timer? _searchDebounce;
  ll.LatLng? _currentPosition;
  StreamSubscription<Position>? _positionSubscription;

  @override
  void initState() {
    super.initState();
    _points = List.from(widget.initialPoints);
    _calculateArea();
    _initLocationTracking();
  }

  Future<void> _initLocationTracking() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        final position = await Geolocator.getCurrentPosition();
        setState(() {
          _currentPosition = ll.LatLng(position.latitude, position.longitude);
        });

        _positionSubscription = Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 5,
          ),
        ).listen((Position position) {
          if (mounted) {
            setState(() {
              _currentPosition =
                  ll.LatLng(position.latitude, position.longitude);
            });
          }
        });
      }
    } catch (e) {
      print('Location tracking error: $e');
    }
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _positionSubscription?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchLocation(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _showSearchResults = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _showSearchResults = true;
    });

    try {
      final url = Uri.parse(
          'https://nominatim.openstreetmap.org/search?format=json&q=$query&countrycodes=ng');
      final response = await http.get(url, headers: {
        'User-Agent': 'LabarApp/1.0',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _searchResults = data;
        });
      }
    } catch (e) {
      print('Search error: $e');
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  void _moveToLocation(double lat, double lon) {
    _mapController.move(ll.LatLng(lat, lon), 18);
    setState(() {
      _showSearchResults = false;
      _searchController.clear();
      _searchResults = [];
    });
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
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _points.isNotEmpty
                  ? _points.first
                  : (_currentPosition ??
                      const ll.LatLng(10.5105, 7.4165)), // Kaduna/Nigeria
              initialZoom: 18,
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
                markers: [
                  if (_currentPosition != null)
                    Marker(
                      point: _currentPosition!,
                      width: 24,
                      height: 24,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Center(
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ..._points.map((p) => Marker(
                        point: p,
                        width: 12,
                        height: 12,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )),
                ],
              ),
            ],
          ),
          // Center Indicator
          IgnorePointer(
            child: Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: 24), // Offset for pin tip
                child: Icon(
                  Icons.add_location_alt_rounded,
                  color: context.moonColors?.piccolo ?? Colors.blue,
                  size: 32,
                ),
              ),
            ),
          ),
          // Search Bar
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Column(
              children: [
                MoonTextInput(
                  controller: _searchController,
                  hintText: 'Search location...',
                  leading: _isSearching
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: MoonCircularLoader(),
                        )
                      : const Icon(Icons.search),
                  trailing: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _searchController.clear();
                            _searchLocation('');
                          },
                        )
                      : null,
                  onChanged: (val) {
                    _searchDebounce?.cancel();
                    _searchDebounce =
                        Timer(const Duration(milliseconds: 500), () {
                      if (val.length > 2) {
                        _searchLocation(val);
                      } else {
                        setState(() {
                          _searchResults = [];
                          _showSearchResults = false;
                        });
                      }
                    });
                  },
                ),
                if (_showSearchResults && _searchResults.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: context.moonColors?.gohan,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                        )
                      ],
                    ),
                    constraints: const BoxConstraints(maxHeight: 300),
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: _searchResults.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final res = _searchResults[index];
                        return ListTile(
                          title: Text(res['display_name']),
                          onTap: () {
                            final lat = double.parse(res['lat']);
                            final lon = double.parse(res['lon']);
                            _moveToLocation(lat, lon);
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          // My Location Button
          Positioned(
            right: 16,
            bottom: 150,
            child: FloatingActionButton(
              heroTag: 'my_location_btn',
              mini: true,
              backgroundColor: context.moonColors?.gohan,
              child:
                  Icon(Icons.my_location, color: context.moonColors?.piccolo),
              onPressed: () async {
                try {
                  LocationPermission permission =
                      await Geolocator.checkPermission();
                  if (permission == LocationPermission.denied) {
                    permission = await Geolocator.requestPermission();
                  }
                  if (permission == LocationPermission.always ||
                      permission == LocationPermission.whileInUse) {
                    final position = await Geolocator.getCurrentPosition();
                    _moveToLocation(position.latitude, position.longitude);
                  } else {
                    MoonToast.show(context,
                        label: const Text('Location permission denied'));
                  }
                } catch (e) {
                  print('Location error: $e');
                }
              },
            ),
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
                  AppButton.filled(
                    label: const Text('Add Point at Center'),
                    leading: const Icon(Icons.add_circle_outline),
                    onTap: () {
                      final center = _mapController.camera.center;
                      setState(() {
                        _points.add(center);
                      });
                      _calculateArea();
                    },
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
