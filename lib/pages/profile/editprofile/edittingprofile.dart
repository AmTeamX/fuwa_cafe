import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fuwa_cafe/api/storage_services.dart';
import 'package:fuwa_cafe/pages/homepage/homepage.dart';
import 'package:google_fonts/google_fonts.dart';

class EdittingProfile extends StatefulWidget {
  const EdittingProfile({super.key});

  @override
  State<EdittingProfile> createState() => _EdittingProfileState();
}

class _EdittingProfileState extends State<EdittingProfile> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController email = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;

  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFFBF6F0),
      body: SingleChildScrollView(
        child: SizedBox(
          width: screen.width,
          height: screen.height,
          child: Column(children: [
            Container(
              margin: const EdgeInsets.only(bottom: 32),
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
                    "Edit profile",
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
            SizedBox(
                width: screen.width * 0.8,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Name",
                        style: GoogleFonts.chewy(
                            textStyle: const TextStyle(
                                color: Color(0xFF6C5F57),
                                decoration: TextDecoration.none,
                                fontSize: 22)),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.only(left: 12, right: 12),
                        width: screen.width * 0.8,
                        decoration: const BoxDecoration(
                            color: Color(0xFFCEB09D),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          controller: name,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                      ),
                      Text("phone number",
                          style: GoogleFonts.chewy(
                              textStyle: const TextStyle(
                                  color: Color(0xFF6C5F57),
                                  decoration: TextDecoration.none,
                                  fontSize: 22))),
                      Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.only(left: 12, right: 12),
                        width: screen.width * 0.8,
                        decoration: const BoxDecoration(
                            color: Color(0xFFCEB09D),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          controller: phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                        ),
                      ),
                      Text("email",
                          style: GoogleFonts.chewy(
                              textStyle: const TextStyle(
                                  color: Color(0xFF6C5F57),
                                  decoration: TextDecoration.none,
                                  fontSize: 22))),
                      Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.only(left: 12, right: 12),
                        width: screen.width * 0.8,
                        decoration: const BoxDecoration(
                            color: Color(0xFFCEB09D),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          controller: email,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                )),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCAAF9F)),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _loading = true;
                  });
                  BuildContext dialogContext = context;

                  String nName =
                      name.text == "" ? user!.displayName! : name.text;
                  String nEmail = name.text == "" ? user!.email! : email.text;

                  var getPhone = await FirebaseFirestore.instance
                      .collection('costomer')
                      .doc(user!.uid)
                      .get();

                  var oldPhone = getPhone.data();
                  String nPhone =
                      name.text == "" ? oldPhone!['phone_number'] : phone.text;
                  bool isSave =
                      await StorageServices().updateData(nName, nPhone, nEmail);
                  setState(() {
                    _loading = false;
                  });
                  if (!isSave) {
                    // ignore: use_build_context_synchronously
                    await showDialog(
                        context: dialogContext,
                        builder: (BuildContext dialogContext) {
                          return AlertDialog(
                            title: const Text('Something was wrong!'),
                            content: const Text("please try again"),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Try Again'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        });
                  } else {
                    // ignore: use_build_context_synchronously
                    await showDialog(
                        context: dialogContext,
                        builder: (BuildContext dialogContext) {
                          return AlertDialog(
                            title: const Text('Save Data'),
                            content: const Text("Go to home page"),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Ok'),
                                onPressed: () {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute<void>(
                                          builder: (BuildContext context) =>
                                              const HomePage()),
                                      ModalRoute.withName('/'));
                                },
                              ),
                            ],
                          );
                        });
                  }
                }
              },
              child: _loading
                  ? const CircularProgressIndicator()
                  : Text('Save',
                      style: GoogleFonts.chewy(
                          textStyle: const TextStyle(
                              color: Color(0xFF6C5F57),
                              decoration: TextDecoration.none,
                              fontSize: 22))),
            ),
          ]),
        ),
      ),
    );
  }
}
