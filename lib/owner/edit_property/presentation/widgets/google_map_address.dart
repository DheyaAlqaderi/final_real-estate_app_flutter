import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_real_estate/core/constant/app_constants.dart';
import 'package:smart_real_estate/core/helper/local_data/shared_pref.dart';
import 'package:smart_real_estate/owner/edit_property/domain/update_address_repository_by_id.dart';


class GoogleMapAddress extends StatefulWidget {
   GoogleMapAddress({super.key, required this.lat, required this.lon, required this.lineOnePass, required this.lineTwoPass, required this.addressId});

  double? lat;
  double? lon;
  String? lineOnePass;
  String? lineTwoPass;
  int? addressId;

  @override
  State<GoogleMapAddress> createState() => _GoogleMapAddressState();
}

class _GoogleMapAddressState extends State<GoogleMapAddress> {


  Marker? _markers;
  LatLng? _currentLatLng;
  late GoogleMapController _mapController;

  TextEditingController lineOne = TextEditingController();
  TextEditingController lineTwo = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentLatLng = LatLng(widget.lat!, widget.lon!);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      changeMapMode(_mapController);
    });

    if(widget.lineOnePass!.isNotEmpty){
      lineOne.text = widget.lineOnePass!;
    }

    if(widget.lineTwoPass!.isNotEmpty){
      lineTwo.text = widget.lineTwoPass!;
    }


  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _currentLatLng!,
              zoom: 7,
            ),
            markers: _markers != null ? {_markers!} : {},
            onCameraMove: _onCameraMove,
          ),

          Positioned(
            top: 40,
            right: 16,
            child: InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Theme.of(context).cardColor,
                ),
                child: const Center(
                  child: Icon(Icons.arrow_back),
                ),
              ),
            ),
          ),

          Positioned(
            top: 100.0,
            left: 16.0,
            right: 16.0,
            child: Column(
              children: [
                TextField(
                  controller: lineOne,
                  decoration: InputDecoration(
                    labelText: 'عنوان أول',
                    filled: true,
                    hintText: 'مثلاً خلف الجامعه اللبنانية بجوار بهارت ياسين خلف مطعم القلعه',
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                TextField(
                  controller: lineTwo,
                  decoration: InputDecoration(
                    labelText: 'عنوان ثاني',
                    filled: true,
                    hintText: 'مثلاً خلف الجامعه اللبنانية بجوار بهارت ياسين خلف مطعم القلعه',
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),



          Positioned(
            bottom: 10,
            right: 10,
            left: 10,
            child: Column(
              children: [
                Text("${_currentLatLng!.longitude} - ${_currentLatLng!.latitude}"),
                InkWell(
                  onTap: () async {
                    // if(lineOne.text.)
                    //
                    await SharedPrefManager.saveData(AppConstants.editLineOneAddress, lineOne.text.toString());
                    await SharedPrefManager.saveData(AppConstants.editLineTwoAddress, lineTwo.text.toString());
                    await SharedPrefManager.saveData(AppConstants.editLatAddress, _currentLatLng!.latitude.toString());
                    await SharedPrefManager.saveData(AppConstants.editLineTwoAddress, _currentLatLng!.longitude.toString());

                    setState(() {
                      isLoading = true;
                    });
                    await UpdateAddressById.update(addressId: widget.addressId! , body: {
                      "line1":lineOne.text,
                      "line2": lineTwo.text,
                      "longitude": _currentLatLng!.longitude.toString(),
                      "latitude": _currentLatLng!.latitude.toString()
                    });
                    setState(() {
                      isLoading = false;
                    });

                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      height: 70,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Theme.of(context).cardColor
                      ),
                      child: Center(
                        child: isLoading
                          ?const CircularProgressIndicator()
                          :const Text("تأكيد"),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }


  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _updateMarkerPosition(_currentLatLng!);
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _currentLatLng = position.target;
      _updateMarkerPosition(_currentLatLng!);
    });
  }

  void _updateMarkerPosition(LatLng position) {
    _markers = Marker(
      markerId: MarkerId('current_marker'),
      position: position,
      draggable: true,
      onDragEnd: (newPosition) {
        setState(() {
          _currentLatLng = newPosition;
          print('Marker moved to: Latitude: ${newPosition.latitude}, Longitude: ${newPosition.longitude}');
        });
      },
      onTap: () {
        print('Marker tapped at: Latitude: ${position.latitude}, Longitude: ${position.longitude}');
      },
    );
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
