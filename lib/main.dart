import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:coalam_app/screens/HomeScreen.dart';
import 'package:coalam_app/screens/SigninDemo.dart';
import 'package:coalam_app/screens/RecipeDetailsScreen.dart';
import 'package:coalam_app/screens/RecipesListScreen.dart';
import 'package:coalam_app/screens/RecipeEditScreen.dart';
import 'package:coalam_app/screens/AccountEditScreen.dart';
import './globals.dart' as globals;


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GlobalState(),
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings) {
        // Handle '/'
        if (settings.name == '/') {
          return MaterialPageRoute(builder: (context) => HomeScreen());
        }
        var uri = Uri.parse(settings.name!);
        // Handle '/details/:id'
        if (uri.pathSegments.length == 2 &&
            uri.pathSegments.first == 'details') {
          var id = uri.pathSegments[1];
          return MaterialPageRoute(builder: (context) => RecipeDetailsScreen(id: id));
        }
        if (uri.pathSegments.length == 1 &&
            uri.pathSegments.first == 'list') {
          return MaterialPageRoute(builder: (context) => RecipesListScreen());
        }
        if (uri.pathSegments.length == 1 &&
            uri.pathSegments.first == 'create') {
          return MaterialPageRoute(builder: (context) => RecipeEditScreen());
        }
        if (uri.pathSegments.length == 1 &&
            uri.pathSegments.first == 'account') {
          return MaterialPageRoute(builder: (context) => AccountEditScreen());
        }

        return MaterialPageRoute(builder: (context) => UnknownScreen());
      },
      theme: ThemeData(
          primaryColor: Colors.grey[600],
          accentColor: Colors.blueGrey[500],
          // text button theme
          textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                textStyle: TextStyle(
                    foreground: Paint()..color = Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              )),
          // elevated button theme
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  primary: Colors.blue[600], // background color
                  textStyle:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold )),
          )),
    );
  }
}

class UnknownScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text('404!'),
      ),
    );
  }
}

class GlobalState with ChangeNotifier {

  bool isLoggedIn = false;
  int chefId = 0;
  String chefName = '';
  GoogleSignInAccount? currentUser;

  void updateUser(GoogleSignInAccount? user) {
    currentUser = user;
    notifyListeners();
  }

  void logOut() {
    isLoggedIn = false;
    notifyListeners();
  }
  void logIn() {
    isLoggedIn = true;
    notifyListeners();
  }
  void toggleLogIn() {
    isLoggedIn = !isLoggedIn;
    notifyListeners();
    isLoggedIn ? setChefId(globals.chefId) : setChefId(0);
  }
  void setChefId(int id){
    chefId = id;
    notifyListeners();
  }
}