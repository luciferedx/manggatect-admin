import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/admin_panel.dart';

class AllTreeLocationPage extends StatefulWidget {
  const AllTreeLocationPage({Key? key}) : super(key: key);

  @override
  _AllTreeLocationPageState createState() => _AllTreeLocationPageState();
}

class _AllTreeLocationPageState extends State<AllTreeLocationPage> {
  String selectedStage = 'stage-1'; // Default stage
  List<String> stages = ['stage-1', 'stage-2', 'stage-3', 'stage-4'];

  @override
  Widget build(BuildContext context) {
    return AdminPanel(
      body: Column(
        children: [
          // StreamBuilder for fetching tree locations
          Expanded(
            child: Stack(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('notes')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    // Filter locations by selected stage
                    final List<LatLng> locations =
                        snapshot.data!.docs.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return data['stage'] ==
                          selectedStage; // Filter by selected stage
                    }).map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return LatLng(
                        double.parse(data['latitude'].toString()),
                        double.parse(data['longitude'].toString()),
                      );
                    }).toList();

                    // Show a message if there are no locations for the selected stage
                    if (locations.isEmpty) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('No data available for $selectedStage.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      });
                    }

                    return FlutterMap(
                      options: MapOptions(
                        initialCenter:
                            locations.isNotEmpty ? locations[0] : LatLng(0, 0),
                        initialZoom: 20.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: ['a', 'b', 'c'],
                          userAgentPackageName: 'Manggatect',
                        ),
                        MarkerLayer(
                          markers: locations.map((location) {
                            return Marker(
                              point: location,
                              width: 50.0,
                              height: 50.0,
                              child: Image.asset(
                                'assets/images/tree_icon.png',
                                width: 40.0,
                                height: 40.0,
                              ),
                            );
                          }).toList(),
                        ),
                        RichAttributionWidget(
                          attributions: [
                            TextSourceAttribution(
                              'OpenStreetMap contributors',
                              onTap: () => launchUrl(Uri.parse(
                                  'https://www.openstreetmap.org/copyright')),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),

                // Dropdown button for selecting stages, positioned at the top-right corner
                Positioned(
                  top: 16.0,
                  right: 16.0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.yellowAccent,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: DropdownButton<String>(
                      value: selectedStage,
                      icon:
                          const Icon(Icons.arrow_downward, color: Colors.white),
                      elevation: 16,
                      style: const TextStyle(color: Colors.white),
                      dropdownColor: Colors.yellowAccent,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedStage = newValue!;
                        });
                      },
                      items:
                          stages.map<DropdownMenuItem<String>>((String stage) {
                        return DropdownMenuItem<String>(
                          value: stage,
                          child: Text(stage),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
