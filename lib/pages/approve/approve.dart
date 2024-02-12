import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fuwa_cafe/api/storage_services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ApprovePage extends StatefulWidget {
  const ApprovePage({super.key});

  @override
  State<ApprovePage> createState() => _ApprovePageState();
}

class _ApprovePageState extends State<ApprovePage> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFFBF6F0),
      appBar: AppBar(
        title: Text("Notifications",
            style: GoogleFonts.chewy(
                textStyle: const TextStyle(
                    color: Color(0xFF000000),
                    decoration: TextDecoration.none,
                    fontSize: 22))),
        backgroundColor: const Color(0xFFFBF6F0),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("appointment")
              .where('finished', isEqualTo: 'unapproved')
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<Widget> promotionWidgets =
                  snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                var timeFormat = DateFormat('HH:mm a');
                var dateFormat = DateFormat('dd/MM/yyyy');
                DateTime srcDate = data['date'].toDate();
                DateTime srcTime = data['time'].toDate();
                final date = dateFormat.format(srcDate);
                final time = timeFormat.format(srcTime);
                return Center(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                        color: Color(0xFFD8BFAE),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    width: screen.width * 0.8,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Row(
                              children: [
                                data['service_id'] == '2Izg14qVSxXFnLpBwnb8'
                                    ? Text("Manicure",
                                        style: GoogleFonts.chewy(
                                            textStyle: const TextStyle(
                                                color: Color(0xFF000000),
                                                decoration: TextDecoration.none,
                                                fontSize: 20)))
                                    : Text("Eyelash extensions",
                                        style: GoogleFonts.chewy(
                                            textStyle: const TextStyle(
                                                color: Color(0xFF000000),
                                                decoration: TextDecoration.none,
                                                fontSize: 20)))
                              ],
                            )
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.calendar_month),
                              Text(":  $date",
                                  style: GoogleFonts.chewy(
                                      textStyle: const TextStyle(
                                          color: Color(0xFF000000),
                                          decoration: TextDecoration.none,
                                          fontSize: 20))),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.timer),
                              Text(":  $time",
                                  style: GoogleFonts.chewy(
                                      textStyle: const TextStyle(
                                          color: Color(0xFF000000),
                                          decoration: TextDecoration.none,
                                          fontSize: 20))),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.people),
                              Text(":  ${data['costomer_count']}",
                                  style: GoogleFonts.chewy(
                                      textStyle: const TextStyle(
                                          color: Color(0xFF000000),
                                          decoration: TextDecoration.none,
                                          fontSize: 20))),
                            ],
                          ),
                        ),
                        ExpansionTileCard(
                          baseColor: const Color(0xFFD8BFAE),
                          expandedColor: const Color(0xFFD8BFAE),
                          title: Text("Details",
                              style: GoogleFonts.chewy(
                                  textStyle: const TextStyle(
                                      color: Color(0xFF000000),
                                      decoration: TextDecoration.none,
                                      fontSize: 16))),
                          shadowColor: Colors.transparent,
                          children: <Widget>[
                            SizedBox(
                              width: screen.width * 0.7,
                              child: Text("${data['details']}",
                                  style: GoogleFonts.chewy(
                                      textStyle: const TextStyle(
                                          color: Color(0xFF000000),
                                          decoration: TextDecoration.none,
                                          fontSize: 16))),
                            ),
                            SizedBox(
                              width: screen.width * 0.7,
                              child: Text("Add-on: \n${data['addon']}",
                                  style: GoogleFonts.chewy(
                                      textStyle: const TextStyle(
                                          color: Color(0xFF000000),
                                          decoration: TextDecoration.none,
                                          fontSize: 16))),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFD9D9D9)),
                              onPressed: () async {
                                StorageServices()
                                    .setStatus(document.id, 'canceled');
                              },
                              child: Text('cancel',
                                  style: GoogleFonts.chewy(
                                      textStyle: const TextStyle(
                                          color: Color(0xFF000000),
                                          decoration: TextDecoration.none,
                                          fontSize: 22))),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFBF6F0)),
                              onPressed: () async {
                                StorageServices()
                                    .setStatus(document.id, 'approved');
                              },
                              child: Text('Approved',
                                  style: GoogleFonts.chewy(
                                      textStyle: const TextStyle(
                                          color: Color(0xFF000000),
                                          decoration: TextDecoration.none,
                                          fontSize: 22))),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList();

              return Column(
                children: promotionWidgets,
              );
            }
          },
        ),
      ),
    );
  }
}
