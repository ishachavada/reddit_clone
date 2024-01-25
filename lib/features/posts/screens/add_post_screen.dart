import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class AddPostScreen extends ConsumerWidget {
  const AddPostScreen({super.key});

  void navigateToType(BuildContext context, String type) {
    Routemaster.of(context).push('/add-post/$type');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double cardHeightWidth = kIsWeb ? 360 : 120;
    double iconSize = kIsWeb ? 110 : 50;
    final currentTheme = ref.watch(themeNotifierProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Scaffold(
        body: Column(
          children: [
            const Text(
              'Post something!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => navigateToType(context, 'image'),
                  child: SizedBox(
                    height: cardHeightWidth,
                    width: cardHeightWidth,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: currentTheme.backgroundColor,
                      elevation: 16,
                      child: Center(
                        child: Icon(
                          Icons.image_rounded,
                          size: iconSize,
                          semanticLabel: 'Image',
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => navigateToType(context, 'text'),
                  child: SizedBox(
                    height: cardHeightWidth,
                    width: cardHeightWidth,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: currentTheme.backgroundColor,
                      elevation: 16,
                      child: Center(
                        child: Icon(
                          Icons.text_fields_sharp,
                          size: iconSize,
                          semanticLabel: 'Text',
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => navigateToType(context, 'link'),
                  child: SizedBox(
                    height: cardHeightWidth,
                    width: cardHeightWidth,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: currentTheme.backgroundColor,
                      elevation: 16,
                      child: Center(
                        child: Icon(
                          Icons.link_outlined,
                          size: iconSize,
                          semanticLabel: 'link',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 14,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Image',
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  'Text',
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  'Link',
                  style: TextStyle(fontSize: 15),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
