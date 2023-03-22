import 'package:bibliophile/bloc/provider.dart';
import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
  final String name;
  final String bookTitle;
  final DateTime createdAt;
  final String msg;
  final List likes;
  final List comments;
  final List saves;
  final String id;

  const PostCard(
      {Key? key,
      required this.name,
      required this.bookTitle,
      required this.createdAt,
      required this.msg,
      required this.likes,
      required this.comments,
      required this.id,
      required this.saves})
      : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isExpanded = false;
  bool isLiked = false;
  bool isSaved = false;

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  void toggleSave() {
    setState(() {
      isSaved = !isSaved;
    });
  }

  String formatRelativeTime(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inDays > 1) {
      return '${diff.inDays} days ago';
    } else if (diff.inDays == 1) {
      return 'yesterday';
    } else if (diff.inHours > 1) {
      return '${diff.inHours} hours ago';
    } else if (diff.inHours == 1) {
      return '1 hour ago';
    } else if (diff.inMinutes > 1) {
      return '${diff.inMinutes} minutes ago';
    } else if (diff.inMinutes == 1) {
      return '1 minute ago';
    } else {
      return 'just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    return SingleChildScrollView(
      child: Card(
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: Color.fromARGB(255, 206, 213, 220), width: 2),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.name} on ${widget.bookTitle}',
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 17),
                  ),
                  Text(
                    formatRelativeTime(widget.createdAt),
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                constraints: BoxConstraints(
                  maxHeight: _isExpanded ? 300 : 100.0,
                ),
                child: SingleChildScrollView(
                  child: Text(
                    widget.msg,
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    _isExpanded ? "See less" : "See more",
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: isLiked
                            ? const Icon(Icons.favorite)
                            : const Icon(Icons.favorite_border),
                        onPressed: toggleLike,
                        color: isLiked ? Colors.red : null,
                      ),
                      const Text(
                        'Like',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 14),
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.comment),
                        onPressed: () {},
                      ),
                      const Text(
                        'Comment',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 14),
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: isSaved
                            ? const Icon(Icons.bookmark)
                            : widget.saves.contains(bloc!.getUserId())
                                ? const Icon(Icons.bookmark)
                                : const Icon(Icons.bookmark_border),
                        onPressed: () {
                          bloc!.savePostOutput(widget.id);
                        },
                        color: isSaved
                            ? Colors.blue
                            : widget.saves.contains(bloc!.getUserId())
                                ? Colors.blue
                                : null,
                      ),
                      const Text(
                        'Save',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 14),
                      )
                    ],
                  ),
                ],
              ),
              StreamBuilder<Map<String, dynamic>>(
                stream: bloc!.savePost,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    final msg = snapshot.data!['message'] as String;
                    Future.delayed(
                      const Duration(microseconds: 500),
                      () async {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(msg),
                          duration: const Duration(seconds: 1),
                        ));
                        toggleSave();
                        bloc.fetchAllPosts();
                        bloc.clearSavePostOutput();
                      },
                    );

                    return const SizedBox.shrink();
                  }
                  return const SizedBox.shrink();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
