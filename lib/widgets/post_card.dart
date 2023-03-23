import 'package:bibliophile/bloc/provider.dart';
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
  int likeCount = 0;

  void toggleLike() {
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

  Future<void> _commentBox(BuildContext context, String userName, String postId,
      Bloc bloc, List lst) {
    final TextEditingController _textController = TextEditingController();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$userName' Post",
                style: const TextStyle(color: Colors.black),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
          contentPadding: const EdgeInsets.only(left: 10, top: 10),
          content: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: lst.isNotEmpty
                  ? ListView.separated(
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 8,
                      ),
                      shrinkWrap: true,
                      itemCount: lst.length,
                      itemBuilder: (BuildContext ctx, index) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(lst[index]['photoURL']),
                                    fit: BoxFit.cover,
                                  )),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  color: Color.fromARGB(255, 170, 170, 170)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    lst[index]['username'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Text(lst[index]['comment'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w400)),
                                ],
                              ),
                            )
                          ],
                        );
                      },
                    )
                  : const SizedBox.shrink(),
            ),
            bottomNavigationBar: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(15.0),
                  filled: true,
                  fillColor: Colors.white,
                  hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 118, 118, 118),
                      fontWeight: FontWeight.w400,
                      fontSize: 16),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      if (_textController.text != '') {
                        bloc.commentPostOutput(postId, bloc.getUserName(),
                            bloc.getUserImage(), _textController.text);
                        bloc.fetchAllPosts();
                      }
                      FocusScope.of(context).unfocus();
                      Navigator.of(context).pop();
                    },
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: textWarning, width: 2),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 238, 238, 238), width: 2),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 238, 238, 238), width: 2),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
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
                        onPressed: () {
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
                        onPressed: () => _commentBox(context, widget.name,
                            widget.id, bloc!, widget.comments),
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
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(msg),
                          duration: const Duration(seconds: 1),
                        ));
                        toggleSave();
                        bloc.clearSavePostOutput();
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
                    final msg = snapshot.data!['message'] as String;
                    Future.delayed(
                      const Duration(microseconds: 500),
                      () async {
                        toggleLike();
                        bloc.clearLikePostOutput();
                      },
                    );

                    return const SizedBox.shrink();
                  }
                  return const SizedBox.shrink();
                },
              ),
              StreamBuilder<Map<String, dynamic>>(
                stream: bloc.commentPost,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    final msg = snapshot.data!['message'] as String;
                    Future.delayed(
                      const Duration(microseconds: 500),
                      () async {
                        bloc.clearCommentPostOutput();
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
