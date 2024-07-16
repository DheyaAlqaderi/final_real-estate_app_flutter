import "dart:convert";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:get/get.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";
import "package:smart_real_estate/core/constant/app_constants.dart";
import "package:smart_real_estate/core/helper/local_data/shared_pref.dart";
import "package:smart_real_estate/features/client/home/widgets/stand_property_widget.dart";
import "package:smart_real_estate/features/client/property_details/presentation/pages/property_details_screen.dart";

import "../../../home/domain/manager/property_home_cubit/property_home_cubit.dart";
import "../../../home/domain/manager/property_home_cubit/property_home_state.dart";



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


class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;
  final Map<String, Marker> _markers = {};
  bool _isLoaded = false;
  List<Map<String, dynamic>> data = [];

  void _fetchData() async {
    final cubit = BlocProvider.of<PropertyHomeCubit>(context);
    final state = cubit.state;
    if (state is SuccessPropertyHomeState) {
      var data1 = state.propertyModel.results;
      if (data1 != null) {
        setState(() {
          data.clear();
          data1.asMap().forEach((i, address) {
            data.add({
              'id': address.id.toString(),
              'position': LatLng(address.address!['latitude'], address.address!['longitude']),
              'price': address.price,
              'propertyModel': state.propertyModel,
              'index': i
            });
          });
        });

        WidgetsBinding.instance.addPostFrameCallback((_) => _onBuildCompleted(data));
      }
    }

    // Listen to future state changes
    cubit.stream.listen((state) {
      if (state is SuccessPropertyHomeState) {
        var data1 = state.propertyModel.results;
        if (data1 != null) {
          setState(() {
            data.clear();
            data1.asMap().forEach((i, address) {
              data.add({
                'id': address.id.toString(),
                'position': LatLng(address.address!['latitude'], address.address!['longitude']),
                'price': address.price,
                'propertyModel': state.propertyModel,
                'index': i
              });
            });
          });

          WidgetsBinding.instance.addPostFrameCallback((_) => _onBuildCompleted(data));
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PropertyHomeCubit, PropertyHomeState>(
        builder: (context, state){
          if(state is LoadingPropertyHomeState){
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if(state is SuccessPropertyHomeState){
            return Scaffold(
                body: Stack(
                  children: [
                    buildContainerMap(),
                    buildPositionedBackIcon(),
                    buildPositionedSearchBar(),
                  ],
                ),
              );
          } else if(state is ErrorPropertyHomeState){
            return ErrorWidget("error");
          } else{
            return const SizedBox();
          }
        }
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
          child: const Center(
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

  Future<void> _onBuildCompleted(var data) async {
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
        onTap: () {
          showBottomSheet(context, double.parse(data['price']), data['propertyModel'], data['index']);
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

  void showBottomSheet(BuildContext context, double price, var propertyModel, int index) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StandPropertyWidget(propertyModel: propertyModel, index: index, onTap: () async {

          final userId = await SharedPrefManager.getData(AppConstants.userId);
          final token = await SharedPrefManager.getData(AppConstants.token);

          Get.to(()=> PropertyDetailsScreen(id: int.parse(userId!), token: token!));


        });
      },
    );
  }
}