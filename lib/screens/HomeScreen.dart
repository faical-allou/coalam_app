import 'package:coalam_app/screens/Templates.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coalam_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {

  State createState() => new HomeScreenState();

}

class HomeScreenState extends State<HomeScreen> {
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/userinfo.profile',
      'openid'
    ],
  );
  GoogleSignInAccount? _currentUser;

  Future<void> _handleSignIn(status) async {
    try {
      await _googleSignIn.signIn();
      status.logIn();
      status.updateUser(_currentUser);
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut(status) async {
    try {
      await _googleSignIn.signOut();
      status.logOut();
      status.updateUser(_currentUser);
    } catch (error) {
      print(error);
    }
  }



  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child:CTransText('Hello Friend come in!').textWidget())),
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/kitchen.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child:
        Consumer<GlobalState>(
            builder: (context, status, child) {
              var status = context.read<GlobalState>();
              return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                child: CTransText("What's cooking ? ").textWidget(),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/list',
                  );
                },
              ),
              ElevatedButton(
                child: CTransText("Sign in with Google").textWidget(),
                onPressed: () {
                  print('pressed sign-in');
                  _handleSignIn(status);
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                ),
                child: CTransText("Sign out with Google").textWidget(),
                onPressed: () {
                  print('pressed sign-out');
                  _handleSignOut(status);
                },
              ),
              TextButton(
                 child:
                      Text(status.currentUser.toString()),
                  onPressed: () {
                   print(status.currentUser.toString());
                    status.toggleLogIn();

              })
            ]);
            },
        )
            ),
      );
  }
}


