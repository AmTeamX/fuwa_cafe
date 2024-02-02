// ignore_for_file: use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fuwa_cafe/pages/promotion/promotion.dart';
import 'package:fuwa_cafe/pages/reserve/eyelash.dart';
import 'package:fuwa_cafe/pages/reserve/manicure.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFFBF6F0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.only(
                  left: 40, right: 35, top: 20, bottom: 20),
              width: screen.width,
              height: screen.height * 0.15,
              decoration: const BoxDecoration(
                color: Color(0xFFFBF6F0),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x40000000),
                    blurRadius: 4,
                    offset: Offset(0, 4), // Shadow position
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  user?.displayName != null
                      ? Text(user!.displayName!,
                          style: GoogleFonts.chewy(
                              textStyle: const TextStyle(
                                  color: Color(0xFF000000),
                                  decoration: TextDecoration.none,
                                  fontSize: 28)))
                      : Text("Error while loading name...",
                          style: GoogleFonts.chewy(
                              textStyle: const TextStyle(
                                  color: Color(0xFF000000),
                                  decoration: TextDecoration.none,
                                  fontSize: 18))),
                  Container(
                    decoration:
                        const BoxDecoration(borderRadius: BorderRadius.zero),
                    child: Image.asset("assets/profile_pic.png"),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
              width: screen.width * 0.8,
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("coming...",
                          style: GoogleFonts.chewy(
                              textStyle: const TextStyle(
                                  color: Color(0xFF000000),
                                  decoration: TextDecoration.none,
                                  fontSize: 28))),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: screen.width * 0.8,
                    height: screen.height * 0.15,
                    decoration: const BoxDecoration(
                        color: Color(0xFFE0CCBE),
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PromotionPage()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      margin: const EdgeInsets.only(top: 20),
                      width: screen.width * 0.8,
                      height: screen.height * 0.075,
                      decoration: const BoxDecoration(
                          color: Color(0xFFE0CCBE),
                          borderRadius: BorderRadius.all(Radius.circular(25))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Promotion",
                              style: GoogleFonts.chewy(
                                  textStyle: const TextStyle(
                                      color: Color(0xFF000000),
                                      decoration: TextDecoration.none,
                                      fontSize: 20))),
                          const Icon(
                            Icons.arrow_right,
                            size: 44,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 60),
              padding: const EdgeInsets.all(30),
              width: screen.width,
              height: screen.height * 0.4,
              decoration: const BoxDecoration(
                color: Color(0xFFAC8C77),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
                boxShadow: [
                  BoxShadow(
                      color: Color(0x80000000),
                      offset: Offset(0, 4),
                      blurRadius: 4,
                      spreadRadius: 2,
                      inset: true),
                ],
              ),
              child: Column(children: [
                Row(
                  children: [
                    Text("Services",
                        style: GoogleFonts.chewy(
                            textStyle: const TextStyle(
                                color: Color(0xFFFFFFFF),
                                decoration: TextDecoration.none,
                                fontSize: 30))),
                  ],
                ),
                SizedBox(
                  height: screen.height * 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Manicure()),
                        );
                      },
                      child: Container(
                        width: screen.width * 0.3,
                        height: screen.height * 0.17,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x40000000),
                              blurRadius: 2,
                              offset: Offset(0, 5), // Shadow position
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/nail_logo.png"),
                            Text("Manicure",
                                style: GoogleFonts.chewy(
                                    textStyle: const TextStyle(
                                        color: Color(0xFF000000),
                                        decoration: TextDecoration.none,
                                        fontSize: 18))),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Eyelash()),
                        );
                      },
                      child: Container(
                        width: screen.width * 0.3,
                        height: screen.height * 0.17,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x40000000),
                              blurRadius: 2,
                              offset: Offset(0, 5), // Shadow position
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/Hat_logo.png"),
                            Text("Eyelash\nextensions",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.chewy(
                                    textStyle: const TextStyle(
                                  color: Color(0xFF000000),
                                  decoration: TextDecoration.none,
                                  fontSize: 18,
                                ))),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ]),
            )
          ],
        ),
      ),
    );
  }
}
