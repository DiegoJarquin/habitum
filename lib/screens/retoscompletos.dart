import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RetosCompletos extends StatefulWidget {
  const RetosCompletos({super.key, required this.uid});

  final String? uid;
  @override
  State<RetosCompletos> createState() => _RetosState();
}

class _RetosState extends State<RetosCompletos> {

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

    final Stream<QuerySnapshot> _usersStreamFalse = FirebaseFirestore.instance.collection('habitos').doc(widget.uid).collection('habitos').where('completado', isEqualTo: false).snapshots();
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('habitos').doc(widget.uid).collection('habitos').where('completado', isEqualTo: true).snapshots();
    CollectionReference users = FirebaseFirestore.instance.collection('habitos').doc(widget.uid).collection('habitos');

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
      })
          .then((value) => print("reto agregado"))
          .catchError((error) => print("Falla al agregar reto: $error"));
    }

    Future<void> completarReto(String docId) {

      return users
          .doc(docId).update({
        'completado': true, //reto completado
      })
          .then((value) => print("reto completo"))
          .catchError((error) => print("Falla al agregar reto: $error"));
    }

    Future<void> descompletarReto(String docId) {

      return users
          .doc(docId).update({
        'completado': false, //reto descompleto
      })
          .then((value) => print("reto descompleto"))
          .catchError((error) => print("Falla al agregar reto: $error"));
    }


    return Scaffold(
      body: Center(



        child: Container(
          //TODO retos completados
          child: Stack(
            alignment: Alignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(

                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.5,
                    child: Text('Retos\nCompletados', textAlign: TextAlign.center, style: TextStyle(fontSize: 20),),
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _usersStream,
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
                                              final navigator = Navigator.of(context);
                                              try {
                                                await descompletarReto(document.id);
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


                ],
              ),


              Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      //Boton vista de completados
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: (MediaQuery.sizeOf(context).width<500) ? MediaQuery.sizeOf(context).width*0.05 : MediaQuery.sizeOf(context).width*0.05, vertical: MediaQuery.sizeOf(context).height*0.01),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(16)),
                            child: Material(
                              elevation: 10,
                              shadowColor: Colors.black54,
                              color: Colors.deepOrangeAccent.shade100, // button color
                              child: InkWell(
                                splashColor: Colors.amberAccent, // splash color
                                onTap: () async {
                                  Navigator.of(context).pop();
                                }, // button pressed
                                child:
                                const SizedBox(
                                  width: 100,
                                  height: 50,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.arrow_back,), // icon
                                      Text("Regresar", style: TextStyle(),), // text
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