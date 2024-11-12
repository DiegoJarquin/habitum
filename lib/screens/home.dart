import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:firebase_core/firebase_core.dart';

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

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('habitos').snapshots();
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();


  final _items = [
    SalomonBottomBarItem(icon: const Icon(Icons.home), title: const Text('Menu'))
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
              child: Icon(Icons.account_circle_rounded, size: (MediaQuery.of(context).size.width<550) ? MediaQuery.of(context).size.width*0.2 : MediaQuery.of(context).size.width*0.06,),
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
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomAppBar(
      //
      // ),
      bottomNavigationBar: SalomonBottomBar(
        items: _items,
      ),
      body: Center(



        child: Container(
          //TODO MAIN MENU
            child: Expanded(
              child: SingleChildScrollView(

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //GRID de BOTONES
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.9,
                      child: GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width*0.02, horizontal: MediaQuery.of(context).size.width*0.2),
                        childAspectRatio: (MediaQuery.of(context).size.width<500) ? 2 : 16/9,
                        crossAxisCount: 1,
                        crossAxisSpacing: MediaQuery.of(context).size.width*0.02,
                        mainAxisSpacing: MediaQuery.of(context).size.width*0.04,
                        children: <Widget>[

                          //PRIMER BOTON: Nuevo Reto
                          Container(
                            decoration:  BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),

                            ), // button width and height
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              child: Material(
                                shadowColor: Colors.grey,
                                color: Colors.amber.shade200, // button color
                                child: InkWell(
                                  splashColor: Colors.amberAccent, // splash color
                                  onTap: () {

                                  }, // button pressed
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.add_alarm_rounded), // icon
                                      Text("Nuevo Reto"), // text
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),


                          //SEGUNDO BOTON: Retos
                          Container(
                            decoration:  BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),

                            ), // button width and height
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              child: Material(
                                shadowColor: Colors.black54,
                                color: Colors.lightGreen, // button color
                                child: InkWell(
                                  splashColor: Colors.blueAccent, // splash color
                                  onTap: () {}, // button pressed
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.stars_rounded), // icon
                                      Text("Retos"), // text
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          //TERCER BOTON: Personal
                          Container(
                            decoration:  BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),

                            ), // button width and height
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              child: Material(
                                shadowColor: Colors.black,
                                color: Colors.orangeAccent.shade200, // button color
                                child: InkWell(
                                  splashColor: Colors.orange, // splash color
                                  onTap: () {}, // button pressed
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.calendar_month_rounded), // icon
                                      Text("Calendario"), // text
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),





                        ],
                      ),
                ),
                  ],
                ),
              ),
            )        ),

      ),




    );
  }



}
