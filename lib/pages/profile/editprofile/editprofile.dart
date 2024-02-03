import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fuwa_cafe/api/auth_service.dart';
import 'package:fuwa_cafe/pages/profile/editprofile/edittingprofile.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  User? user = FirebaseAuth.instance.currentUser;

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
        body: SizedBox(
            width: screen.width,
            height: screen.height,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Column(children: [
                Container(
                  width: screen.width,
                  height: screen.height * 0.15,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFBF6F0),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x40000000),
                        blurRadius: 4,
                        offset: Offset(0, 4), // Shadow position
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.keyboard_arrow_left)),
                      Text(
                        "Profile",
                        style: GoogleFonts.chewy(
                            textStyle: const TextStyle(
                                fontSize: 28,
                                color: Color(0xFF000000),
                                decoration: TextDecoration.none)),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ]),
              SizedBox(height: screen.height * 0.025),
              Container(
                margin: const EdgeInsets.only(
                    top: 12, bottom: 12, left: 20, right: 20),
                child: Row(
                  children: [
                    Text(
                      "Personal Information",
                      style: GoogleFonts.chewy(
                          textStyle: const TextStyle(
                              fontSize: 22,
                              color: Color(0xFF000000),
                              decoration: TextDecoration.none)),
                      textAlign: TextAlign.center,
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
                            return IconButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const EdittingProfile()),
                                  );
                                },
                                icon: const Icon(Icons.edit));
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
              FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('customer')
                    .doc(user!.uid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  }
                  if (!snapshot.hasData || snapshot.data == null) {
                    return const Text("No data available");
                  }
                  Map<String, dynamic> userData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  String userName = userData['name'];
                  String userEmail = userData['email'];
                  String userPhone = userData['phone_number'];
                  return Container(
                    padding: const EdgeInsets.only(
                        top: 12, bottom: 12, left: 18, right: 18),
                    width: screen.width,
                    decoration: const BoxDecoration(
                        color: Color(0xFFD8BFAE),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              top: 4, bottom: 4, left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Name",
                                style: GoogleFonts.chewy(
                                    textStyle: const TextStyle(
                                        fontSize: 18,
                                        color: Color(0xFF6C5F57),
                                        decoration: TextDecoration.none)),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                userName,
                                style: GoogleFonts.chewy(
                                    textStyle: const TextStyle(
                                        fontSize: 18,
                                        color: Color(0xFF6C5F57),
                                        decoration: TextDecoration.none)),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const Divider(color: Color(0xFFAC8C77)),
                        Container(
                          margin: const EdgeInsets.only(
                              top: 4, bottom: 4, left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Phone",
                                style: GoogleFonts.chewy(
                                    textStyle: const TextStyle(
                                        fontSize: 18,
                                        color: Color(0xFF6C5F57),
                                        decoration: TextDecoration.none)),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                userPhone,
                                style: GoogleFonts.chewy(
                                    textStyle: const TextStyle(
                                        fontSize: 18,
                                        color: Color(0xFF6C5F57),
                                        decoration: TextDecoration.none)),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const Divider(color: Color(0xFFAC8C77)),
                        Container(
                          margin: const EdgeInsets.only(
                              top: 4, bottom: 4, left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Email",
                                style: GoogleFonts.chewy(
                                    textStyle: const TextStyle(
                                        fontSize: 18,
                                        color: Color(0xFF6C5F57),
                                        decoration: TextDecoration.none)),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                userEmail,
                                style: GoogleFonts.chewy(
                                    textStyle: const TextStyle(
                                        fontSize: 18,
                                        color: Color(0xFF6C5F57),
                                        decoration: TextDecoration.none)),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            ])));
  }
}
