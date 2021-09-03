import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:prio_project/authentication/authenticationService.dart';
import 'package:prio_project/provider/personalInfosProv.dart';
import 'package:prio_project/provider/privateReqProv.dart';
import 'package:prio_project/provider/requestsProv.dart';
import 'package:prio_project/provider/watchlistReqProv.dart';
import 'package:prio_project/screens/authScreen.dart';
import 'package:prio_project/screens/navigatorScreen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider<User>(
          create: (BuildContext context) =>
              context.read<AuthenticationService>().authStateChanges,
        ),
        ChangeNotifierProvider<Requests>.value(
          value: Requests(),
        ),
        ChangeNotifierProvider<PersonalInfos>.value(
          value: PersonalInfos(),
        ),
        ChangeNotifierProvider<PersonalRequests>.value(
          value: PersonalRequests(),
        ),
        ChangeNotifierProvider<WatchlistRequests>.value(
          value: WatchlistRequests(),
        ),
      ],
      child: MaterialApp(
        title: 'Prio',
        debugShowCheckedModeBanner: false,
        home: AuthenticationWrapper(),
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User firebaseUser = context.watch<User>();
    if (firebaseUser != null) {
      return NavigatorScreen();
    }
    return AuthScreen();
  }
}
