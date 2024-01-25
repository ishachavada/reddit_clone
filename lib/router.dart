import 'package:flutter/material.dart';
import 'package:reddit_clone/features/auth/community/screens/add_mod_screen.dart';
import 'package:reddit_clone/features/auth/community/screens/community_screen.dart';
import 'package:reddit_clone/features/auth/community/screens/create_community_screen.dart';
import 'package:reddit_clone/features/auth/community/screens/edit_community_screen.dart';
import 'package:reddit_clone/features/auth/community/screens/mod_tools_screen.dart';
import 'package:reddit_clone/features/auth/home/home_screen.dart';
import 'package:reddit_clone/features/auth/screens/login_screen.dart';
import 'package:reddit_clone/features/posts/screens/add_post_screen.dart';
import 'package:reddit_clone/features/posts/screens/add_post_type_screen.dart';
import 'package:reddit_clone/features/posts/screens/comment_screen.dart';
import 'package:reddit_clone/user_profile/screens/edit_profile_screen.dart';
import 'package:reddit_clone/user_profile/screens/user_profile_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),
  '/create-community': (_) =>
      const MaterialPage(child: CreateCommunityScreen()),
  '/r/:name': (route) => MaterialPage(
          //dynamic router.
          child: CommunityScreen(
        name: route.pathParameters['name']!,
      )),
  '/mod-tools/:name': (routeData) => MaterialPage(
        child: ModToolsScreen(
          name: routeData.pathParameters['name']!,
        ),
      ),
  '/edit-community/:name': (routeData) => MaterialPage(
        child: EditCommunityScreen(
          name: routeData.pathParameters['name']!,
        ),
      ),
  '/add-mods/:name': (routeData) => MaterialPage(
        child: AddModScreen(
          name: routeData.pathParameters['name']!,
        ),
      ),
  '/u/:uid': (routeData) => MaterialPage(
        child: UserprofileScreen(
          uid: routeData.pathParameters['uid']!,
        ),
      ),
  '/edit-profile/:uid': (routeData) => MaterialPage(
        child: EditProfileScreen(
          uid: routeData.pathParameters['uid']!,
        ),
      ),
  '/add-post/:type': (routeData) => MaterialPage(
        child: AddPostTypeScreen(
          type: routeData.pathParameters['type']!,
        ),
      ),
  '/post/:postId/comments': (route) => MaterialPage(
        child: CommentScreen(
          postId: route.pathParameters['postId']!,
        ),
      ),
  '/add-post': (routeData) => const MaterialPage(
        child: AddPostScreen(),
      ),
});
