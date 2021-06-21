import 'package:chatapp/UIPart/chatsUI/chatsList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

//Show Snackbar
class GoogleAuthentication {
  static SnackBar customSnackBar({@required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

//AutoLogin Google
  static Future<FirebaseApp> initializeFirebase({
    @required BuildContext context,
  }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ChatPage(),
        ),
      );
    }

    return firebaseApp;
  }

//Sign In Method
  static Future<User> signInWithGoogle({@required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        user =
            (await FirebaseAuth.instance.signInWithCredential(credential)).user;
        FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          "userName": user.displayName,
          "imageUrl": user.photoURL,
          "email": user.email,
          "uid": user.uid,
        });
        try {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              GoogleAuthentication.customSnackBar(
                content:
                    'The account already exists with a different credential',
              ),
            );
          } else if (e.code == 'invalid-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              GoogleAuthentication.customSnackBar(
                content:
                    'Error occurred while accessing credentials. Try again.',
              ),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            GoogleAuthentication.customSnackBar(
              content: 'Error occurred using Google Sign In. Try again.',
            ),
          );
        }
      }
    }

    return user;
  }

//Signout Method
  // static Future<void> signOut({@required BuildContext context}) async {
  //   final GoogleSignIn googleSignIn = GoogleSignIn();

  //   try {
  //     if (!kIsWeb) {
  //       await googleSignIn.signOut();
  //     }
  //     await FirebaseAuth.instance.signOut();
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       GoogleAuthentication.customSnackBar(
  //         content: 'Error signing out. Try again.',
  //       ),
  //     );
  //   }
  // }
}
