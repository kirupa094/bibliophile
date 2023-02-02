import 'package:bibliophile/widgets/post_card.dart';
import 'package:flutter/material.dart';

class SavedPosts extends StatelessWidget {
  const SavedPosts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: const [
          PostCard(),
          SizedBox(
            height: 10,
          ),
          PostCard(),
          SizedBox(
            height: 10,
          ),
          PostCard(),
        ],
      ),
    );
  }
}
