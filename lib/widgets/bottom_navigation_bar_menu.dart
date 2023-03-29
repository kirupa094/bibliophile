import 'package:bibliophile/bloc/provider.dart';
import 'package:bibliophile/screen/Home/home.dart';
import 'package:bibliophile/screen/Profile/profile.dart';
import 'package:bibliophile/screen/Shelf/shelf.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavigationBarMenu extends StatefulWidget {
  const BottomNavigationBarMenu({Key? key}) : super(key: key);

  @override
  State<BottomNavigationBarMenu> createState() =>
      _BottomNavigationBarMenuState();
}

class _BottomNavigationBarMenuState extends State<BottomNavigationBarMenu> {
  int _currentIndex = 0;

  final List<Widget> _children = [const Home(), const Shelf(), const Profile()];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    return StreamBuilder<int>(
        stream: bloc!.currentTabIndex,
        initialData: 0,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          return Scaffold(
            body: _children[snapshot.data ?? 0],
            bottomNavigationBar: BottomNavigationBar(
              elevation: 4,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              type: BottomNavigationBarType.fixed,
              unselectedItemColor: Colors.black,
              selectedItemColor: const Color.fromARGB(255, 101, 88, 245),
              showUnselectedLabels: true,
              onTap: (value) {
                bloc.changeCurrentTabIndex(value);
              },
              currentIndex: snapshot.data ?? 0,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.book),
                  label: "Shelf",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: "Profile",
                ),
              ],
            ),
          );
        });
  }
}
