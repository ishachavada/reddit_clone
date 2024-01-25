import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/posts/controller/post_controller.dart';
import 'package:reddit_clone/models/comment_model.dart';
import 'package:reddit_clone/responsive/responsive.dart';
import 'package:routemaster/routemaster.dart';

class CommentCard extends ConsumerWidget {
  final Comment comment;
  const CommentCard({
    super.key,
    required this.comment,
  });

  void naviagteToUser(BuildContext context) {
    Routemaster.of(context).push('/u/${comment.uid}');
  }

  void deleteComment(WidgetRef ref, BuildContext context) async {
    ref.read(postControllerProvider.notifier).deleteComment(comment, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Responsive(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 1,
          horizontal: 5,
        ),
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 2),
                    child: GestureDetector(
                      onTap: () => naviagteToUser(context),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(comment.profilePic),
                        radius: 21,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        top: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'u/${comment.username}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Color.fromARGB(255, 86, 86, 84)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6.0, left: 5),
                            child: Text(
                              comment.text,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.reply),
                        ),
                        const Text(
                          'reply',
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => deleteComment(ref, context),
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
