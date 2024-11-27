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

    CollectionReference users = FirebaseFirestore.instance.collection('habitos').doc(uid).collection('habitos');



    return Scaffold(

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






                    // GRID de BOTONES
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
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: _usersStream,
                                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                                    double completados = 0;
                                    snapshot.data!.docs.forEach((element) {
                                      if(element['completado'] == true){
                                        completados++;
                                      }
                                    });


                                    print('Completados: ' + completados.toString() + ' / ' + snapshot.data!.docs.length.toString());
                                    return SfRadialGauge(axes: <RadialAxis>[
                                      RadialAxis(
                                        minimum: 0,
                                        maximum: snapshot.data!.docs.length.toDouble(),
                                        showLabels: false,
                                        showTicks: false,
                                        axisLineStyle: AxisLineStyle(
                                          thickness: 0.2,
                                          color: Color.fromARGB(30, 0, 169, 181),
                                          thicknessUnit: GaugeSizeUnit.factor,
                                        ),
                                        pointers: <GaugePointer>[
                                          RangePointer(
                                            value: completados,
                                            width: 0.2,
                                            sizeUnit: GaugeSizeUnit.factor,
                                          )
                                        ],
                                        annotations: <GaugeAnnotation>[
                                          GaugeAnnotation(
                                              positionFactor: 0.1,
                                              angle: 90,
                                              widget: Text(
                                                completados.toStringAsFixed(0) + ' / ' + snapshot.data!.docs.length.toString(),
                                                style: TextStyle(fontSize: 11),
                                              ))
                                        ]),



                                    ]);


                                },

                                )

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
