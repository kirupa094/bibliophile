import 'package:bibliophile/bloc/provider.dart';
import 'package:bibliophile/screen/Profile/posted_posts.dart';
import 'package:bibliophile/screen/Profile/saved_posts.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Container customContainer(String url, String name) {
    return Container(
      margin: const EdgeInsets.only(left: 16),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 45,
            backgroundImage: NetworkImage(url),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    final userName = bloc!.getUserName();
    final userImage = bloc.getUserImage();
    return SafeArea(
      child: StreamBuilder<bool>(
        stream: bloc.isShowProfilePage,
        initialData: true,
        builder: (context, snapshot) {
          if (snapshot.data == true) {
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                automaticallyImplyLeading: false,
                flexibleSpace: Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  padding: const EdgeInsets.only(left: 2),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                  customContainer(userImage, userName),
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
                            labelColor: Colors.blue,
                            indicatorColor: Colors.blue,
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
                              Tab(text: "Your Posts"),
                              Tab(text: "Saved Posts"),
                            ]),
                        const SizedBox(
                          height: 20,
                        ),
                        SingleChildScrollView(
                          child: Container(
                            color: Colors.grey[300],
                            height: MediaQuery.of(context).size.height - 350,
                            child: TabBarView(children: [
                              PostedPosts(userId: bloc.getUserId()),
                              const SavedPosts(),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                automaticallyImplyLeading: false,
                flexibleSpace: Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  padding: const EdgeInsets.only(left: 2),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          bloc.changeIsShowProfilePage(true);
                        },
                      )
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
                  StreamBuilder<Map<String, dynamic>>(
                    stream: bloc.userProfile,
                    builder: (context, snapshot1) {
                      if (snapshot1.hasData && snapshot1.data!.isNotEmpty) {
                        return customContainer(snapshot1.data!['photoURL'],
                            snapshot1.data!['username']);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Flexible(
                    child: PostedPosts(
                      userId: bloc.getProfileId(),
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
