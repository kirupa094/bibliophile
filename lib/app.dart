import 'package:bibliophile/screen/Login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bibliophile App',
      theme: ThemeData(
          backgroundColor: Colors.white,
          fontFamily: GoogleFonts.poppins().fontFamily),
      debugShowCheckedModeBanner: false,
      builder: (context, child) => ResponsiveWrapper.builder(child,
          maxWidth: 1200,
          minWidth: 480,
          defaultScale: true,
          breakpoints: const [
            ResponsiveBreakpoint.resize(480, name: MOBILE),
            ResponsiveBreakpoint.autoScale(800, name: TABLET),
            // ResponsiveBreakpoint.resize(1000, name: DESKTOP),
            // ResponsiveBreakpoint.autoScale(2460, name: '4K'),
          ]),
      home: const LoginScreen(),
    );
  }
}
