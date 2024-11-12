import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/cupertino.dart';
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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _textEditingController = TextEditingController();
  final tituloController = TextEditingController();
  final descripcionController = TextEditingController();
  final fechaInicialController = TextEditingController();
  final fechaFinalController = TextEditingController();
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();


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

    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('habitos').doc(uid).collection('habitos').snapshots();


    CollectionReference users = FirebaseFirestore.instance.collection('habitos').doc(uid).collection('habitos');

    Future<void> addReto() {

      // Call the user's CollectionReference to add new Inventory.
      return users
          .add({
        'titulo': (tituloController.text), // titulo del reto
        'descripcion': descripcionController.text, // descripcion del reto
        'fechaInicial': fechaInicialController.text, // Fecha inicial para comenzar el reto
        'fechaFinal': fechaFinalController.text, // Fecha final para terminar el reto
      })
          .then((value) => print("reto agregado"))
          .catchError((error) => print("Falla al agregar reto: $error"));
    }


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

      //barra inferior
      bottomNavigationBar: Card(
        elevation: 6,
        margin: const EdgeInsets.all(16),
        child: SalomonBottomBar(
          items: _items,
        ),
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
                    Container(

                    ),
                    Stack(
                      children: [
                        //listado de retos recientes
                        SizedBox(
                          height: MediaQuery.of(context).size.height*0.6,
                          width: MediaQuery.of(context).size.width*1,
                          child: Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: MediaQuery.sizeOf(context).width*0.05, vertical: MediaQuery.of(context).size.height*0.01),
                              width: MediaQuery.sizeOf(context).width,
                              decoration:  BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                              ), // button width and height
                              height: MediaQuery.sizeOf(context).height,
                              // color: Colors.white,
                              child: StreamBuilder<QuerySnapshot>(
                                stream: _usersStream,
                                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return const Text('Something went wrong');
                                  }

                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Text("Loading");
                                  }


                                  return ListView(
                                    clipBehavior: Clip.none,
                                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

                                      return ExpansionTileCard(
                                        baseColor: Theme.of(context).colorScheme.onInverseSurface,
                                        expandedColor: Colors.lightGreen.shade100,
                                        expandedTextColor: Colors.black,
                                        initialPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.01),
                                        leading: ClipRRect(

                                          borderRadius: BorderRadius.circular(8.0), child: Icon(Icons.star),),
                                        // color: Colors.white,
                                        title: Text(data['titulo']),
                                        children: [
                                          const Divider(
                                            thickness: 1.0,
                                            height: 1.0,
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                                vertical: 8.0,
                                              ),
                                              child: Text(data['descripcion'],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(fontSize: 16),
                                              ),
                                            ),
                                          ),

                                          ButtonBar(
                                            alignment: MainAxisAlignment.spaceAround,
                                            buttonHeight: 52.0,
                                            buttonMinWidth: 90.0,
                                            children: <Widget>[
                                              TextButton(
                                                // style: flatButtonStyle,
                                                onPressed: () {
                                                  // cardB.currentState?.expand();
                                                },
                                                child: const Column(
                                                  children: <Widget>[
                                                    Icon(Icons.border_color_outlined, color: Colors.blueAccent,),
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(vertical: 2.0),
                                                    ),
                                                    Text('Editar'),
                                                  ],
                                                ),
                                              ),

                                              TextButton(
                                                // style: flatButtonStyle,
                                                onPressed: () {
                                                  // currentState?.toggleExpansion();
                                                },
                                                child: const Column(
                                                  children: <Widget>[
                                                    Icon(Icons.delete_forever, color: Colors.redAccent,),
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(vertical: 2.0),
                                                    ),
                                                    Text('Eliminar'),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),

                                        ],
                                        // child: ListTile(
                                        //   contentPadding: EdgeInsets.all(0),
                                        //
                                        //   leading: Image.network(data['imagen'], fit: BoxFit.fitWidth,),
                                        //   title: ,
                                        // ),
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                            ),

                          ),
                        ),

                      ],
                    ),

                    //Boton para agregar retos
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: (MediaQuery.sizeOf(context).width<500) ? MediaQuery.sizeOf(context).width*0.05 : MediaQuery.sizeOf(context).width*0.05, vertical: MediaQuery.sizeOf(context).height*0.01),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          child: Material(
                            shadowColor: Colors.black54,
                            color: Colors.amberAccent, // button color
                            child: InkWell(
                              splashColor: Colors.amberAccent, // splash color
                              onTap: () async {
                                return await showDialog(
                                    context: context,
                                    builder: (context) {
                                      bool? isChecked = false;
                                      return StatefulBuilder(builder: (context, setState) {
                                        return AlertDialog(
                                          content: Form(
                                              key: _formKey,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [

                                                  TextFormField(
                                                    controller: tituloController,
                                                    validator: (value) {
                                                      return value!.isNotEmpty ? null : "Agregar Nombre";
                                                    },
                                                    decoration:
                                                    InputDecoration(hintText: "Agregar Nombre"),
                                                  ),
                                                  TextFormField(
                                                    controller: descripcionController,
                                                    validator: (value) {
                                                      return value!.isNotEmpty ? null : "Agregar Descripción";
                                                    },
                                                    decoration:
                                                    InputDecoration(hintText: "Agregar Descripción"),
                                                  ),

                                                  // TextFormField(
                                                  //   controller: imagenController,
                                                  //   validator: (value) {
                                                  //     return value!.isNotEmpty ? null : "Agregar Link de Imagen";
                                                  //   },
                                                  //   decoration:
                                                  //   InputDecoration(hintText: "Agregar Link de Imagen"),
                                                  // ),
                                                  // ValueListenableBuilder(
                                                  //     valueListenable: _image,
                                                  //     builder: builder
                                                  // ),


                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text("Choice Box"),
                                                      Checkbox(
                                                          value: isChecked,
                                                          onChanged: (checked) {
                                                            setState(() {
                                                              isChecked = checked;
                                                            });
                                                          })
                                                    ],
                                                  )
                                                ],
                                              )),
                                          title: Text('Agregar Inventario'),
                                          actions: <Widget>[
                                            InkWell(
                                              child: Text('CANCELAR   '),
                                              onTap: () {

                                                Navigator.of(context).pop();

                                              },
                                            ),
                                            InkWell(
                                              child: Text('OK   '),
                                              onTap: () async {
                                                if (_formKey.currentState!.validate()) {
                                                  var imageName = DateTime.now().millisecondsSinceEpoch.toString();

                                                  await addReto();

                                                  Navigator.of(context).pop();

                                                }
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                    });
                              }, // button pressed
                              child:
                              const SizedBox(
                                width: 50,
                                height: 50,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.add_circle_outline_rounded), // icon
                                    // Text("Agregar", style: TextStyle(color: Colors.white),), // text
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    



                    //GRID de BOTONES
                //     SizedBox(
                //       height: MediaQuery.of(context).size.height*0.9,
                //       child: GridView.count(
                //         physics: const NeverScrollableScrollPhysics(),
                //         padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width*0.02, horizontal: MediaQuery.of(context).size.width*0.2),
                //         childAspectRatio: (MediaQuery.of(context).size.width<500) ? 2 : 16/9,
                //         crossAxisCount: 1,
                //         crossAxisSpacing: MediaQuery.of(context).size.width*0.02,
                //         mainAxisSpacing: MediaQuery.of(context).size.width*0.04,
                //         children: <Widget>[
                //
                //           //PRIMER BOTON: Nuevo Reto
                //           Container(
                //             decoration:  BoxDecoration(
                //               borderRadius: BorderRadius.all(Radius.circular(10)),
                //
                //             ), // button width and height
                //             child: ClipRRect(
                //               borderRadius: BorderRadius.all(Radius.circular(15)),
                //               child: Material(
                //                 shadowColor: Colors.grey,
                //                 color: Colors.amber.shade200, // button color
                //                 child: InkWell(
                //                   splashColor: Colors.amberAccent, // splash color
                //                   onTap: () {
                //
                //                   }, // button pressed
                //                   child: Column(
                //                     mainAxisAlignment: MainAxisAlignment.center,
                //                     children: <Widget>[
                //                       Icon(Icons.add_alarm_rounded), // icon
                //                       Text("Nuevo Reto"), // text
                //                     ],
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           ),
                //
                //
                //           //SEGUNDO BOTON: Retos
                //           Container(
                //             decoration:  BoxDecoration(
                //               borderRadius: BorderRadius.all(Radius.circular(10)),
                //
                //             ), // button width and height
                //             child: ClipRRect(
                //               borderRadius: BorderRadius.all(Radius.circular(15)),
                //               child: Material(
                //                 shadowColor: Colors.black54,
                //                 color: Colors.lightGreen, // button color
                //                 child: InkWell(
                //                   splashColor: Colors.blueAccent, // splash color
                //                   onTap: () {}, // button pressed
                //                   child: Column(
                //                     mainAxisAlignment: MainAxisAlignment.center,
                //                     children: <Widget>[
                //                       Icon(Icons.stars_rounded), // icon
                //                       Text("Retos"), // text
                //                     ],
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           ),
                //
                //           //TERCER BOTON: Personal
                //           Container(
                //             decoration:  BoxDecoration(
                //               borderRadius: BorderRadius.all(Radius.circular(10)),
                //
                //             ), // button width and height
                //             child: ClipRRect(
                //               borderRadius: BorderRadius.all(Radius.circular(15)),
                //               child: Material(
                //                 shadowColor: Colors.black,
                //                 color: Colors.orangeAccent.shade200, // button color
                //                 child: InkWell(
                //                   splashColor: Colors.orange, // splash color
                //                   onTap: () {}, // button pressed
                //                   child: Column(
                //                     mainAxisAlignment: MainAxisAlignment.center,
                //                     children: <Widget>[
                //                       Icon(Icons.calendar_month_rounded), // icon
                //                       Text("Calendario"), // text
                //                     ],
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           ),
                //
                //
                //
                //
                //
                //         ],
                //       ),
                // ),
                  ],
                ),
              ),
            )        ),

      ),




    );
  }



}
