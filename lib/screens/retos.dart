import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:habitum/screens/retoscompletos.dart';

class Retos extends StatefulWidget {
  const Retos({super.key, required this.uid});

  final String? uid;
  @override
  State<Retos> createState() => _RetosState();
}

class _RetosState extends State<Retos> {

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
  int difference = 0;
  late var colorValues = [
  ];




  bool _completos = false;

  @override
  Widget build(BuildContext context) {
    final uid = widget.uid;
    final Stream<QuerySnapshot> _usersStreamFalse = FirebaseFirestore.instance.collection('habitos').doc(uid).collection('habitos').orderBy('creacion', descending: false).snapshots();
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('habitos').doc(uid).collection('habitos').where('completado', isEqualTo: true).snapshots();
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
        'completado': false, //reto completado
        'completadoCounter': 0, //contador de retos completados
        'diasCounter': difference, //dias de duracion del reto
        'color': colorValues,
      })
          .then((value) => print("reto agregado"))
          .catchError((error) => print("Falla al agregar reto: $error"));
    }

    Future<void> completarReto(String docId) {

      return users
          .doc(docId).update({
        'completadoCounter': FieldValue.increment(1),
        'completado': true, //reto completado
      })
          .then((value) => print("reto completo"))
          .catchError((error) => print("Falla al agregar reto: $error"));
    }

    Future<void> descompletarReto(String docId) {

      return users
          .doc(docId).update({
        'completadoCounter': FieldValue.increment(-1),
        'completado': false, //reto descompleto
      })
          .then((value) => print("reto descompleto"))
          .catchError((error) => print("Falla al agregar reto: $error"));
    }


    return Scaffold(
      body: Center(



        child: Container(

            child: Stack(
              alignment: Alignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  //TODO retos
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.05,
                      width: MediaQuery.of(context).size.width*0.5,
                      child: const Text('Retos', textAlign: TextAlign.center, style: TextStyle(fontSize: 20),),
                    ),
                    Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: (_completos) ? _usersStream : _usersStreamFalse,
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return const Text('Something went wrong');
                            }

                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Text("Loading");
                            }


                            return ListView(
                              shrinkWrap: true,

                              // clipBehavior: Clip.none,
                              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;




                                return ExpansionTileCard(
                                  baseColor: Color.fromARGB(
                                    255,
                                    data['color'][1],
                                    data['color'][2],
                                    data['color'][3],
                                  ),
                                  // baseColor: Theme.of(context).colorScheme.onInverseSurface,
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
                                        }else{
                                          AlertDialog alert = AlertDialog(
                                            title: const Text('Desea descompletar el reto?'),
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
                                                  // final navigator = Navigator.of(context);
                                                  try {
                                                    await descompletarReto(document.id);
                                                  }catch (e){
                                                    return null;
                                                  }
                                                  Navigator.of(context).pop();

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
                                          (data['frecuencia']==1) ? 'Diario' : 'Semanal', style: TextStyle(color: data['frecuencia']==1 ? Colors.indigoAccent : Colors.indigoAccent),),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0,
                                          vertical: 8.0,
                                        ),
                                        child: LinearProgressIndicator(
                                          value: (data['sinfin'])? 0 : (data['completadoCounter'] / data['diasCounter']), // progress
                                          borderRadius: BorderRadius.all(Radius.circular(8)),
                                          backgroundColor: Colors.grey[300],
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreen),
                                          minHeight: 10.0, // Minimum height of the line
                                        ),
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
                                  // trailing: Container(
                                  //   color: Color.fromARGB(
                                  //     255,
                                  //     data['color'][1],
                                  //     data['color'][2],
                                  //     data['color'][3],
                                  //   ),
                                  // ),

                                );
                              }).toList(),
                            );
                          },
                        ),
                    ),



                  ],
                ),

                //TODO Botones
                Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        //TODO BOTON VER COMPLETOS
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: (MediaQuery.sizeOf(context).width<500) ? MediaQuery.sizeOf(context).width*0.05 : MediaQuery.sizeOf(context).width*0.05, vertical: MediaQuery.sizeOf(context).height*0.01),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(16)),
                              child: Material(
                                elevation: 10,
                                shadowColor: Colors.black54,
                                color: (_completos) ? Colors.orangeAccent.shade100 : Colors.lightGreen.shade100, // button color
                                child: InkWell(
                                  splashColor: Colors.amberAccent, // splash color
                                  onTap: () {
                                    setState(() {
                                      _completos = !_completos;

                                    });
                                    // Navigator.of(context).push(MaterialPageRoute(builder: (context) => RetosCompletos(uid: uid)));
                                  }, // button pressed
                                  child:
                                  SizedBox(
                                    width: 100,
                                    height: 50,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[ // icon
                                        (_completos) ? Text("Ver Todos", style: TextStyle(),) : Text("Ver\nCompletos", textAlign: TextAlign.center,style: TextStyle(),), // text
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),


                        //TODO BOTON AGREGAR RETOS
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: (MediaQuery.sizeOf(context).width<500) ? MediaQuery.sizeOf(context).width*0.05 : MediaQuery.sizeOf(context).width*0.05, vertical: MediaQuery.sizeOf(context).height*0.01),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(16)),
                              child: Material(
                                elevation: 10,
                                shadowColor: Colors.black54,
                                color: Colors.amberAccent.shade100, // button color
                                child: InkWell(
                                  splashColor: Colors.amberAccent, // splash color
                                  onTap: () async {
                                    return await showDialog(
                                        context: context,
                                        builder: (context) {

                                          return StatefulBuilder(builder: (context, setState) {
                                            return AlertDialog(
                                              content: Form(
                                                  key: _formKey,
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      for (int i = 1; i <= 2; i++)
                                                        ListTile(
                                                          title: Text(
                                                            i==1 ? 'Diario' : i== 2 ? 'Semanal' : "",
                                                            style: Theme.of(context).textTheme.titleSmall?.copyWith(color: i == 3 ? Colors.black38 : Colors.black),
                                                          ),
                                                          leading: Radio(
                                                            value: i,
                                                            groupValue: _frecuencia,
                                                            activeColor: const Color(0xFF6200EE),
                                                            onChanged: i == 3 ? null : (int? value) {
                                                              setState(() {
                                                                _frecuencia = value!;

                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      TextFormField(
                                                        controller: tituloController,
                                                        validator: (value) {
                                                          return value!.isNotEmpty ? null : "Agregar Nombre";
                                                        },
                                                        decoration:
                                                        const InputDecoration(hintText: "Título"),
                                                      ),
                                                      TextFormField(
                                                        controller: descripcionController,
                                                        validator: (value) {
                                                          return value!.isNotEmpty ? null : "Agregar Descripción";
                                                        },
                                                        decoration:
                                                        const InputDecoration(hintText: "Agregar Descripción"),
                                                      ),
                                                      const SizedBox(height: 20),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          const Text("Hábito sin fin"),
                                                          Checkbox(
                                                              value: isChecked,
                                                              onChanged: (checked) {
                                                                setState(() {
                                                                  isChecked = checked!;
                                                                });
                                                              })
                                                        ],
                                                      ),
                                                      const SizedBox(height: 20),
                                                      Visibility(
                                                        visible: !isChecked,
                                                        child: FloatingActionButton(
                                                          onPressed: () {
                                                            showCustomDateRangePicker(
                                                              context,
                                                              dismissible: true,
                                                              minimumDate: DateTime.now(),
                                                              maximumDate: DateTime.now().add(const Duration(days: 30)),
                                                              endDate: endDate,
                                                              startDate: startDate,
                                                              backgroundColor: Colors.white,
                                                              primaryColor: Colors.green,
                                                              onApplyClick: (start, end) {
                                                                setState(() {
                                                                  endDate = end;
                                                                  startDate = start;

                                                                  if(endDate!=null&&startDate!=null){
                                                                    difference = endDate!.difference(startDate!).inDays;
                                                                  }

                                                                });
                                                              },
                                                              onCancelClick: () {
                                                                setState(() {
                                                                  endDate = null;
                                                                  startDate = null;
                                                                });
                                                              },
                                                            );
                                                          },
                                                          tooltip: 'Seleccionar Fechas',
                                                          child: const Icon(Icons.calendar_today_outlined, color: Colors.white),
                                                        ),

                                                      ),

                                                      (endDate!=null&&!isChecked) ? Text(DateFormat('dd/MM/yyyy').format(startDate!)+" - "+DateFormat('dd/MM/yyyy').format(endDate!)) : Text(""),




                                                    ],
                                                  )),
                                              title: const Text('Agregar Reto'),
                                              actions: <Widget>[
                                                InkWell(
                                                  child: const Text('CANCELAR   ', style: TextStyle(fontWeight: FontWeight.bold),),
                                                  onTap: () {

                                                    Navigator.of(context).pop();

                                                  },
                                                ),
                                                InkWell(
                                                  child: const Text('OK   ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                  onTap: () async {
                                                    if (_formKey.currentState!.validate()&&isChecked) {


                                                      if(isChecked){
                                                        endDate = null;
                                                        startDate = null;
                                                      }
                                                      createdDate = new DateTime.now();
                                                      final randomColor = Color.fromARGB(
                                                        255,
                                                        Random().nextInt(50) + 205,
                                                        Random().nextInt(50) + 205,
                                                        Random().nextInt(50) + 205,
                                                      );
                                                      colorValues = [
                                                        randomColor.alpha,
                                                        randomColor.red,
                                                        randomColor.green,
                                                        randomColor.blue
                                                      ];

                                                      await addReto();

                                                      Navigator.of(context).pop();

                                                    }else if(_formKey.currentState!.validate()&&endDate!=null){
                                                      createdDate = new DateTime.now();
                                                      final randomColor = Color.fromARGB(
                                                        255,
                                                        Random().nextInt(50) + 205,
                                                        Random().nextInt(50) + 205,
                                                        Random().nextInt(50) + 205,
                                                      );
                                                      colorValues = [
                                                        randomColor.alpha,
                                                        randomColor.red,
                                                        randomColor.green,
                                                        randomColor.blue
                                                      ];

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
                      ],
                    ),
                    //listado de los retos agregados


                  ],
                ),

                //Boton para agregar retos







              ],
            ),       ),

      ),





    );
  }
}