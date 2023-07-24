// ignore_for_file: depend_on_referenced_packages

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter_geofire/flutter_geofire.dart';
// import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
// import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
// import 'package:latlong2/latlong.dart';
import 'package:latlong2/latlong.dart' as LatLng;
// import 'package:latlng/latlng.dart';
// import 'package:latlng2/latlng.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final mapController = MapController();

  @override
  void initState() {
    super.initState();
    determineuserposition();
  }

  // Future<bool> _handleLocationPermission() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text(
  //             'Location services are disabled. Please enable the services')));
  //     return false;
  //   }
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text('Location permissions are denied')));
  //       return false;
  //     }
  //   }
  //   if (permission == LocationPermission.deniedForever) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text(
  //             'Location permissions are permanently denied, we cannot request permissions.')));
  //     return false;
  //   }
  //   return true;
  // }

  late Position? positionstate = null;
  bool isloading = true;

  determineuserposition() async {
    // Future<bool> permission = _handleLocationPermission();
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("service disabled");
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      // return await Geolocator.getCurrentPosition();
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("error");
      }
    } else if (permission == LocationPermission.deniedForever) {
      return Future.error("Forever Error");
    }

    // Map<String, dynamic> response =
    //     await Geofire.getLocation("AsH28LWk8MXfwRLfVxgx");

    Position position = await Geolocator.getCurrentPosition();
    print(position.latitude);
    print(position.longitude);
    setState(() {
      positionstate = position;
      isloading = false;
    });
    // return position;
  }

  // void _incrementCounter() {
  //   setState(() {
  //     // This call to setState tells the Flutter framework that something has
  //     // changed in this State, which causes it to rerun the build method below
  //     // so that the display can reflect the updated values. If we changed
  //     // _counter without calling setState(), then the build method would not be
  //     // called again, and so nothing would appear to happen.
  //     _counter++;
  //   });
  // }
  // MapController controller = MapController(
  //   initPosition: GeoPoint(latitude: 14.599512, longitude: 120.984222),
  //   areaLimit: const BoundingBox.world(),
  //   // areaLimit: BoundingBox(
  //   //   east: 10.4922941,
  //   //   north: 47.8084648,
  //   //   south: 45.817995,
  //   //   west: 5.9559113,
  //   // ),
  // );
//   late Position position;
//   void fetchCurrentLocation() async{
//  //calling the api
//     var currentLocation = await _locationService.currentLocation;

//     //setState will update the values in real time
//     setState(() {

//       markerPoint = currentLocation

//     });
// }
//
  // setofficelocation() async {
  //   position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   print(position.longitude); //Output: 80.24599079
  //   print(position.latitude); //Output: 29.6593457
  //   setState(() {});

  //   // String long = position.longitude.toString();
  //   // String lat = position.latitude.toString();
  // }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: FlutterMap(
                      mapController: mapController,
                      options: MapOptions(
                        center: LatLng.LatLng(
                            positionstate!.latitude, positionstate!.longitude),
                        zoom: 15,
                      ),
                      // nonRotatedChildren: [
                      //   RichAttributionWidget(
                      //     attributions: [
                      //       TextSourceAttribution(
                      //         'OpenStreetMap contributors',
                      //         onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
                      //       ),
                      //     ],
                      //   ),
                      // ],
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.app',
                        ),
                        CircleLayer(
                          circles: [
                            CircleMarker(
                                color: Colors.blue.withOpacity(0.4),
                                // 16.78253808695626, 96.14371874064832
                                point: LatLng.LatLng(positionstate!.latitude,
                                    positionstate!.longitude),
                                radius: 50,
                                useRadiusInMeter: true)
                          ],
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                                // point: LatLng.LatLng(
                                //     16.871092611083455, 96.14015323353861),
                                point: LatLng.LatLng(positionstate!.latitude,
                                    positionstate!.longitude),
                                builder: (context) => FlutterLogo())
                          ],
                        )
                      ],
                    )),
                // Container(
                //   width: MediaQuery.of(context).size.width,
                //   height: MediaQuery.of(context).size.height * 0.4,
                //   child: FlutterMap(
                //     mapController: mapController,
                //     options: MapOptions(
                //       center: LatLng(16.78264770515267, 96.14366483323874),
                //       zoom: 9.2,
                //     ),
                //     children: [],
                //     nonRotatedChildren: [],
                //   ),
                // )
                // GestureDetector(
                //   onTap: setofficelocation,
                //   child: Text("where is my office"),
                // )
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Position position = await determineuserposition();
          print(position.latitude);
          print(position.longitude);
          mapController.move(
              LatLng.LatLng(position.latitude, position.longitude), 15);
        },
      ),
    );
  }
}
