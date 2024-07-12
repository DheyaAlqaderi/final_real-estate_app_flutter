import "dart:convert";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";



class CustomeMarkerWidgit extends StatelessWidget {
  final double price;

  const CustomeMarkerWidgit({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Center(
        child: Text('\$$price', style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}

List<Map<String, dynamic>> data = [
  {
    'id': '1',
    'position': const LatLng(15.123456, 44.654321),
    'price': 123.45,
  },
  {
    'id': '2',
    'position': const LatLng(16.987654, 45.876543),
    'price': 678.90,
  },
  {
    'id': '3',
    'position': const LatLng(14.246810, 43.567890),
    'price': 987.65,
  },
  {
    'id': '4',
    'position': const LatLng(15.135792, 44.975318),
    'price': 543.21,
  },
  {
    'id': '5',
    'position': const LatLng(16.112233, 45.998877),
    'price': 1234.56,
  },
  {
    'id': '6',
    'position': const LatLng(14.131415, 43.161718),
    'price': 7890.12,
  },
  {
    'id': '7',
    'position': const LatLng(15.192837, 44.293801),
    'price': 6543.21,
  },
  {
    'id': '8',
    'position': const LatLng(16.987654, 45.123456),
    'price': 210.987,
  },
  {
    'id': '9',
    'position': const LatLng(14.567890, 43.987654),
    'price': 8765.432,
  },
  {
    'id': '10',
    'position': const LatLng(15.112233, 44.876543),
    'price': 9876.543,
  },
  {
    'id': '11',
    'position': const LatLng(16.223344, 45.765432),
    'price': 345.678,
  },
  {
    'id': '12',
    'position': const LatLng(14.334455, 43.654321),
    'price': 5678.901,
  },
  {
    'id': '13',
    'position': const LatLng(15.445566, 44.543210),
    'price': 12345.678,
  },
  {
    'id': '14',
    'position': const LatLng(16.556677, 45.432109),
    'price': 8765.4321,
  },
  {
    'id': '15',
    'position': const LatLng(14.667788, 43.321098),
    'price': 98765.4321,
  },
  {
    'id': '16',
    'position': const LatLng(15.778899, 44.210987),
    'price': 123456.789,
  },
  {
    'id': '17',
    'position': const LatLng(16.889900, 45.109876),
    'price': 98765.43210,
  },
  {
    'id': '18',
    'position': const LatLng(14.998877, 43.098765),
    'price': 87654.3210,
  },
  {
    'id': '19',
    'position': const LatLng(15.876543, 44.987654),
    'price': 987654.3210,
  },
  {
    'id': '20',
    'position': const LatLng(16.765432, 45.876543),
    'price': 1234567.890,
  },
];

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;
  final Map<String, Marker> _markers = {};
  bool _isLoaded = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _onBuildCompleted());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          buildContainerMap(),
          buildPositionedBackIcon(),
          buildPositionedSearchBar(),
        ],
      ),
    );
  }

  Positioned buildPositionedSearchBar() {
    return Positioned(
      top: 100,
      right: 0,
      left: 0,
      child: Padding(
        padding: const EdgeInsets.all(11.0),
        child: Container(
          width: 327,
          height: 70,
          decoration: ShapeDecoration(
            color: Colors.white.withOpacity(0.800000011920929),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            shadows: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              )
            ],
          ),
          child: Center(
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
                hintText: "Search ...",
              ),
            ),
          ),
        ),
      ),
    );
  }

  Positioned buildPositionedBackIcon() {
    return Positioned(
      top: 35,
      right: 19,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        borderRadius: BorderRadius.circular(25),
        child: Container(
          width: 56,
          height: 56,
          decoration: ShapeDecoration(
            color: Colors.white.withOpacity(0.800000011920929),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            shadows: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              )
            ],
          ),
          child: Icon(Icons.arrow_forward),
        ),
      ),
    );
  }

  Container buildContainerMap() {
    return Container(
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController c) {
          _controller = c;
          changeMapMode(_controller!);
        },
        markers: _markers.values.toSet(),
      ),
    );
  }

  Future<void> _onBuildCompleted() async {
    data.forEach((value) {
      Marker marker = _generateMarkersFromWidgets(value);
      _markers[marker.markerId.value] = marker;
    });
    setState(() {
      _isLoaded = true;
    });
  }

  Marker _generateMarkersFromWidgets(Map<String, dynamic> data) {
    return Marker(
      markerId: MarkerId(data['id']),
      position: data['position'],
      infoWindow: InfoWindow(
        title: '\$${data['price']}',
        snippet: 'Rating: 4.5',
        onTap: () {
          showBottomSheet(context, data['price'], 4.5);
        },
      ),
    );
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(14.5678337, 43.2232772),
    zoom: 7,
  );

  void changeMapMode(GoogleMapController mapController) {
    getJsonFile("assets/map_style.json")
        .then((value) => setMapStyle(value, mapController));
  }

  void setMapStyle(String mapStyle, GoogleMapController mapController) {
    mapController.setMapStyle(mapStyle);
  }

  Future<String> getJsonFile(String path) async {
    ByteData byte = await rootBundle.load(path);
    var list = byte.buffer.asUint8List(byte.offsetInBytes, byte.lengthInBytes);
    return utf8.decode(list);
  }

  void showBottomSheet(BuildContext context, double price, double rating) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          width: 200,
          color: Colors.red,
          child: Center(
            child: Text('Price: \$${price}\nRating: $rating'),
          ),
        );
      },
    );
  }
}