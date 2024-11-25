import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Retos extends StatefulWidget {
  const Retos({super.key, required this.uid});

  final String? uid;
  @override
  State<Retos> createState() => _RetosState();
}

class _RetosState extends State<Retos> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('habitos').doc(widget.uid).collection('habitos').orderBy('creacion',descending: true).snapshots();
    CollectionReference users = FirebaseFirestore.instance.collection('habitos').doc(widget.uid).collection('habitos');


    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height*0.6,
        width: MediaQuery.of(context).size.width*1,
        child: Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.sizeOf(context).width*0.05, vertical: MediaQuery.of(context).size.height*0.01),
            width: MediaQuery.sizeOf(context).width,
            decoration:  const BoxDecoration(
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
                  return const Text("Loading");
                }


                return ListView(

                  clipBehavior: Clip.none,
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

                    return ExpansionTileCard(
                      baseColor: Theme.of(context).colorScheme.onInverseSurface,
                      expandedColor: Theme.of(context).colorScheme.onInverseSurface.withBlue(200),
                      expandedTextColor: Colors.black,
                      initialPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.01),
                      leading: ClipRRect(

                        borderRadius: BorderRadius.circular(8.0), child: const Icon(Icons.star),),
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


    );
  }
}