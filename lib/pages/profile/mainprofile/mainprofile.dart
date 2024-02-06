// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fuwa_cafe/api/auth_service.dart';
import 'package:fuwa_cafe/api/storage_services.dart';
import 'package:fuwa_cafe/pages/first_page.dart';
import 'package:fuwa_cafe/pages/homepage/homepage.dart';
import 'package:fuwa_cafe/pages/profile/profile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user = FirebaseAuth.instance.currentUser;
  File? _imageFile;
  late Future<bool> _isAdminFuture;
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      // If an image is picked, set the state with the picked image file
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch the current user whenever the dependencies change
    user = FirebaseAuth.instance.currentUser;
  }

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
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Column(
            children: [
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()),
                          );
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
              SizedBox(
                height: screen.height * 0.05,
              ),
              GestureDetector(
                onTap: () async {
                  await _pickImage();
                  if (_imageFile != null) {
                    showDialog(
                      context: context,
                      barrierDismissible:
                          false, // Prevent user from dismissing the dialog
                      builder: (BuildContext context) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );
                    await StorageServices()
                        .uploadImageAndUpdateProfile(_imageFile!);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Profile()),
                    );
                  }
                },
                child: CircleAvatar(
                  radius: 60, // Adjust the radius as needed
                  backgroundImage: user!.photoURL!.isEmpty
                      ? const AssetImage(
                          'assets/profile_pic.png') // Placeholder image if URL is empty
                      : NetworkImage(user!.photoURL!)
                          as ImageProvider, // User's profile picture URL
                  // User's profile picture URL
                ),
              ),
              SizedBox(
                height: screen.height * 0.025,
              ),
              Text(
                user!.displayName!,
                style: GoogleFonts.chewy(
                    textStyle: const TextStyle(
                        fontSize: 28,
                        color: Color(0xFF000000),
                        decoration: TextDecoration.none)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          SizedBox(
            height: screen.height * 0.1,
          ),
          Expanded(
            child: Container(
              width: screen.width,
              padding: const EdgeInsets.only(top: 30, left: 8, right: 8),
              decoration: const BoxDecoration(
                  color: Color(0xFFAC8C77),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Column(
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(
                              0xFFFBF6F0)), // Set transparent background
                      shadowColor: MaterialStateProperty.all<Color>(
                          Colors.transparent), // Set transparent shadow color
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.zero), // Remove default padding
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              12), // Set the border radius
                        ),
                      ),
                    ),
                    child: Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, top: 12, bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Profile",
                              style: GoogleFonts.chewy(
                                  textStyle: const TextStyle(
                                      fontSize: 22,
                                      color: Color(0xFF6C5F57),
                                      decoration: TextDecoration.none)),
                              textAlign: TextAlign.center,
                            ),
                            const Icon(
                              Icons.keyboard_arrow_right,
                              color: Color(0xFF6C5F57),
                            )
                          ],
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditProfile()),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(
                              0xFFFBF6F0)), // Set transparent background
                      shadowColor: MaterialStateProperty.all<Color>(
                          Colors.transparent), // Set transparent shadow color
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.zero), // Remove default padding
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              12), // Set the border radius
                        ),
                      ),
                    ),
                    child: Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, top: 12, bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "History",
                              style: GoogleFonts.chewy(
                                  textStyle: const TextStyle(
                                      fontSize: 22,
                                      color: Color(0xFF6C5F57),
                                      decoration: TextDecoration.none)),
                              textAlign: TextAlign.center,
                            ),
                            const Icon(
                              Icons.keyboard_arrow_right,
                              color: Color(0xFF6C5F57),
                            )
                          ],
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const History()),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  FutureBuilder<bool>(
                    future: _isAdminFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container();
                      } else {
                        if (snapshot.hasError || snapshot.data == false) {
                          return Container();
                        } else {
                          return Column(
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty
                                      .all<Color>(const Color(
                                          0xFFFBF6F0)), // Set transparent background
                                  shadowColor: MaterialStateProperty.all<Color>(
                                      Colors
                                          .transparent), // Set transparent shadow color
                                  padding: MaterialStateProperty
                                      .all<EdgeInsetsGeometry>(EdgeInsets
                                          .zero), // Remove default padding
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          12), // Set the border radius
                                    ),
                                  ),
                                ),
                                child: Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        top: 12,
                                        bottom: 12),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "To do list",
                                          style: GoogleFonts.chewy(
                                              textStyle: const TextStyle(
                                                  fontSize: 22,
                                                  color: Color(0xFF6C5F57),
                                                  decoration:
                                                      TextDecoration.none)),
                                          textAlign: TextAlign.center,
                                        ),
                                        const Icon(
                                          Icons.keyboard_arrow_right,
                                          color: Color(0xFF6C5F57),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Todo()),
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                            ],
                          );
                        }
                      }
                    },
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(
                              0xFFFBF6F0)), // Set transparent background
                      shadowColor: MaterialStateProperty.all<Color>(
                          Colors.transparent), // Set transparent shadow color
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.zero), // Remove default padding
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              12), // Set the border radius
                        ),
                      ),
                    ),
                    child: Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, top: 12, bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Logout",
                              style: GoogleFonts.chewy(
                                  textStyle: const TextStyle(
                                      fontSize: 22,
                                      color: Color(0xFF6C5F57),
                                      decoration: TextDecoration.none)),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  const FirstPage()),
                          ModalRoute.withName('/'));
                    },
                  )
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
