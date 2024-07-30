import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

void main() {
  runApp(const MyApp());
}

enum MarkerType { food, drinks, entertainment, music, toilet, firstAid }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xfffef9d9)),
          useMaterial3: true,
          fontFamily: "Kalnia"),
      home: const MyHomePage(title: 'Site Map | King\'s Affair 2024'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late AlignOnUpdate _alignPositionOnUpdate;
  late final StreamController<double?> _alignPositionStreamController;

  @override
  void initState() {
    super.initState();
    _alignPositionOnUpdate = AlignOnUpdate.always;
    _alignPositionStreamController = StreamController<double?>();
  }

  @override
  void dispose() {
    _alignPositionStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    // enum for marker types

    // marker coordinates record with popup info
    final Map<MarkerType, Map<LatLng, String>> markerInfo = {
      MarkerType.food: {
        const LatLng(52.2042762508856, 0.11653902843738247): 'Wokboy',
        const LatLng(52.20432343446432, 0.11651839163552703): 'Yubbayubba',
        const LatLng(52.204585991704846, 0.11647532923699676): 'Africfood',
        const LatLng(52.204612239197225, 0.1165752631610952): 'Orlene\'s',
        const LatLng(52.20461997868054, 0.11663554984857034): 'MacDaddy',
        const LatLng(52.20398733502235, 0.11720937298263986): 'Pizza',
        const LatLng(52.20398688307557, 0.1172939821261573): 'Vegan Bites',
        const LatLng(52.20420141174324, 0.11564018555668232): 'Luxury Bakes',
      },
      MarkerType.drinks: {
        const LatLng(52.20431349668968, 0.1166770201065541): 'Bar',
        const LatLng(52.203577528939654, 0.11709798970966837): 'Bar',
        const LatLng(52.203976103079235, 0.11658082632267833): 'Cocktails',
      },
      MarkerType.entertainment: {
        const LatLng(52.204505932701885, 0.11625639990441822): 'Ferris Wheel',
        const LatLng(52.20457274806383, 0.11689739192771494): 'Carousel',
        const LatLng(52.20389003477931, 0.11670687908844712): 'Silent Disco',
        const LatLng(52.203724027932644, 0.11695720157635148): 'Shisha',
        const LatLng(52.20369754322185, 0.11731848317160916): "Karaoke",
      },
      MarkerType.music: {
        // const LatLng(52.20412289536054, 0.11637913585336272): 'Main Stage',
        const LatLng(52.20334198400167, 0.11697623200289282): 'Bunker',
      },
      MarkerType.toilet: {
        // const LatLng(52.20456094517504, 0.1171314508745287): 'Toilets',
        const LatLng(52.203791281689206, 0.11730061301859251): 'Toilets',
      },
      MarkerType.firstAid: {
        const LatLng(52.20389559108938, 0.1172906831955011): 'First Aid',
        const LatLng(52.203968179753815, 0.11702522518169695): 'Welfare Point'
      },
    };

    // marker colors and icons
    // final Map<MarkerType,

    // marker colors
    final Map<MarkerType, Color> markerColors = {
      MarkerType.food: Colors.red,
      MarkerType.drinks: Colors.blue,
      MarkerType.entertainment: Colors.green,
      MarkerType.music: Colors.purple,
      MarkerType.toilet: Colors.brown,
      MarkerType.firstAid: Colors.orange,
    };

    // marker list
    // final List<Marker> markers = popupInfo.keys
    //     .map(
    //       (LatLng latLng) => Marker(
    //         width: 80.0,
    //         height: 80.0,
    //         point: latLng,
    //         child: GestureDetector(
    //           onTap: () => showModalBottomSheet<void>(
    //             context: context,
    //             builder: (BuildContext context) {
    //               return SizedBox(
    //                 height: 200,
    //                 child: Center(
    //                   child: Column(
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     mainAxisSize: MainAxisSize.min,
    //                     children: <Widget>[
    //                       Text(popupInfo[latLng] ?? ''),
    //                       ElevatedButton(
    //                         child: const Text('Close BottomSheet'),
    //                         onPressed: () => Navigator.pop(context),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               );
    //             },
    //           ),
    //           child: const Icon(
    //             Icons.location_on,
    //             size: 40.0,
    //             color: Colors.red,
    //           ),
    //         ),
    //       ),
    //     )
    //     .toList();

    final List<Marker> markers = markerInfo.entries
        .map(
          (MapEntry<MarkerType, Map<LatLng, String>> entry) =>
              entry.value.entries
                  .map(
                    (MapEntry<LatLng, String> marker) => Marker(
                      width: 80.0,
                      height: 80.0,
                      point: marker.key,
                      child: GestureDetector(
                        onTap: () => showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return SizedBox(
                              height: 200,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(marker.value),
                                    ElevatedButton(
                                      child: const Text('Close BottomSheet'),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        child: Icon(
                          Icons.location_on,
                          size: 40.0,
                          color: markerColors[entry.key],
                        ),
                      ),
                    ),
                  )
                  .toList(),
        )
        .expand((List<Marker> element) => element)
        .toList();

    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title, style: GoogleFonts.kalnia()),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: FlutterMap(
            options: MapOptions(
              initialCenter:
                  const LatLng(52.20430051719541, 0.11661901333656707),
              initialZoom: 19.0,
              maxZoom: 20.0,
              cameraConstraint: CameraConstraint.containCenter(
                  bounds: LatLngBounds(const LatLng(52.2048189, 0.1150632),
                      const LatLng(52.2035128, 0.1174941))),
              // interactionOptions: InteractionOptions(
              //     flags: InteractiveFlag.all & ~InteractiveFlag.rotate),
              onPositionChanged: (MapCamera camera, bool hasGesture) {
                if (hasGesture &&
                    _alignPositionOnUpdate != AlignOnUpdate.never) {
                  setState(
                    () => _alignPositionOnUpdate = AlignOnUpdate.never,
                  );
                }
              },
            ),
            children: [
              TileLayer(
                tileProvider: CancellableNetworkTileProvider(),
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              PolygonLayer(polygons: [
                Polygon(
                    points: [
                      const LatLng(52.2040226, 0.1162603),
                      const LatLng(52.2040518, 0.116584),
                      const LatLng(52.2041987, 0.1165479),
                      const LatLng(52.2041733, 0.116221)
                    ],
                    color: Colors.red.withOpacity(0.5),
                    label: "Main Stage",
                    labelPlacement: PolygonLabelPlacement.polylabel,
                    labelStyle: GoogleFonts.kalnia()),
                Polygon(
                    points: [
                      const LatLng(52.2045037, 0.1170742),
                      const LatLng(52.2045136, 0.1171868),
                      const LatLng(52.20465, 0.11716),
                      const LatLng(52.2046416, 0.1170462)
                    ],
                    color: Colors.blue.withOpacity(0.5),
                    label: "Toilets",
                    labelPlacement: PolygonLabelPlacement.polylabel),
                Polygon(
                    points: [
                      const LatLng(52.2043626, 0.1156598),
                      const LatLng(52.2043521, 0.1155141),
                      const LatLng(52.2042548, 0.1155335),
                      const LatLng(52.2042613, 0.1156795)
                    ],
                    color: Colors.blue.withOpacity(0.5),
                    label: "Stretch Tent",
                    labelPlacement: PolygonLabelPlacement.polylabel)
              ]),
              CircleLayer(circles: [
                CircleMarker(
                    point: const LatLng(52.2045707, 0.1168874),
                    radius: 6,
                    color: Colors.green.withOpacity(0.5),
                    useRadiusInMeter: true)
              ]),
              MarkerLayer(
                markers: markers,
              ),
              // PopupMarkerLayer(
              //   options: PopupMarkerLayerOptions(
              //     markers: [
              //       const Marker(
              //         width: 80.0,
              //         height: 80.0,
              //         point: LatLng(52.20430051719541, 0.11661901333656707),
              //         child: Icon(
              //           Icons.location_on,
              //           size: 40.0,
              //           color: Colors.red,
              //         ),
              //       )
              //     ],
              //     popupDisplayOptions: PopupDisplayOptions(
              //       animation: const PopupAnimation.fade(),
              //       builder: (_, Marker marker) => const Card(
              //         child: Padding(
              //           padding: EdgeInsets.all(8.0),
              //           child: Text('Hello, world!'),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              CurrentLocationLayer(
                alignPositionStream: _alignPositionStreamController.stream,
                alignPositionOnUpdate: _alignPositionOnUpdate,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: FloatingActionButton(
                    onPressed: () {
                      // Align the location marker to the center of the map widget
                      // on location update until user interact with the map.
                      setState(
                        () => _alignPositionOnUpdate = AlignOnUpdate.always,
                      );
                      // Align the location marker to the center of the map widget
                      // and don't change zoom level
                      _alignPositionStreamController.add(null);
                    },
                    child: const Icon(
                      Icons.my_location,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ]),
      ),
      bottomSheet: Container(
        color: Theme.of(context).colorScheme.surface,
        child: SizedBox(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: []
            ),
          ),
        ),
      ),
    );
  }
}
