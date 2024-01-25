import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_clone/core/constants/constans.dart';
import 'package:reddit_clone/core/constants/firebase_constants.dart';
import 'package:reddit_clone/core/constants/providers/firebase_providers.dart';
import 'package:reddit_clone/core/constants/type_defs.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/models/user_model.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    googleSignIn: ref.read(googleSignInProvider),
    auth: ref.read(authProvider),
    firestore: ref.read(firestoreProvider),
  ),
);

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRepository(
      {required GoogleSignIn googleSignIn,
      required FirebaseAuth auth,
      required FirebaseFirestore firestore})
      : _googleSignIn = googleSignIn,
        _auth = auth,
        _firestore = firestore;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  Stream<User?> get authStateChange => _auth.authStateChanges();

  FutureEither<UserModel> signInWithGoogle(bool isFromLogin) async {
    try {
      UserCredential userCredential;
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider
            .addScope('https://www.googleapis.com/auth/contacts.readonly');
        userCredential = await _auth.signInWithPopup(googleProvider); //for web.
      } else {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        final googleAuth = await googleUser?.authentication;
        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth?.idToken,
          accessToken: googleAuth?.accessToken,
        );
        //for ios and android.
        if (isFromLogin) {
          userCredential = await _auth.signInWithCredential(credential);
        } else {
          userCredential =
              await _auth.currentUser!.linkWithCredential(credential);
        }
      }

      UserModel userModel;

      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          name: userCredential.user!.displayName ?? 'No Name',
          profilePic: userCredential.user!.photoURL ?? Constants.avatarDefault,
          banner: Constants.bannerDefault,
          uid: userCredential.user!.uid,
          isAuthenticated:
              true, //means user is not a guest,they already have an id on reddit.
          karma: 0,
          awards: [
            'awesomeAns',
            'gold',
            'platinum',
            'helpful',
            'plusone',
            'rocket',
            'thankyou',
            'til',
          ],
        );
        await _users.doc(userCredential.user!.uid).set(userModel.toMap());
      } else {
        // --> --> --> these are streams, now first will convert the stream to future and only get us the very first values of the stream.
        userModel = await getUserData(userCredential.user!.uid).first;
      }
      return right(userModel);
    } on FirebaseException catch (e) {
      //never be null cuz we have caught it
      throw e.message!; //throw it to the next catch block.
    } catch (e) {
      return left(
        Failure(e.toString()),
      ); //or throw e;
    }
  }

  FutureEither<UserModel> signInAsGuest() async {
    try {
      var userCredential = await _auth.signInAnonymously();

      UserModel userModel = UserModel(
        name: 'Guest',
        profilePic: Constants.avatarDefault,
        banner: Constants.bannerDefault,
        uid: userCredential.user!.uid,
        isAuthenticated: false, //means user is a guest.
        karma: 0,
        awards: [],
      );
      await _users.doc(userCredential.user!.uid).set(userModel.toMap());
      return right(userModel);
    } on FirebaseException catch (e) {
      //never be null cuz we have caught it
      throw e.message!; //throw it to the next catch block.
    } catch (e) {
      return left(
        Failure(e.toString()),
      ); //or throw e;
    }
  }

  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  void logOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}



//provider is a read only widget, to change the value you'll have to use a different type of provider.
//ref -- can be of type - just ref, widget ref, provider ref.
//provider ref allows you to contact with other providers and will give you a bunch of
//methods to talk to other provider.
//imp ref methofs -ref.read() -ref.watch() -ref.listen().
//-ref.read() - we use it when we are outside the build function.
//-ref.watch() - we use it when we are inside the build function.

