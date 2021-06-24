import 'package:coalam_app/screens/Templates.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coalam_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:coalam_app/models/data.dart';
import 'package:coalam_app/screens/AccountEditScreen.dart';

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

  Future<GoogleSignInAccount?> _signInUser() async {
    try {
      await _googleSignIn.signIn();
      return _googleSignIn.currentUser;
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() async {
    try {
      await _googleSignIn.signOut();
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
      appBar: AppBar(
          title:
              Center(child: CTransText('Hello Friend come in!').textWidget())),
      body: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/kitchen.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Consumer<GlobalState>(
            builder: (context, status, child) {
              var status = context.read<GlobalState>();
              return SizedBox(
                  width: 300, // set this
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          child: CTransText("What's cooking ? ").textWidget(),
                          onPressed: () {
                            Navigator.pushNamed(context, '/list');
                          },
                        ),
                        !status.isLoggedIn
                            ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.green),
                                child: CTransText("Sign in with Google")
                                    .textWidget(),
                                onPressed: () async {
                                  GoogleSignInAccount? _loggedInUser = await _signInUser();
                                  Chef _chef = await fetchChef(_loggedInUser!.id, 'google');
                                  status.logIn();
                                  status.setChefId(_chef.chefId!);
                                  status.updateUser(_loggedInUser);
                                  print(_chef.chefId);
                                  _chef.chefId == 0
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AccountEditScreen(
                                                      chefId: _chef.chefId,
                                                      gId:_loggedInUser.id,
                                                      name: _loggedInUser.displayName )))
                                      : Navigator.pushNamed(context, '/list');
                                })
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.red),
                                child: CTransText("Sign out").textWidget(),
                                onPressed: () async {
                                  await _handleSignOut();
                                  status.logOut();
                                  status.setChefId(0);

                                },
                              ),
                      ]));
            },
          )),
    );
  }
}
