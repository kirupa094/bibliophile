import 'package:bibliophile/screen/Profile/posted_posts.dart';
import 'package:bibliophile/screen/Profile/saved_posts.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: const BoxDecoration(color: Colors.white),
            padding: const EdgeInsets.only(left: 2),
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/logo.png'),
                        fit: BoxFit.fitWidth),
                  ),
                  width: 60,
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  'Bibliophile',
                  style: TextStyle(
                      letterSpacing: 1,
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 15,
            ),
            Container(
              margin: const EdgeInsets.only(left: 16),
              child: Row(
                children: <Widget>[
                  const CircleAvatar(
                    radius: 45,
                    backgroundImage: NetworkImage(
                        'https://as1.ftcdn.net/v2/jpg/03/46/83/96/1000_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg'),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      Text('Your Name',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      Text('Your Description', style: TextStyle(fontSize: 15)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            DefaultTabController(
              length: 2,
              child: Column(
                children: <Widget>[
                  const TabBar(
                      padding: EdgeInsets.all(0),
                      unselectedLabelColor: Colors.black,
                      labelColor: Color.fromARGB(255, 101, 88, 245),
                      indicatorColor: Color.fromARGB(255, 101, 88, 245),
                      indicatorPadding: EdgeInsets.all(0.0),
                      indicatorWeight: 2,
                      labelPadding: EdgeInsets.all(0),
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      unselectedLabelStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      tabs: [
                        Tab(text: "Posted Posts"),
                        Tab(text: "Saved Posts"),
                      ]),
                  const SizedBox(
                    height: 20,
                  ),
                  SingleChildScrollView(
                    child: SizedBox(
                      //Add this to give height
                      height: MediaQuery.of(context).size.height - 350,
                      child: const TabBarView(children: [
                        PostedPosts(),
                        SavedPosts(),
                      ]),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
