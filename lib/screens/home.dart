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
          Calendario()
        ],
        onPageChanged: (page) {
          setState(() {
            _navIndex = page;
          });
        },
      )

      // body: Center(
      //
      //
      //
      //   child: Container(
      //     //TODO MAIN MENU
      //       child: Expanded(
      //         child: SingleChildScrollView(
      //
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             crossAxisAlignment: CrossAxisAlignment.center,
      //             children: [
      //               Container(
      //
      //               ),
      //               Stack(
      //                 children: [
      //                   //listado de retos recientes
      //                   // SizedBox(
      //                   //   height: MediaQuery.of(context).size.height*0.6,
      //                   //   width: MediaQuery.of(context).size.width*1,
      //                   //   child: Expanded(
      //                   //     child: Container(
      //                   //       padding: EdgeInsets.symmetric(horizontal: MediaQuery.sizeOf(context).width*0.05, vertical: MediaQuery.of(context).size.height*0.01),
      //                   //       width: MediaQuery.sizeOf(context).width,
      //                   //       decoration:  BoxDecoration(
      //                   //         borderRadius: BorderRadius.all(Radius.circular(5)),
      //                   //       ), // button width and height
      //                   //       height: MediaQuery.sizeOf(context).height,
      //                   //       // color: Colors.white,
      //                   //       child: StreamBuilder<QuerySnapshot>(
      //                   //         stream: _usersStream,
      //                   //         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //                   //           if (snapshot.hasError) {
      //                   //             return const Text('Something went wrong');
      //                   //           }
      //                   //
      //                   //           if (snapshot.connectionState == ConnectionState.waiting) {
      //                   //             return Text("Loading");
      //                   //           }
      //                   //
      //                   //
      //                   //           return ListView(
      //                   //
      //                   //             clipBehavior: Clip.none,
      //                   //             children: snapshot.data!.docs.map((DocumentSnapshot document) {
      //                   //               Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
      //                   //
      //                   //               return ExpansionTileCard(
      //                   //                 baseColor: Theme.of(context).colorScheme.onInverseSurface,
      //                   //                 expandedColor: Theme.of(context).colorScheme.onInverseSurface.withBlue(200),
      //                   //                 expandedTextColor: Colors.black,
      //                   //                 initialPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.01),
      //                   //                 leading: ClipRRect(
      //                   //
      //                   //                   borderRadius: BorderRadius.circular(8.0), child: Icon(Icons.star),),
      //                   //                 // color: Colors.white,
      //                   //                 title: Text(data['titulo']),
      //                   //                 children: [
      //                   //                   const Divider(
      //                   //                     thickness: 1.0,
      //                   //                     height: 1.0,
      //                   //                   ),
      //                   //                   Align(
      //                   //                     alignment: Alignment.centerLeft,
      //                   //                     child: Padding(
      //                   //                       padding: const EdgeInsets.symmetric(
      //                   //                         horizontal: 16.0,
      //                   //                         vertical: 8.0,
      //                   //                       ),
      //                   //                       child: Text(data['descripcion'],
      //                   //                         style: Theme.of(context)
      //                   //                             .textTheme
      //                   //                             .bodyMedium!
      //                   //                             .copyWith(fontSize: 16),
      //                   //                       ),
      //                   //                     ),
      //                   //                   ),
      //                   //
      //                   //                   ButtonBar(
      //                   //                     alignment: MainAxisAlignment.spaceAround,
      //                   //                     buttonHeight: 52.0,
      //                   //                     buttonMinWidth: 90.0,
      //                   //                     children: <Widget>[
      //                   //                       TextButton(
      //                   //                         // style: flatButtonStyle,
      //                   //                         onPressed: () {
      //                   //                           // cardB.currentState?.expand();
      //                   //                         },
      //                   //                         child: const Column(
      //                   //                           children: <Widget>[
      //                   //                             Icon(Icons.border_color_outlined, color: Colors.indigoAccent,),
      //                   //                             Padding(
      //                   //                               padding: EdgeInsets.symmetric(vertical: 2.0),
      //                   //                             ),
      //                   //                             Text('Editar'),
      //                   //                           ],
      //                   //                         ),
      //                   //                       ),
      //                   //
      //                   //                       TextButton(
      //                   //                         // style: flatButtonStyle,
      //                   //                         onPressed: () {
      //                   //                           // currentState?.toggleExpansion();
      //                   //                         },
      //                   //                         child: const Column(
      //                   //                           children: <Widget>[
      //                   //                             Icon(Icons.delete_forever, color: Colors.redAccent,),
      //                   //                             Padding(
      //                   //                               padding: EdgeInsets.symmetric(vertical: 2.0),
      //                   //                             ),
      //                   //                             Text('Eliminar'),
      //                   //                           ],
      //                   //                         ),
      //                   //                       ),
      //                   //                     ],
      //                   //                   ),
      //                   //
      //                   //                 ],
      //                   //                 // child: ListTile(
      //                   //                 //   contentPadding: EdgeInsets.all(0),
      //                   //                 //
      //                   //                 //   leading: Image.network(data['imagen'], fit: BoxFit.fitWidth,),
      //                   //                 //   title: ,
      //                   //                 // ),
      //                   //               );
      //                   //             }).toList(),
      //                   //           );
      //                   //         },
      //                   //       ),
      //                   //     ),
      //                   //
      //                   //   ),
      //                   // ),
      //
      //                   //listado de retos recientes 5
      //                   SizedBox(
      //                     height: MediaQuery.of(context).size.height*0.6,
      //                     width: MediaQuery.of(context).size.width*1,
      //                     child: Expanded(
      //                       child: Container(
      //                         padding: EdgeInsets.symmetric(horizontal: MediaQuery.sizeOf(context).width*0.05, vertical: MediaQuery.of(context).size.height*0.01),
      //                         width: MediaQuery.sizeOf(context).width,
      //                         decoration:  BoxDecoration(
      //                           borderRadius: BorderRadius.all(Radius.circular(5)),
      //                         ), // button width and height
      //                         height: MediaQuery.sizeOf(context).height,
      //                         // color: Colors.white,
      //                         child: StreamBuilder<QuerySnapshot>(
      //                           stream: _usersStream,
      //                           builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //                             if (snapshot.hasError) {
      //                               return const Text('Something went wrong');
      //                             }
      //
      //                             if (snapshot.connectionState == ConnectionState.waiting) {
      //                               return Text("Loading");
      //                             }
      //                             final userSnapshot = snapshot.data?.docs;
      //                             if (userSnapshot!.isEmpty) {
      //
      //                               return const Text("no data");
      //                             }
      //
      //                             return ListView.builder(
      //                               itemCount: 5,
      //                               clipBehavior: Clip.none,
      //                               itemBuilder: (context, index){
      //                                 return ExpansionTileCard(
      //                                   baseColor: Theme.of(context).colorScheme.onInverseSurface,
      //                                   expandedColor: Theme.of(context).colorScheme.onInverseSurface.withBlue(200),
      //                                   expandedTextColor: Colors.black,
      //                                   initialPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.01),
      //                                   leading: ClipRRect(
      //
      //                                     borderRadius: BorderRadius.circular(8.0), child: Icon(Icons.star),),
      //                                   // color: Colors.white,
      //                                   title: Text(userSnapshot[index]['titulo']),
      //                                   children: [
      //                                     const Divider(
      //                                       thickness: 1.0,
      //                                       height: 1.0,
      //                                     ),
      //                                     Align(
      //                                       alignment: Alignment.centerLeft,
      //                                       child: Padding(
      //                                         padding: const EdgeInsets.symmetric(
      //                                           horizontal: 16.0,
      //                                           vertical: 8.0,
      //                                         ),
      //                                         child: Text(userSnapshot[index]['descripcion'],
      //                                           style: Theme.of(context)
      //                                               .textTheme
      //                                               .bodyMedium!
      //                                               .copyWith(fontSize: 16),
      //                                         ),
      //                                       ),
      //                                     ),
      //
      //                                     ButtonBar(
      //                                       alignment: MainAxisAlignment.spaceAround,
      //                                       buttonHeight: 52.0,
      //                                       buttonMinWidth: 90.0,
      //                                       children: <Widget>[
      //                                         TextButton(
      //                                           // style: flatButtonStyle,
      //                                           onPressed: () {
      //                                             // cardB.currentState?.expand();
      //                                           },
      //                                           child: const Column(
      //                                             children: <Widget>[
      //                                               Icon(Icons.border_color_outlined, color: Colors.indigoAccent,),
      //                                               Padding(
      //                                                 padding: EdgeInsets.symmetric(vertical: 2.0),
      //                                               ),
      //                                               Text('Editar'),
      //                                             ],
      //                                           ),
      //                                         ),
      //
      //                                         //eliminar reto
      //                                         TextButton(
      //                                           // style: flatButtonStyle,
      //                                           onPressed: () async {
      //                                             AlertDialog alert = AlertDialog(
      //                                               title: Text('Desea eliminar el reto?'),
      //                                               actions: [
      //                                                 InkWell(
      //                                                   child: Text('CANCELAR   '),
      //                                                   onTap: () {
      //
      //                                                     Navigator.of(context).pop();
      //
      //                                                   },
      //                                                 ),
      //                                                 InkWell(
      //                                                   child: Text('OK   '),
      //                                                   onTap: () async {
      //                                                     final navigator = Navigator.of(context);
      //                                                     try {
      //                                                       await users.doc(userSnapshot[index].id)
      //                                                           .delete();
      //                                                       navigator.pop();
      //                                                     }catch (e){
      //                                                       return null;
      //                                                     }
      //
      //                                                   },
      //                                                 ),
      //                                               ],
      //                                             );
      //                                             showDialog(
      //                                               context: context,
      //                                               builder: (BuildContext context) {
      //                                                 return alert;
      //                                               },
      //                                             );
      //
      //                                             // currentState?.toggleExpansion();
      //                                           },
      //                                           child: const Column(
      //                                             children: <Widget>[
      //                                               Icon(Icons.delete_forever, color: Colors.redAccent,),
      //                                               Padding(
      //                                                 padding: EdgeInsets.symmetric(vertical: 2.0),
      //                                               ),
      //                                               Text('Eliminar'),
      //                                             ],
      //                                           ),
      //                                         ),
      //                                       ],
      //                                     ),
      //
      //                                   ],
      //                                   // child: ListTile(
      //                                   //   contentPadding: EdgeInsets.all(0),
      //                                   //
      //                                   //   leading: Image.network(data['imagen'], fit: BoxFit.fitWidth,),
      //                                   //   title: ,
      //                                   // ),
      //                                 );
      //                               },
      //                             );
      //                           },
      //                         ),
      //                       ),
      //
      //                     ),
      //                   ),
      //
      //                 ],
      //               ),
      //
      //               //Boton para agregar retos
      //               Align(
      //                 alignment: Alignment.bottomRight,
      //                 child: Container(
      //                   padding: EdgeInsets.symmetric(horizontal: (MediaQuery.sizeOf(context).width<500) ? MediaQuery.sizeOf(context).width*0.05 : MediaQuery.sizeOf(context).width*0.05, vertical: MediaQuery.sizeOf(context).height*0.01),
      //                   child: ClipRRect(
      //                     borderRadius: BorderRadius.all(Radius.circular(16)),
      //                     child: Material(
      //                       elevation: 10,
      //                       shadowColor: Colors.black54,
      //                       color: Colors.amberAccent.shade100, // button color
      //                       child: InkWell(
      //                         splashColor: Colors.amberAccent, // splash color
      //                         onTap: () async {
      //                           return await showDialog(
      //                               context: context,
      //                               builder: (context) {
      //
      //                                 return StatefulBuilder(builder: (context, setState) {
      //                                   return AlertDialog(
      //                                     content: Form(
      //                                         key: _formKey,
      //                                         child: Column(
      //                                           mainAxisSize: MainAxisSize.min,
      //                                           children: [
      //                                             for (int i = 1; i <= 2; i++)
      //                                               ListTile(
      //                                                 title: Text(
      //                                                   i==1 ? 'Diario' : i== 2 ? 'Semanal' : "",
      //                                                   style: Theme.of(context).textTheme.titleSmall?.copyWith(color: i == 3 ? Colors.black38 : Colors.black),
      //                                                 ),
      //                                                 leading: Radio(
      //                                                   value: i,
      //                                                   groupValue: _frecuencia,
      //                                                   activeColor: Color(0xFF6200EE),
      //                                                   onChanged: i == 3 ? null : (int? value) {
      //                                                     setState(() {
      //                                                       _frecuencia = value!;
      //                                                       print(_frecuencia);
      //                                                     });
      //                                                   },
      //                                                 ),
      //                                               ),
      //                                             TextFormField(
      //                                               controller: tituloController,
      //                                               validator: (value) {
      //                                                 return value!.isNotEmpty ? null : "Agregar Nombre";
      //                                               },
      //                                               decoration:
      //                                               InputDecoration(hintText: "Título"),
      //                                             ),
      //                                             TextFormField(
      //                                               controller: descripcionController,
      //                                               validator: (value) {
      //                                                 return value!.isNotEmpty ? null : "Agregar Descripción";
      //                                               },
      //                                               decoration:
      //                                               InputDecoration(hintText: "Agregar Descripción"),
      //                                             ),
      //                                             const SizedBox(height: 20),
      //                                             Row(
      //                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                                               children: [
      //                                                 Text("Hábito sin fin"),
      //                                                 Checkbox(
      //                                                     value: isChecked,
      //                                                     onChanged: (checked) {
      //                                                       setState(() {
      //                                                         isChecked = checked!;
      //                                                       });
      //                                                     })
      //                                               ],
      //                                             ),
      //                                             const SizedBox(height: 20),
      //                                             Visibility(
      //                                               visible: !isChecked,
      //                                               child: FloatingActionButton(
      //                                                 onPressed: () {
      //                                                   showCustomDateRangePicker(
      //                                                     context,
      //                                                     dismissible: true,
      //                                                     minimumDate: DateTime.now().subtract(const Duration(days: 30)),
      //                                                     maximumDate: DateTime.now().add(const Duration(days: 30)),
      //                                                     endDate: endDate,
      //                                                     startDate: startDate,
      //                                                     backgroundColor: Colors.white,
      //                                                     primaryColor: Colors.green,
      //                                                     onApplyClick: (start, end) {
      //                                                       setState(() {
      //                                                         endDate = end;
      //                                                         startDate = start;
      //                                                       });
      //                                                     },
      //                                                     onCancelClick: () {
      //                                                       setState(() {
      //                                                         endDate = null;
      //                                                         startDate = null;
      //                                                       });
      //                                                     },
      //                                                   );
      //                                                 },
      //                                                 tooltip: 'Seleccionar Fechas',
      //                                                 child: const Icon(Icons.calendar_today_outlined, color: Colors.white),
      //                                               ),
      //
      //                                             ),
      //
      //
      //
      //
      //                                           ],
      //                                         )),
      //                                     title: Text('Agregar Reto'),
      //                                     actions: <Widget>[
      //                                       InkWell(
      //                                         child: Text('CANCELAR   '),
      //                                         onTap: () {
      //
      //                                           Navigator.of(context).pop();
      //
      //                                         },
      //                                       ),
      //                                       InkWell(
      //                                         child: Text('OK   '),
      //                                         onTap: () async {
      //                                           if (_formKey.currentState!.validate()) {
      //                                             createdDate = new DateTime.now();
      //                                             var imageName = DateTime.now().millisecondsSinceEpoch.toString();
      //
      //                                             await addReto();
      //
      //                                             Navigator.of(context).pop();
      //
      //                                           }
      //                                         },
      //                                       ),
      //                                     ],
      //                                   );
      //                                 });
      //                               });
      //                         }, // button pressed
      //                         child:
      //                         const SizedBox(
      //                           width: 50,
      //                           height: 50,
      //                           child: Column(
      //                             mainAxisAlignment: MainAxisAlignment.center,
      //                             children: <Widget>[
      //                               Icon(Icons.add_circle_outline_rounded), // icon
      //                               // Text("Agregar", style: TextStyle(color: Colors.white),), // text
      //                             ],
      //                           ),
      //                         ),
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //
      //
      //
      //
      //
      //               //GRID de BOTONES
      //           //     SizedBox(
      //           //       height: MediaQuery.of(context).size.height*0.9,
      //           //       child: GridView.count(
      //           //         physics: const NeverScrollableScrollPhysics(),
      //           //         padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width*0.02, horizontal: MediaQuery.of(context).size.width*0.2),
      //           //         childAspectRatio: (MediaQuery.of(context).size.width<500) ? 2 : 16/9,
      //           //         crossAxisCount: 1,
      //           //         crossAxisSpacing: MediaQuery.of(context).size.width*0.02,
      //           //         mainAxisSpacing: MediaQuery.of(context).size.width*0.04,
      //           //         children: <Widget>[
      //           //
      //           //           //PRIMER BOTON: Nuevo Reto
      //           //           Container(
      //           //             decoration:  BoxDecoration(
      //           //               borderRadius: BorderRadius.all(Radius.circular(10)),
      //           //
      //           //             ), // button width and height
      //           //             child: ClipRRect(
      //           //               borderRadius: BorderRadius.all(Radius.circular(15)),
      //           //               child: Material(
      //           //                 shadowColor: Colors.grey,
      //           //                 color: Colors.amber.shade200, // button color
      //           //                 child: InkWell(
      //           //                   splashColor: Colors.amberAccent, // splash color
      //           //                   onTap: () {
      //           //
      //           //                   }, // button pressed
      //           //                   child: Column(
      //           //                     mainAxisAlignment: MainAxisAlignment.center,
      //           //                     children: <Widget>[
      //           //                       Icon(Icons.add_alarm_rounded), // icon
      //           //                       Text("Nuevo Reto"), // text
      //           //                     ],
      //           //                   ),
      //           //                 ),
      //           //               ),
      //           //             ),
      //           //           ),
      //           //
      //           //
      //           //           //SEGUNDO BOTON: Retos
      //           //           Container(
      //           //             decoration:  BoxDecoration(
      //           //               borderRadius: BorderRadius.all(Radius.circular(10)),
      //           //
      //           //             ), // button width and height
      //           //             child: ClipRRect(
      //           //               borderRadius: BorderRadius.all(Radius.circular(15)),
      //           //               child: Material(
      //           //                 shadowColor: Colors.black54,
      //           //                 color: Colors.lightGreen, // button color
      //           //                 child: InkWell(
      //           //                   splashColor: Colors.blueAccent, // splash color
      //           //                   onTap: () {}, // button pressed
      //           //                   child: Column(
      //           //                     mainAxisAlignment: MainAxisAlignment.center,
      //           //                     children: <Widget>[
      //           //                       Icon(Icons.stars_rounded), // icon
      //           //                       Text("Retos"), // text
      //           //                     ],
      //           //                   ),
      //           //                 ),
      //           //               ),
      //           //             ),
      //           //           ),
      //           //
      //           //           //TERCER BOTON: Personal
      //           //           Container(
      //           //             decoration:  BoxDecoration(
      //           //               borderRadius: BorderRadius.all(Radius.circular(10)),
      //           //
      //           //             ), // button width and height
      //           //             child: ClipRRect(
      //           //               borderRadius: BorderRadius.all(Radius.circular(15)),
      //           //               child: Material(
      //           //                 shadowColor: Colors.black,
      //           //                 color: Colors.orangeAccent.shade200, // button color
      //           //                 child: InkWell(
      //           //                   splashColor: Colors.orange, // splash color
      //           //                   onTap: () {}, // button pressed
      //           //                   child: Column(
      //           //                     mainAxisAlignment: MainAxisAlignment.center,
      //           //                     children: <Widget>[
      //           //                       Icon(Icons.calendar_month_rounded), // icon
      //           //                       Text("Calendario"), // text
      //           //                     ],
      //           //                   ),
      //           //                 ),
      //           //               ),
      //           //             ),
      //           //           ),
      //           //
      //           //
      //           //
      //           //
      //           //
      //           //         ],
      //           //       ),
      //           // ),
      //             ],
      //           ),
      //         ),
      //       )        ),
      //
      // ),




    );
  }



}
