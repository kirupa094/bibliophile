import 'package:bibliophile/bloc/provider.dart';
import 'package:bibliophile/model/comment_model.dart';
import 'package:bibliophile/screen/Home/comment_screen.dart';
import 'package:bibliophile/util/constant.dart';
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
  final String creator;
  final String title;

  const PostCard(
      {Key? key,
      required this.name,
      required this.bookTitle,
      required this.createdAt,
      required this.msg,
      required this.likes,
      required this.comments,
      required this.id,
      required this.saves,
      required this.creator,
      required this.title})
      : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isExpanded = false;
  bool _isVisible = false;
  bool isSaved = false;
  int likeCount = 0;
  bool isLiked = false;
  String postId = '';

  void toggleLike(Bloc bloc) {
    setState(() {
      isLiked = !isLiked;
    });
    if (isLiked) {
      setState(() {
        likeCount = likeCount + 1;
      });
    } else {
      setState(() {
        likeCount = likeCount - 1;
      });
    }
  }

  void toggleSave(Bloc bloc) {
    setState(() {
      isSaved = !isSaved;
    });
  }

  bool isLikePost(List lst, Bloc bloc) {
    int matchCount = 0;
    bool isLiked = false;
    for (var i = 0; i < lst.length; i++) {
      if (lst[i]['uid'] == bloc.getUserId()) {
        matchCount++;
      }
    }
    if (matchCount > 0) {
      isLiked = true;
    }
    return isLiked;
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = Provider.of(context);
      if (widget.saves.contains(bloc!.getUserId())) {
        setState(() {
          isSaved = true;
        });
      }
      for (var i = 0; i < widget.likes.length; i++) {
        if (widget.likes[i]['uid'] == bloc.getUserId()) {
          setState(() {
            isLiked = true;
          });
          break;
        }
      }
      setState(() {
        likeCount = widget.likes.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    return SingleChildScrollView(
      child: Card(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Text(
                  '${widget.bookTitle} ',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '${widget.title} ',
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 25),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (bloc!.getUserId() != widget.creator) {
                            bloc.changeIsShowProfilePage(false);
                            bloc.setProfileId(widget.creator);
                            bloc.userProfileOutput(widget.creator);
                          }
                          bloc.changeCurrentTabIndex(2);
                        },
                        child: Text(
                          '${widget.name} ',
                          style: const TextStyle(
                              color: Color.fromARGB(255, 105, 105, 105),
                              fontWeight: FontWeight.w600,
                              fontSize: 17),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  const Text(
                    '•',
                    style: TextStyle(
                        color: Color.fromARGB(255, 105, 105, 105),
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    formatRelativeTime(widget.createdAt),
                    style: const TextStyle(
                        color: Color.fromARGB(255, 105, 105, 105),
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                  )
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                constraints: BoxConstraints(
                  maxHeight: _isExpanded ? 300 : 100.0,
                ),
                child: SingleChildScrollView(
                  child: Text(
                    widget.msg,
                    textAlign: TextAlign.left,
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
                        onPressed: () {
                          setState(() {
                            postId = widget.id;
                          });
                          bloc!.likePostOutput(widget.id, bloc.getUserName(),
                              bloc.getUserImage());
                        },
                        color: isLiked ? Colors.blue : null,
                      ),
                      Text(
                        likeCount > 1
                            ? '$likeCount Likes'
                            : likeCount == 1
                                ? '$likeCount Like'
                                : 'Like',
                        style: const TextStyle(
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommentScreen(
                                  postId: widget.id,
                                  username: widget.name,
                                  creatorId: widget.creator),
                            ),
                          );
                        },
                      ),
                      Text(
                        widget.comments.length > 1
                            ? '${widget.comments.length} Comments'
                            : widget.comments.length == 1
                                ? '${widget.comments.length} Comment'
                                : 'Comment',
                        style: const TextStyle(
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
                            : const Icon(Icons.bookmark_border),
                        onPressed: () {
                          setState(() {
                            postId = widget.id;
                          });
                          bloc!.savePostOutput(widget.id);
                        },
                        color: isSaved ? Colors.blue : null,
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
                        if (snapshot.data!['_id'] == postId) {
                          toggleSave(bloc);
                          bloc.fetchAllPosts();
                          bloc.fetchAllSavePostsByCreator();
                          bloc.clearSavePostOutput();
                        }
                      },
                    );

                    return const SizedBox.shrink();
                  }
                  return const SizedBox.shrink();
                },
              ),
              StreamBuilder<Map<String, dynamic>>(
                stream: bloc.likePost,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    Future.delayed(
                      const Duration(microseconds: 500),
                      () async {
                        if (snapshot.data!['_id'] == postId) {
                          toggleLike(bloc);
                          bloc.fetchAllPosts();
                          bloc.clearLikePostOutput();
                        }
                      },
                    );

                    return const SizedBox.shrink();
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
