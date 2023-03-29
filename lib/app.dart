import 'package:bibliophile/bloc/provider.dart';
import 'package:bibliophile/screen/Home/home.dart';
import 'package:bibliophile/screen/Home/intro_screen.dart';
import 'package:bibliophile/screen/Login/login_screen.dart';
import 'package:bibliophile/widgets/bottom_navigation_bar_menu.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        title: 'Bibliophile App',
        theme: ThemeData(
            backgroundColor: Colors.white,
            fontFamily: GoogleFonts.inter().fontFamily),
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
        home: const NavigatorScreen(),
      ),
    );
  }
}

class NavigatorScreen extends StatelessWidget {
  const NavigatorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    return StreamBuilder(
        stream: bloc?.initDataConfig,
        builder: (context, AsyncSnapshot<InitData> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data?.token != '') {
              bloc!.refreshToken(context);
              return const BottomNavigationBarMenu();
            } else {
              return const LoginScreen();
            }
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 101, 88, 245),
                ),
              ),
            );
          }
        });
  }
}