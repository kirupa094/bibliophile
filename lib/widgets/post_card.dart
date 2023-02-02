import 'dart:ui';

import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
  const PostCard({Key? key}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isExpanded = false;
  bool isLiked = false;
  bool isSaved = false;
  String text =
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.";

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

  @override
  Widget build(BuildContext context) {
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
                children: const [
                  Text(
                    'John on Crime and punishment',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 17),
                  ),
                  Text(
                    '3h ago',
                    style: TextStyle(
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
                    text,
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
                            : const Icon(Icons.bookmark_border),
                        onPressed: toggleSave,
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
            ],
          ),
        ),
      ),
    );
  }
}
