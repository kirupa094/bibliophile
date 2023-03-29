import 'package:bibliophile/bloc/provider.dart';
import 'package:bibliophile/model/post_model.dart';
import 'package:bibliophile/widgets/post_card.dart';
import 'package:flutter/material.dart';

class PostedPosts extends StatelessWidget {
  final String userId;
  const PostedPosts({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    bloc!.fetchAllPostsByCreator(userId);
    return StreamBuilder<List<PostModel>>(
      stream: bloc.getAllPostsByCreator,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No post yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
        return _buildList(snapshot.data, context);
      },
    );
  }

  _buildList(List<PostModel>? lst, BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(
        height: 10,
      ),
      shrinkWrap: true,
      itemCount: lst!.length,
      itemBuilder: (BuildContext ctx, index) {
        return PostCard(
          bookTitle: lst[index].bookTitle,
          comments: lst[index].comments,
          createdAt: lst[index].createdAt,
          id: lst[index].id,
          likes: lst[index].likes,
          msg: lst[index].message,
          name: lst[index].name,
          saves: lst[index].saves,
          creator: lst[index].creatorId,
        );
      },
    );
  }
}
