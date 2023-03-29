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

  Future<void> _commentBox(BuildContext context, String userName, String postId,
      Bloc bloc, List lst) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          margin: const EdgeInsets.all(40),
          width: MediaQuery.of(context).size.width,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "$userName' Post",
                    style: const TextStyle(color: Colors.black),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            ),
            body: SingleChildScrollView(
              child: lst.isNotEmpty
                  ? ListView.separated(
                      padding:
                          const EdgeInsets.only(left: 10, top: 10, right: 10),
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 8,
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: lst.length,
                      itemBuilder: (BuildContext ctx, index) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (bloc.getUserId() != widget.creator) {
                                  bloc.changeIsShowProfilePage(false);
                                  bloc.setProfileId(widget.creator);
                                  bloc.userProfileOutput(widget.creator);
                                }
                                Navigator.of(context).pop();
                                bloc.changeCurrentTabIndex(2);
                              },
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image:
                                          NetworkImage(lst[index]['photoURL']),
                                      fit: BoxFit.cover,
                                    )),
                              ),
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
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    final TextEditingController _textController = TextEditingController();
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
                        onPressed: () => setState(() {
                          _isVisible = !_isVisible;
                        }),
                      ),
                      GestureDetector(
                        onTap: () => _commentBox(context, widget.name,
                            widget.id, bloc!, widget.comments),
                        child: Text(
                          widget.comments.length > 1
                              ? '${widget.comments.length} Comments'
                              : widget.comments.length == 1
                                  ? '${widget.comments.length} Comment'
                                  : 'Comment',
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                        ),
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
              Visibility(
                visible: _isVisible,
                child: Container(
                  padding: const EdgeInsets.all(8),
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
                            bloc!.commentPostOutput(
                                widget.id,
                                bloc.getUserName(),
                                bloc.getUserImage(),
                                _textController.text);
                            _textController.text = '';
                          }
                          FocusScope.of(context).unfocus();
                        },
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: textWarning, width: 2),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 238, 238, 238),
                            width: 2),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 238, 238, 238),
                            width: 2),
                      ),
                    ),
                  ),
                ),
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
              StreamBuilder<Map<String, dynamic>>(
                stream: bloc.commentPost,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    final msg = snapshot.data!['message'] as String;
                    Future.delayed(
                      const Duration(microseconds: 500),
                      () async {
                        bloc.clearCommentPostOutput();
                        bloc.fetchAllPosts();
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
