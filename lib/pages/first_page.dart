import 'package:flutter/material.dart';
import 'package:fuwa_cafe/pages/login/login_page.dart';
import 'package:fuwa_cafe/pages/register/register_page.dart';
import 'package:google_fonts/google_fonts.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
          width: screen.width,
          height: screen.height,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/background.png"),
                  fit: BoxFit.cover)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Fuwa Fuwa\nnail cafe",
                style: GoogleFonts.chewy(
                    textStyle: const TextStyle(
                        color: Color(0xFF6C5F57),
                        decoration: TextDecoration.none,
                        fontSize: 48)),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: screen.height * 0.1,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCAAF9F)),
                child: Text(
                  "LOGIN",
                  style: GoogleFonts.chewy(
                      textStyle: const TextStyle(color: Color(0xFF6C5F57))),
                ),
              ),
              SizedBox(
                height: screen.height * 0.01,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCAAF9F)),
                child: Text(
                  "REGISTER",
                  style: GoogleFonts.chewy(
                      textStyle: const TextStyle(color: Color(0xFF6C5F57))),
                ),
              ),
            ],
          )),
    );
  }
}
