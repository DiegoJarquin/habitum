import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habitum/screens/calendario.dart';
import 'package:habitum/screens/inicio.dart';
import 'package:habitum/screens/retos.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import '../firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Home> {



  FirebaseAuth auth = FirebaseAuth.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final pageController = PageController();
  final TextEditingController _textEditingController = TextEditingController();
  final tituloController = TextEditingController();
  final descripcionController = TextEditingController();
  final fechaInicialController = TextEditingController();
  final fechaFinalController = TextEditingController();
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  int _frecuencia = 0;
  DateTime? startDate;
  DateTime? endDate;
  bool isChecked = false;
  DateTime? createdDate;

  int _navIndex = 0;
  final _items = [
    SalomonBottomBarItem(icon: const Icon(Icons.home), title: const Text('Inicio')),
    SalomonBottomBarItem(icon: const Icon(Icons.stars_rounded), title: const Text('Retos'), selectedColor: Colors.lightGreen),
    SalomonBottomBarItem(icon: const Icon(Icons.calendar_month_rounded), title: const Text('Calendario'), selectedColor: Colors.orangeAccent),
  ];



  //settings de drawer
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }



  @override
  Widget build(BuildContext context) {
    final User? user = auth.currentUser;
    final uid = user?.uid;

    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('habitos').doc(uid).collection('habitos').orderBy('creacion',descending: true).snapshots();
    
    CollectionReference users = FirebaseFirestore.instance.collection('habitos').doc(uid).collection('habitos');

    Future<void> addReto() {

      return users
          .add({
        'titulo': (tituloController.text), // titulo del reto
        'descripcion': descripcionController.text, // descripcion del reto
        'fechaInicial': startDate, // Fecha inicial para comenzar el reto
        'fechaFinal': endDate, // Fecha final para terminar el reto
        'sinfin': isChecked, //reto infinito
        'frecuencia': _frecuencia, //frecuencia de repeticion
        'creacion': createdDate, //fecha de creacion
      })
          .then((value) => print("reto agregado"))
          .catchError((error) => print("Falla al agregar reto: $error"));
    }

    //TODO main menu para ver porcentaje de habitos completados y habitos no completados y mostrar los pendientes del dia
    //TODO retos mostrar todos (completados y no completados)
    //TODO calendario mostrar todos los habitos y retos en un calendario

    return Scaffold(
      key: _key,
      appBar: AppBar(

        toolbarHeight: (MediaQuery.of(context).size.width<550) ? MediaQuery.of(context).size.width*0.2 : MediaQuery.of(context).size.width*0.06,
        leading: Padding(
          padding: EdgeInsets.only(left: 30),
          child: Transform.scale(
            scale: (MediaQuery.of(context).size.width<550) ? MediaQuery.of(context).size.width*0.015 : MediaQuery.of(context).size.width*0.0055,
            child: IconButton(
              icon: Image.asset('assets/logo.png', fit: BoxFit.contain,),
              // padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.02,0, 0,0),
              onPressed: () {},
            ),
          ),
        ),

        // bottom: tabWidget(),


        backgroundColor: Theme.of(context).colorScheme.onInverseSurface,

        title: Text('HABITUM'),
      ),
      endDrawer: Drawer(
        width: (MediaQuery.of(context).size.width<550) ? MediaQuery.of(context).size.width*0.60 : MediaQuery.of(context).size.width*0.25,
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
              ),
              child: Column(
                children: [
                  Icon(Icons.account_circle_rounded, size: (MediaQuery.of(context).size.width<550) ? MediaQuery.of(context).size.width*0.2 : MediaQuery.of(context).size.width*0.06,),
                  Text(
                    user!.email.toString(),
                    style: GoogleFonts.roboto(
                      fontSize: (MediaQuery.of(context).size.width<550) ? MediaQuery.of(context).size.width*0.05 : MediaQuery.of(context).size.width*0.02,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.settings),
                  SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                  Text('Editar Perfil')
                ],
              ),
              selected: _selectedIndex == 0,
              onTap: () {
                // Update the state of the app
                _onItemTapped(0);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.notification_important_rounded),
                  SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                  Text('Notificaciones')
                ],
              ),
              selected: _selectedIndex == 1,
              onTap: () {
                // Update the state of the app
                _onItemTapped(1);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.support_agent_rounded),
                  SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                  Text('Soporte')
                ],
              ),
              selected: _selectedIndex == 2,
              onTap: () {
                // Update the state of the app
                _onItemTapped(2);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            // SizedBox(height: MediaQuery.of(context).size.width*0.02,),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.exit_to_app_rounded),
                  SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                  Text('Salir')
                ],
              ),
              selected: _selectedIndex == 3,
              onTap: () {
                // Update the state of the app
                _onItemTapped(3);
                // Then close the drawer
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (r) => r == null);

              },
            ),
          ],
        ),
      ),

      //barra inferior
      bottomNavigationBar: Card(

        elevation: 6,
        margin: const EdgeInsets.all(16),
        child: SalomonBottomBar(
          backgroundColor: Colors.transparent,
          items: _items,
          currentIndex: _navIndex,
          onTap: (int _index){
            setState(() {
              _navIndex = _index;
              pageController.jumpToPage(_index);
            });
          },
        ),
      ),
      body: PageView(
        controller: pageController,
        children: [
          Inicio(),
          Retos(uid: uid),
          Calendario(uid: uid,)
        ],
        onPageChanged: (page) {
          setState(() {
            _navIndex = page;
          });
        },
      )






    );
  }



}
