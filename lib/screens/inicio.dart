import 'dart:ffi';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habitum/screens/retos.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import '../firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';



class Inicio extends StatefulWidget {


  @override
  State<Inicio> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Inicio> {

  FirebaseAuth auth = FirebaseAuth.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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


  @override
  Widget build(BuildContext context) {
    final User? user = auth.currentUser;
    final uid = user?.uid;

    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('habitos').doc(uid).collection('habitos').orderBy('creacion',descending: true).snapshots();
    final Stream<QuerySnapshot> _usersStreamFalse = FirebaseFirestore.instance.collection('habitos').doc(uid).collection('habitos').where('completado', isEqualTo: false).snapshots();

    CollectionReference users = FirebaseFirestore.instance.collection('habitos').doc(uid).collection('habitos');

    Future<void> completarReto(String docId) {

      return users
          .doc(docId).update({
        'completadoCounter': FieldValue.increment(1),
        'completado': true, //reto completado
      })
          .then((value) => print("reto completo"))
          .catchError((error) => print("Falla al agregar reto: $error"));
    }


    return Scaffold(

      body: Center(



        child: Expanded(
          child: SingleChildScrollView(

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(

                ),






                // Cantidad de retos completados
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.3,
                  child: Container(
                      decoration:  BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),

                      ), // button width and height
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _usersStream,
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                          double completados = 0;
                          snapshot.data!.docs.forEach((element) {
                            if(element['completado'] == true){
                              completados++;
                            }
                          });

                          // print('Completados: ' + completados.toString() + ' / ' + snapshot.data!.docs.length.toString());
                          return SfRadialGauge(
                              axes: <RadialAxis>[
                                RadialAxis(
                                    minimum: 0,
                                    maximum: (snapshot.data!.docs.isNotEmpty) ? snapshot.data!.docs.length.toDouble() : 1,
                                    showLabels: false,
                                    showTicks: false,
                                    axisLineStyle: const AxisLineStyle(
                                      thickness: 0.2,
                                      color: Color.fromARGB(30, 0, 169, 181),
                                      thicknessUnit: GaugeSizeUnit.factor,
                                    ),
                                    pointers: <GaugePointer>[
                                      RangePointer(
                                        color: Colors.lightGreen,
                                        value: completados,
                                        width: 0.2,
                                        sizeUnit: GaugeSizeUnit.factor,
                                      )
                                    ],
                                    annotations: <GaugeAnnotation>[
                                      GaugeAnnotation(
                                        verticalAlignment: GaugeAlignment.center,
                                        horizontalAlignment: GaugeAlignment.center,
                                        positionFactor: 0.1,
                                        angle: 90,
                                        widget: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                textAlign: TextAlign.center,
                                                completados.toStringAsFixed(0) + ' / ' + snapshot.data!.docs.length.toString(),
                                                style: const TextStyle(fontSize: 15),
                                              ),
                                              const Text(
                                                textAlign: TextAlign.center,
                                                'Retos\nCompletados',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ]
                                        ),
                                      )
                                    ]),



                              ]);


                        },

                      )

                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.5,
                  child: Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.5,
                  child: Text('Retos\nPendientes', textAlign: TextAlign.center, style: TextStyle(fontSize: 20),),
                ),
                // LISTA DE RETOS Sin Completar
                SizedBox(
                  // height: MediaQuery.of(context).size.height*0.6,
                  // width: MediaQuery.of(context).size.width*1,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height*0.6,
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.sizeOf(context).width*0.05, vertical: MediaQuery.of(context).size.height*0.01),
                      width: MediaQuery.sizeOf(context).width,
                      decoration:  const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ), // button width and height
                      height: MediaQuery.sizeOf(context).height,
                      // color: Colors.white,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _usersStreamFalse,
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Something went wrong');
                          }

                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Text("Loading");
                          }


                          return ListView(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),

                            clipBehavior: Clip.none,
                            children: snapshot.data!.docs.map((DocumentSnapshot document) {
                              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

                              return ExpansionTileCard(
                                baseColor: Theme.of(context).colorScheme.onInverseSurface,
                                expandedColor: Theme.of(context).colorScheme.onInverseSurface.withBlue(200),
                                expandedTextColor: Colors.black,
                                initialPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.01),
                                leading: ClipRRect(

                                  borderRadius: BorderRadius.circular(8.0),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(8.0),
                                    splashColor: Colors.amberAccent, // splash color
                                    onTap: () async {
                                      if(data['completado'] == false){
                                        await completarReto(document.id);
                                      }

                                    }, // button pressed
                                    child:
                                    SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          (data['completado']) ? Icon(Icons.star, color: Colors.amber,) : Icon(Icons.star), // icon
                                          // Text("Agregar", style: TextStyle(color: Colors.white),), // text
                                        ],
                                      ),
                                    ),
                                  ),

                                ),
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
                                      child: Text(
                                        (data['frecuencia']==1) ? 'Diario' : 'Semanal', style: TextStyle(color: data['frecuencia']==1 ? Colors.green : Colors.red),),
                                    ),
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
                                            Icon(Icons.border_color_outlined, color: Colors.indigoAccent,),
                                            Padding(
                                              padding: EdgeInsets.symmetric(vertical: 2.0),
                                            ),
                                            Text('Editar'),
                                          ],
                                        ),
                                      ),

                                      TextButton(
                                        // style: flatButtonStyle,
                                        onPressed: () async {
                                          AlertDialog alert = AlertDialog(
                                            title: const Text('Desea eliminar el reto?'),
                                            actions: [
                                              InkWell(
                                                child: const Text('CANCELAR   '),
                                                onTap: () {

                                                  Navigator.of(context).pop();

                                                },
                                              ),
                                              InkWell(
                                                child: const Text('OK   '),
                                                onTap: () async {
                                                  final navigator = Navigator.of(context);
                                                  try {
                                                    await users.doc(document.id)
                                                        .delete();
                                                    navigator.pop();
                                                  }catch (e){
                                                    return null;
                                                  }

                                                },
                                              ),
                                            ],
                                          );
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return alert;
                                            },
                                          );

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
          ),
        )

      ),




    );
  }



}
