import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fuwa_cafe/api/storage_services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Todo extends StatefulWidget {
  const Todo({super.key});

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFFBF6F0),
      appBar: AppBar(
        title: Text("Todo",
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
              .where('finished', isEqualTo: 'approved')
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
                                                fontSize: 28)))
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
                        SizedBox(
                          width: screen.width * 0.7,
                          child: Text("detail : \n${data['details']}",
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFBF6F0)),
                              onPressed: () async {
                                StorageServices()
                                    .setStatus(document.id, 'finished');
                              },
                              child: Text('Finish',
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
