import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:otp_auth/provider/auth_provider.dart';
import 'package:otp_auth/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final Completer<GoogleMapController> _googleMapController = Completer();
  Location _locationController = Location();
  static const LatLng _centerIIUM =
      LatLng(3.2503284083090898, 101.7345085386681);
  LatLng? _currentPosition = null;

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("IIUMap"),
        titleTextStyle: const TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          IconButton(
              onPressed: () async {
                ap.signOut().then(
                      (value) => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WelcomeScreen(),
                          ),
                          (route) => false),
                    );
              },
              icon: const Icon(Icons.logout),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.white),
              )),
        ],
      ),
      body: _currentPosition == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: _centerIIUM,
                zoom: 15.0,
              ),
              markers: {
                Marker(
                  markerId: MarkerId("_userLocation"),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueAzure),
                  position: _currentPosition!,
                ),
              },
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {
                if (!_googleMapController.isCompleted) {
                  _googleMapController.complete(controller);
                }
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: "Search for a place",
        child: const Icon(Icons.search),
        backgroundColor: Colors.blue.shade50,
        foregroundColor: Colors.blue,
        shape: CircleBorder(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.blue.shade50,
        unselectedItemColor: Colors.blue.shade900,
        showUnselectedLabels: false,
        selectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: "LiveTracker",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "History",
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Future<void> _cameraToCurrentPosition(LatLng position) async {
    final GoogleMapController controller = await _googleMapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: position,
          zoom: 15.0,
        ),
      ),
    );
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentPosition =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          _cameraToCurrentPosition(_currentPosition!);
        });
      }
    });
  }
}
