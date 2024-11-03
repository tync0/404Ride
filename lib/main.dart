import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uber/core/extension.dart';
import 'package:uber/widget/draggable_widget.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Google Maps Demo',
      home: PolylineMap(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PolylineMap extends StatefulWidget {
  const PolylineMap({super.key});

  @override
  State<PolylineMap> createState() => _PolylineMapState();
}

class _PolylineMapState extends State<PolylineMap> {
  late GoogleMapController _controller;
  final Set<Marker> _markers = {};
  Polyline? _polyline;
  Dio dio = Dio();
  LatLng _initialPosition = const LatLng(
    40.4380325,
    49.84451,
  ); // Default position

  final TextEditingController _init = TextEditingController();
  final TextEditingController _final = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setUserLocation();
  }

  Future<void> _setUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are not enabled');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enable location services.')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permission denied');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Location permission denied. Please grant permission.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permission permanently denied');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Location permission permanently denied. Please allow from settings.')),
      );
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _initialPosition = LatLng(position.latitude, position.longitude);
        _init.text = 'My Location';

        _markers.add(
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: _initialPosition,
            infoWindow: const InfoWindow(title: 'My Location'),
          ),
        );
      });

      _controller.animateCamera(
        CameraUpdate.newLatLngZoom(_initialPosition, 15.0),
      );
    } catch (e) {
      print('Error getting location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Error getting location. Please try again.')),
      );
    }
  }

  Future<LatLng> getCoordinatesFromAddress(String address) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$apiKey';
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'OK') {
          final location = data['results'][0]['geometry']['location'];
          return LatLng(location['lat'], location['lng']);
        } else {
          throw Exception('Geocode API error: ${data['status']}');
        }
      } else {
        throw Exception('HTTP request error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Request error: $e');
    }
  }

  Future<void> _getRouteCoordinates(
      LatLng start, LatLng destination, List<LatLng> waypoints) async {
    String waypointsString = waypoints.isNotEmpty
        ? '&waypoints=${waypoints.map((e) => '${e.latitude},${e.longitude}').join('|')}'
        : '';

    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${destination.latitude},${destination.longitude}$waypointsString&key=$apiKey';

    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'OK') {
          List<LatLng> polylineCoordinates = [];
          String encodedPolyline =
              data['routes'][0]['overview_polyline']['points'];
          polylineCoordinates = _decodePolyline(encodedPolyline);

          setState(() {
            _polyline = Polyline(
              polylineId: const PolylineId('route'),
              points: polylineCoordinates,
              color: Colors.blue,
              width: 5,
            );
          });

          _controller.animateCamera(CameraUpdate.newLatLngBounds(
            LatLngBounds(
              southwest: LatLng(
                polylineCoordinates
                    .map((e) => e.latitude)
                    .reduce((a, b) => a < b ? a : b),
                polylineCoordinates
                    .map((e) => e.longitude)
                    .reduce((a, b) => a < b ? a : b),
              ),
              northeast: LatLng(
                polylineCoordinates
                    .map((e) => e.latitude)
                    .reduce((a, b) => a > b ? a : b),
                polylineCoordinates
                    .map((e) => e.longitude)
                    .reduce((a, b) => a > b ? a : b),
              ),
            ),
            50.0,
          ));

          // Add markers for start and destination
          _markers.add(Marker(
            markerId: const MarkerId('startLocation'),
            position: start,
            infoWindow: const InfoWindow(title: 'Start Location'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
          ));
          _markers.add(Marker(
            markerId: const MarkerId('destinationLocation'),
            position: destination,
            infoWindow: const InfoWindow(title: 'Destination'),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ));
        } else {
          throw Exception('Directions API error: ${data['status']}');
        }
      } else {
        throw Exception('HTTP request error: ${response.statusCode}');
      }
    } catch (e) {
      print('Request error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error showing route: $e')),
      );
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b;
      int shift = 0;
      int result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      polyline.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return polyline;
  }

  Future<void> _showRoute() async {
    try {
      LatLng startLatLng = await getCoordinatesFromAddress(_init.text);
      LatLng destinationLatLng = await getCoordinatesFromAddress(_final.text);
      await _getRouteCoordinates(startLatLng, destinationLatLng, []);
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error showing route: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              zoomControlsEnabled: false,
              zoomGesturesEnabled: true,
              mapType: MapType.terrain,
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 15,
              ),
              onMapCreated: (controller) {
                _controller = controller;
              },
              markers: _markers,
              polylines: _polyline != null ? {_polyline!} : {},
            ),
            Positioned(
              right: 10,
              top: 350,
              child: InkWell(
                onTap: _showRoute,
                child: Container(
                  height: 45,
                  width: 45,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: SvgPicture.asset('assets/map.svg'),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: DraggableWidget(
                startController: _init,
                destinationController: _final,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
