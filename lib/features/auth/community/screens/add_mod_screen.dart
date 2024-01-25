import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/constants/common/error_text.dart';
import 'package:reddit_clone/core/constants/common/loader.dart';
import 'package:reddit_clone/features/auth/community/controller/community_controller.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';

class AddModScreen extends ConsumerStatefulWidget {
  final String name;
  const AddModScreen({super.key, required this.name});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddModScreenState();
}

class _AddModScreenState extends ConsumerState<AddModScreen> {
  Set<String> uids = {};
  int ctr = 0;

  void addUid(String uid) {
    setState(() {
      uids.add(uid);
    });
  }

  void removeUid(String uid) {
    setState(() {
      uids.remove(uid);
    });
  }

  void savMods() {
    ref
        .read(communtiyControllerProvider.notifier)
        .addMods(widget.name, uids.toList(), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Moderators'),
        actions: [
          IconButton(
            onPressed: savMods,
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: ref.watch(getCommunitiesByNameProvider(widget.name)).when(
          data: (community) => ListView.builder(
              itemCount: community.members.length,
              itemBuilder: ((context, index) {
                final member = community.members[index];

                return ref.watch(getUserDataProvider(member)).when(
                    data: (user) {
                      if (community.members.contains(member) && ctr == 0) {
                        uids.add(member);
                      }
                      ctr++;
                      return CheckboxListTile(
                          value: uids.contains(user.uid),
                          onChanged: (val) {
                            if (val!) {
                              addUid(user.uid);
                            } else {
                              removeUid(user.uid);
                            }
                          },
                          title: Text(user.name));
                    },
                    error: (Object error, StackTrace stackTrace) =>
                        ErrorText(error: error.toString()),
                    loading: () => const Loader());
              })),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader()),
    );
  }
}
