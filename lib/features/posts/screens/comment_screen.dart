import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/constants/common/error_text.dart';
import 'package:reddit_clone/core/constants/common/loader.dart';
import 'package:reddit_clone/core/constants/common/post_card.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/posts/controller/post_controller.dart';
import 'package:reddit_clone/features/posts/widgets/comment_card.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/responsive/responsive.dart';

class CommentScreen extends ConsumerStatefulWidget {
  final String postId;
  const CommentScreen({super.key, required this.postId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentScreenState();
}

class _CommentScreenState extends ConsumerState<CommentScreen> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  void addComment(Post post) {
    ref.read(postControllerProvider.notifier).addComment(
          context: context,
          text: commentController.text.trim(),
          post: post,
        );

    setState(() {
      commentController.text = ' ';
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(getPostByIdProvider(widget.postId)).when(
          data: (data) {
            return Column(
              children: [
                PostCard(post: data),
                if (!isGuest)
                  Responsive(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 13.0, vertical: 10),
                      child: TextField(
                        onSubmitted: (val) => addComment(data),
                        controller: commentController,
                        decoration: const InputDecoration(
                          hintText: 'Comment',
                          filled: true,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ref.watch(fetchPostCommentsProvider(widget.postId)).when(
                    data: (data) {
                      return Expanded(
                        child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final comment = data[index];
                              return CommentCard(comment: comment);
                            }),
                      );
                    },
                    error: (error, stackTrace) =>
                        ErrorText(error: error.toString()),
                    loading: () => const Loader()),
              ],
            );
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader()),
    );
  }
}
