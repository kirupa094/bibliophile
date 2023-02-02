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
          body: Container(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                      child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                        'https://as1.ftcdn.net/v2/jpg/03/46/83/96/1000_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg'),
                  )),
                  Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Text('Your Name',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20))),
                      Padding(
                          padding: EdgeInsets.only(left: 25.0),
                          child: Text('Your Description',
                              style: TextStyle(fontSize: 15))),
                    ],
                  ),
                ],
              ),
            ],
          ))),
    );
  }
}
