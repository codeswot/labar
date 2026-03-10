import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:ui_library/ui_library.dart';

class LocationPicker extends StatefulWidget {
  final double? initialLat;
  final double? initialLng;

  const LocationPicker({
    super.key,
    this.initialLat,
    this.initialLng,
  });

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isSearching = false;
  bool _showSearchResults = false;
  Timer? _searchDebounce;
  ll.LatLng? _selectedPoint;

  @override
  void initState() {
    super.initState();
    if (widget.initialLat != null && widget.initialLng != null) {
      _selectedPoint = ll.LatLng(widget.initialLat!, widget.initialLng!);
    }
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
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
      final url = Uri.parse('https://nominatim.openstreetmap.org/search')
          .replace(queryParameters: {
        'format': 'json',
        'q': query,
        'countrycodes': 'ng',
      });
      final response = await http.get(url, headers: {
        'User-Agent': 'LabarAdmin/1.0',
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
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
      }
    }
  }

  void _moveToLocation(double lat, double lon) {
    _mapController.move(ll.LatLng(lat, lon), 15);
    setState(() {
      _showSearchResults = false;
      _searchResults = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    ll.LatLng initialCenter = _selectedPoint ?? const ll.LatLng(9.0820, 8.6753);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Location'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, _selectedPoint),
            child: const Text('Confirm', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: initialCenter,
              initialZoom: _selectedPoint != null ? 15 : 6,
              onTap: (tapPosition, point) {
                setState(() {
                  _selectedPoint = point;
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.codeswot.labar_admin',
              ),
              if (_selectedPoint != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selectedPoint!,
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
                    ),
                  ],
                ),
            ],
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Column(
              children: [
                MoonTextInput(
                  controller: _searchController,
                  hintText: 'Search for a place...',
                  leading: _isSearching
                      ? const MoonCircularLoader(
                          circularLoaderSize: MoonCircularLoaderSize.x2s)
                      : const Icon(Icons.search),
                  onChanged: (val) {
                    _searchDebounce?.cancel();
                    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
                      _searchLocation(val);
                    });
                  },
                ),
                if (_showSearchResults && _searchResults.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: context.moonColors?.gohan,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                    ),
                    constraints: const BoxConstraints(maxHeight: 250),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _searchResults.length,
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
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: context.moonColors?.gohan,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                ),
                child: Text(
                  _selectedPoint != null
                      ? 'Selected: ${_selectedPoint!.latitude.toStringAsFixed(6)}, ${_selectedPoint!.longitude.toStringAsFixed(6)}'
                      : 'Tap on map to pick a location',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
