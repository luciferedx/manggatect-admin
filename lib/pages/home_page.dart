import 'package:adminmangga/archive.dart';
import 'package:adminmangga/pages/TreeLocationPage.dart';
import 'package:adminmangga/pages/qrcodegeneratorpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:adminmangga/services/firestore.dart';
import '../services/admin_panel.dart';
import 'package:intl/intl.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final FirestoreService firestoreService = FirestoreService();
  Map<String, dynamic>? selectedmango_tree;

  @override
  Widget build(BuildContext context) {
    return AdminPanel(
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Data",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('mango_tree')
                            .where('isArchived', isEqualTo: false)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<DocumentSnapshot> mango_treeList =
                                snapshot.data!.docs;

                            return LayoutBuilder(
                              builder: (context, constraints) {
                                return ListView(
                                  children: [
                                    Table(
                                      border:
                                          TableBorder.all(color: Colors.grey),
                                      columnWidths: const {
                                        0: FlexColumnWidth(0.2),
                                        1: FlexColumnWidth(1),
                                        2: FlexColumnWidth(1),
                                      },
                                      children: [
                                        const TableRow(
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 20, 116, 82),
                                          ),
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                "Stage",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                "Date Uploaded",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                "Actions",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        ...mango_treeList.map((document) {
                                          Map<String, dynamic> data = document
                                              .data() as Map<String, dynamic>;
                                          String docID = document.id;
                                          Timestamp timestamp =
                                              data['timestamp'];
                                          data['docID'] = docID;

                                          return TableRow(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                    data['stage']?.toString() ??
                                                        'N/A'),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  DateFormat(
                                                          'EEEE, MMMM dd, yyyy h:mm a')
                                                      .format(
                                                          timestamp.toDate()),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    const SizedBox(width: 25),
                                                    ElevatedButton.icon(
                                                      onPressed: () {
                                                        setState(() {
                                                          selectedmango_tree =
                                                              data;
                                                        });
                                                      },
                                                      icon: const Icon(
                                                        Icons.preview,
                                                        color: Colors.white,
                                                      ),
                                                      label: const Text(
                                                        'View',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.orange,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 16.0),
                                                    ElevatedButton.icon(
                                                      onPressed: () {
                                                        showArchiveDialog(
                                                            context, docID);
                                                      },
                                                      icon: const Icon(
                                                        Icons.archive,
                                                        color: Colors.white,
                                                      ),
                                                      label: const Text(
                                                        'Archive',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.blue,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            return const Center(child: Text("No Data..."));
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // View panel
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10.0,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: selectedmango_tree == null
                    ? const Center(
                        child: Text(
                          "Select data to View details.",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "View Details",
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          const Divider(
                              color: Colors.blueAccent, thickness: 2.0),
                          const SizedBox(height: 8.0),
                          selectedmango_tree!['imageUrl'] != null
                              ? Image.network(
                                  selectedmango_tree!['imageUrl'] ?? '',
                                  width: 300,
                                  height: 300,
                                  fit: BoxFit.cover,
                                )
                              : const Center(
                                  child: Text(
                                    "No image available",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                          const SizedBox(height: 8.0),
                          selectedmango_tree!['stageImageUrl'] != null
                              ? Image.network(
                                  selectedmango_tree!['stageImageUrl'] ?? '',
                                  width: 300,
                                  height: 300,
                                  fit: BoxFit.cover,
                                )
                              : const Center(
                                  child: Text(
                                    "No image available",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                          const SizedBox(height: 8.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "DocID: ${selectedmango_tree!['docID'] ?? 'N/A'}",
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                "Longitude: ${selectedmango_tree!['longitude'] ?? 'N/A'}",
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                "Latitude: ${selectedmango_tree!['latitude'] ?? 'N/A'}",
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                "Stage: ${selectedmango_tree!['stage'] ?? 'N/A'}",
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),

                          // QR Code button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  String docID = selectedmango_tree?['docID'];
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          QRCodeGeneratorPage(docID: docID),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Generate QR Code'),
                              ),
                              const SizedBox(height: 16.0),
                              // Location button
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TreeLocationPage(
                                        latitude: double.tryParse(
                                                selectedmango_tree![
                                                        'latitude'] ??
                                                    '0.0') ??
                                            0.0,
                                        longitude: double.tryParse(
                                                selectedmango_tree![
                                                        'longitude'] ??
                                                    '0.0') ??
                                            0.0,
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Get Location'),
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
