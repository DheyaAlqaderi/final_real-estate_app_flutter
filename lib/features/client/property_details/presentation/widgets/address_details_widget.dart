import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_real_estate/core/utils/styles.dart';

class AddressDetailsWidget extends StatefulWidget {
  const AddressDetailsWidget({super.key, required this.addressLine, /*required this.lat, required this.long*/});

  final String addressLine;
  // final double lat;
  // final double long;

  @override
  State<AddressDetailsWidget> createState() => _AddressDetailsWidgetState();
}

class _AddressDetailsWidgetState extends State<AddressDetailsWidget> {
  late GoogleMapController _controller;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      changeMapMode(_controller);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Locales.string(context, "location"), style: fontMediumBold,),
          const SizedBox(height: 7.0,),
          Row(
            children: [
              Container(
                height: 50.0,
                width: 50.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Theme.of(context).cardColor
                ),
                child: const Center(
                  child: Icon(Icons.location_on_outlined,),
                ),
              ),
              const SizedBox(width: 10.0,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.addressLine, style: fontMedium,),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10.0,),
          SizedBox(
            height: 235,
            width: double.infinity,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: const Color(0xAFDCD8D8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: GoogleMap(
                mapType: MapType.normal,
                onMapCreated: _onMapCreated,
                initialCameraPosition: const CameraPosition(
                  target: LatLng(14.5678337, 43.2232772),
                  zoom: 7,
                ),
                markers: _markers,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    _addMarker(const LatLng(14.5678337, 43.2232772), 'Marker Title', 'Marker Description');

  }

  void _addMarker(LatLng position, String title, String snippet) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(position.toString()),
          position: position,
          infoWindow: InfoWindow(
            title: title,
            snippet: snippet,
          ),
        ),
      );
    });
  }

  // This is the function to load custom map style JSON
  void changeMapMode(GoogleMapController mapController) {
    getJsonFile("assets/map/map_style.json")
        .then((value) => setMapStyle(value, mapController));
  }

  // Helper function
  void setMapStyle(String mapStyle, GoogleMapController mapController) {
    mapController.setMapStyle(mapStyle);
  }

  // Helper function
  Future<String> getJsonFile(String path) async {
    ByteData byte = await rootBundle.load(path);
    var list = byte.buffer.asUint8List(byte.offsetInBytes, byte.lengthInBytes);
    return utf8.decode(list);
  }
}

