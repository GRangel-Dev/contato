import 'dart:io';

import 'package:contato/helpers/database_helper.dart';
import 'package:contato/models/contato.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

 class _HomePageState extends State<HomePage> {
  DatabaseHelper db = DatabaseHelper();
  List<Contato> contatos = <Contato>[];

  @override
  void initState() {
    super.initState();
    db.getContatos().then((lista) {
      setState(() {
        contatos = lista;
      });
    });

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Agenda Pessoal'),
          backgroundColor: Colors.indigo,
          centerTitle: true,
          actions: const [],
        ),
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: contatos.length,
          itemBuilder: (context, index) {
            return _listaContatos(context, index);
          },
        ),
      );
    }
  }

  _listaContatos ( BuildContext context, int index){
    // ignore: dead_code
    return GestureDetector(
      child: Card(
        child: Padding(padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              width: 70.0,
              height: 70.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                 image: contatos[index].imagem != null ? 
                 FileImage(File(contatos[index].imagem)) :
                  AssetImage("assets/images/pessoa2.png")
               ),
              ),
            ),
            Padding(padding: EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(contatos[index]. nome,
                style: TextStyle(fontSize: 20),),
                Text(contatos[index]. email,
                style: TextStyle(fontSize: 15),),
              ],
            ),
            ),

            
          ],
        ),
        ),
       ) ,
      );
      
  }

  

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
