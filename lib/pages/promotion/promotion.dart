import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fuwa_cafe/pages/addpromotion/add_promotion.dart';
import 'package:fuwa_cafe/pages/editpromotion/editpromotion.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../api/auth_service.dart';

class PromotionPage extends StatefulWidget {
  const PromotionPage({Key? key}) : super(key: key);

  @override
  State<PromotionPage> createState() => _PromotionPageState();
}

class _PromotionPageState extends State<PromotionPage> {
  late Future<bool> _isAdminFuture;

  @override
  void initState() {
    super.initState();
    _isAdminFuture = AuthService().checkIsAdmin();
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFFBF6F0),
      appBar: AppBar(
        title: Text("Promotions",
            style: GoogleFonts.chewy(
                textStyle: const TextStyle(
                    color: Color(0xFF000000),
                    decoration: TextDecoration.none,
                    fontSize: 22))),
        backgroundColor: const Color(0xFFFBF6F0),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection("promotion").snapshots(),
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
                            Text(data['name'],
                                style: GoogleFonts.chewy(
                                    textStyle: const TextStyle(
                                        color: Color(0xFF000000),
                                        decoration: TextDecoration.none,
                                        fontSize: 22))),
                          ],
                        ),
                        SizedBox(
                          width: screen.width * 0.7,
                          height: screen.height * 0.15,
                          child: Text("detail : ${data['detail']}",
                              style: GoogleFonts.chewy(
                                  textStyle: const TextStyle(
                                      color: Color(0xFF000000),
                                      decoration: TextDecoration.none,
                                      fontSize: 16))),
                        ),
                        FutureBuilder<bool>(
                          future: _isAdminFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container();
                            } else {
                              if (snapshot.hasError || snapshot.data == false) {
                                return Container();
                              } else {
                                return Container(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFFD9D9D9)),
                                        onPressed: () async {
                                          await FirebaseFirestore.instance
                                              .collection('promotion')
                                              .doc(document.id)
                                              .delete();
                                        },
                                        child: Text('Delete',
                                            style: GoogleFonts.chewy(
                                                textStyle: const TextStyle(
                                                    color: Color(0xFF000000),
                                                    decoration:
                                                        TextDecoration.none,
                                                    fontSize: 22))),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFFFBF6F0)),
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditPromotion(
                                                        promoId: document.id)),
                                          );
                                        },
                                        child: Text('Edit',
                                            style: GoogleFonts.chewy(
                                                textStyle: const TextStyle(
                                                    color: Color(0xFF000000),
                                                    decoration:
                                                        TextDecoration.none,
                                                    fontSize: 22))),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }
                          },
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
      floatingActionButton: FutureBuilder<bool>(
        future: _isAdminFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else {
            if (snapshot.hasError || snapshot.data == false) {
              return Container();
            } else {
              return FloatingActionButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddPromotion()),
                  );
                },
                child: const Icon(Icons.add),
              );
            }
          }
        },
      ),
    );
  }
}
