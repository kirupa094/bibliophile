import 'package:bibliophile/bloc/provider.dart';
import 'package:bibliophile/model/comment_model.dart';
import 'package:bibliophile/util/constant.dart';
import 'package:flutter/material.dart';

class CommentScreen extends StatelessWidget {
  final String postId;
  final String username;
  final String creatorId;
  const CommentScreen(
      {Key? key,
      required this.postId,
      required this.username,
      required this.creatorId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    bloc!.commentResultOutput(postId);
    final TextEditingController _textController = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$username' Post",
              style: const TextStyle(color: Colors.black),
            ),
            IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () {
                bloc.clearComments();
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: TextField(
                cursorColor: Colors.black,
                controller: _textController,
                decoration: InputDecoration(
                  hintText: 'Add comment',
                  contentPadding: const EdgeInsets.all(15.0),
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 16),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Colors.grey[400],
                    ),
                    onPressed: () {
                      if (_textController.text != '') {
                        bloc.commentPostOutput(postId, bloc.getUserName(),
                            bloc.getUserImage(), _textController.text);
                        _textController.text = '';
                      }
                      FocusScope.of(context).unfocus();
                    },
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 118, 118, 118)),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide(
                        color: textWarning,
                      )),
                  focusedErrorBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    borderSide: BorderSide(
                      color: textWarning,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder<List<CommentModel>>(
              stream: bloc.comments,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.data!.isEmpty) {
                  return const SizedBox.shrink();
                }
                if (snapshot.data!.isNotEmpty) {
                  return ListView.separated(
                    padding:
                        const EdgeInsets.only(left: 10, top: 10, right: 10),
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 8,
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (bloc.getUserId() != creatorId) {
                                bloc.changeIsShowProfilePage(false);
                                bloc.setProfileId(creatorId);
                                bloc.userProfileOutput(creatorId);
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
                                    image: NetworkImage(
                                        snapshot.data![index].photoURL),
                                    fit: BoxFit.cover,
                                  )),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                                color: Colors.grey[200]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data![index].username,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Text(snapshot.data![index].comment,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400)),
                              ],
                            ),
                          )
                        ],
                      );
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
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
                      bloc.commentResultOutput(postId);
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
    );
  }
}
