import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;
  Marker? _selectedMarker;
  LatLng? _selectedLocation;

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(6.9271, 79.8612), // Default to Colombo
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return;
    }
  }

  Future<void> _goToCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      LatLng userLocation = LatLng(position.latitude, position.longitude);

      setState(() {
        _selectedLocation = userLocation;
        _selectedMarker = Marker(
          markerId: const MarkerId('Nearby Services'),
          position: userLocation,
          infoWindow: const InfoWindow(title: 'Selected Location'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        );
      });

      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(userLocation, 16),
      );
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  void _onMapTap(LatLng tappedPoint) {
    setState(() {
      _selectedLocation = tappedPoint;
      _selectedMarker = Marker(
        markerId: const MarkerId('selected_location'),
        position: tappedPoint,
        infoWindow: const InfoWindow(title: 'Selected Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      );
    });
  }

  void _showNearbyLocations() {
    if (_selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a location first.')),
      );
      return;
    }

    // Mock data for nearby locations (replace with real data later)
    final nearbyLocations = [
      {
        'name': 'Colombo Garage & Auto Care',
        'address': '12 Baseline Road, Colombo 09',
        'phone': '+94112340123',
      },
      {
        'name': 'City Tyre House',
        'address': '245 Galle Road, Colombo 03',
        'phone': '+94112678901',
      },
      {
        'name': 'Lanka Auto Service Center',
        'address': '67 Kandy Road, Colombo 08',
        'phone': '+94112876543',
      },
      {
        'name': 'Super Tyres Colombo',
        'address': '22 Duplication Road, Colombo 04',
        'phone': '+94111234567',
      },
      {
        'name': 'Tech Garage Lanka',
        'address': '89 High Level Road, Colombo 05',
        'phone': '+94113456789',
      },
      {
        'name': 'Auto Fix Center',
        'address': '101 Horton Place, Colombo 07',
        'phone': null,
      },
      {
        'name': 'Quick Lube Service Station',
        'address': '32 Havelock Road, Colombo 05',
        'phone': '+94112223344',
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        maxChildSize: 0.7,
        minChildSize: 0.3,
        initialChildSize: 0.5,
        builder: (context, scrollController) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Nearby Service Locations',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.separated(
                controller: scrollController,
                itemCount: nearbyLocations.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final location = nearbyLocations[index];
                  return ListTile(
                    title: Text(location['name'] ?? ''),
                    subtitle: Text(location['address'] ?? ''),
                    trailing: location['phone'] != null
                        ? IconButton(
                            icon: const Icon(Icons.call),
                            onPressed: () async {
                              final Uri launchUri = Uri(
                                scheme: 'tel',
                                path: location['phone'],
                              );
                              if (await canLaunchUrl(launchUri)) {
                                await launchUrl(launchUri);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Cannot launch dialer')),
                                );
                              }
                            },
                          )
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Servicers'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (controller) {
              _mapController = controller;
            },
            markers: _selectedMarker != null ? {_selectedMarker!} : {},
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            onTap: _onMapTap,
          ),
          Positioned(
            bottom: 100,
            right: 16,
            child: FloatingActionButton(
              onPressed: _goToCurrentLocation,
              child: const Icon(Icons.my_location),
            ),
          ),
          Positioned(
            bottom: 30,
            right: 16,
            child: FloatingActionButton(
              onPressed: _showNearbyLocations,
              child: const Icon(Icons.place),
            ),
          ),
        ],
      ),
    );
  }
}
