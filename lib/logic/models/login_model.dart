import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../ui/components/login/login_fail.dart';

class LoginModel {
  String email;
  String password;

  LoginModel({required this.email, required this.password});

  bool isWrongPassword = false;

  Future SignIn() async {



    if (email == null && password == null) {
      return LoginFail();
    } else {
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        String? fcmToken = await FirebaseMessaging.instance.getToken();
        // Store the FCM token in Firestore if it doesn't exist



        if (fcmToken != null) {
          String uid = FirebaseAuth.instance.currentUser!.uid;
          var userSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .where('Userid', isEqualTo: uid)
              .get();

          if (!userSnapshot.docs.isEmpty) {
            // User document already exists
            var userData = userSnapshot.docs[0].data();
            String existingToken = userData['fcmToken'] ?? '';

            if (existingToken != fcmToken) {
              // FCM token is different from the existing token
              var userDocRef = userSnapshot.docs[0].reference;
              await userDocRef.update({'fcmToken': fcmToken});
            }
          } else {
            // User document doesn't exist, create a new one
            await FirebaseFirestore.instance
                .collection('users')
                .add({'Userid': uid, 'fcmToken': fcmToken});
          }
        }





      } on FirebaseAuthException catch (e) {

        return LoginFail();
      }
    }
  }
}

class LogoutModel {
  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
