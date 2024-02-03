import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFFBF6F0),
      appBar: AppBar(
        title: Text("History",
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
              .where('customer_id', isEqualTo: user!.uid)
              .where('finished', isEqualTo: 'finish')
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
                        SizedBox(
                          width: screen.width * 0.7,
                          height: screen.height * 0.15,
                          child: Text("detail : \n${data['details']}",
                              style: GoogleFonts.chewy(
                                  textStyle: const TextStyle(
                                      color: Color(0xFF000000),
                                      decoration: TextDecoration.none,
                                      fontSize: 16))),
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
