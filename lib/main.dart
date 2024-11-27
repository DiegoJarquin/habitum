import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:habitum/screens/crear_cuenta.dart';
import 'package:habitum/screens/home.dart';
import 'package:habitum/screens/login.dart';
import 'package:habitum/services/auth_service.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> outgoingKey = GlobalKey<NavigatorState>();
   MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/login': (context) => Login(navigatorKey: outgoingKey,),
        '/home': (context) => const Home(title: ''),
      },
      title: 'Flutter',
      theme: ThemeData(
        textTheme: GoogleFonts.ubuntuTextTheme(),
        useMaterial3: true,
        colorSchemeSeed: const Color.fromRGBO(255, 241, 197, 0),
      ),
      darkTheme: ThemeData(
        textTheme: GoogleFonts.ubuntuTextTheme(),
        brightness: Brightness.dark,
      colorSchemeSeed: const Color.fromRGBO(255, 255, 241, 171),
      useMaterial3: true,
    ),

      themeMode: ThemeMode.system,
      home: MyHomePage(navigatorKey: outgoingKey),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.navigatorKey});

  final GlobalKey<NavigatorState> navigatorKey;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      body: Navigator(
        key: widget.navigatorKey,
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) {
              return Login(navigatorKey: widget.navigatorKey);
            },
          );
        },
      )

    );
  }
}
