import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_demo/second.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(

  );
  runApp(MaterialApp(home: first(),));
}
// Future<void> Main()
// async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//
//   );
//   runApp(MaterialApp(
//     home: first(),
//     debugShowCheckedModeBanner: false,
//   ));
// }
class first extends StatefulWidget {
  const first({super.key});

  @override
  State<first> createState() => _firstState();
}

class _firstState extends State<first> {
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Name, email address, and profile photo URL
      String name = user.displayName.toString();
      String email = user.email.toString();
      WidgetsBinding.instance.addPostFrameCallback((_){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return second(name, email);
        },));
      });

    }

  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ElevatedButton(onPressed: () {
        signInWithGoogle().then((value) {
          String name,email;
          name=value.user!.displayName.toString();
          email=value.user!.email.toString();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return second(name,email);
          },));

        });
      }, child: Text("submit")),
    );
  }
}
