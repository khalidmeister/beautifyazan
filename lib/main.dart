import 'package:flutter/material.dart';
import 'azan_logic.dart';
import 'location.dart';
import 'jadwal.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AzanLogic azanLogic = AzanLogic();
  String kota = 'Pekanbaru';
  Future<Location> newLocation;
  Future<List<Jadwal>> newJadwalSolat;
  
  TextEditingController kotaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    newJadwalSolat = azanLogic.jadwalSolat(kota);
    newLocation = azanLogic.getLocation(kota);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        title: Text("Beautify Adzan"),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: kotaController,
              decoration: InputDecoration(
                hintText: 'Isi Nama Kota',
                icon: Icon(Icons.location_city),
              ),
              onSubmitted: (text) {
                setState(() {
                 kota = text[0].toUpperCase() + text.substring(1);
                 newJadwalSolat = azanLogic.jadwalSolat(text);
                 newLocation = azanLogic.getLocation(text);
                });
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: FutureBuilder(
              future: newLocation,
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.done){
                  if (snapshot.data.negara == null) {
                    return Container(height: 0.0);
                  } else {
                    return Text(
                      'Menampilkan Kota ${kota}, ${snapshot.data.negara}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    );
                  }
                } else {
                  return Container(height: 0.0);
                }
              }
            ),
          ),
          Container(
            height: 500.0,
            child: FutureBuilder(
              future: newJadwalSolat,
              builder:  (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.done){
                  if (snapshot.data == null) {
                    return Center(
                      child: Text('Mohon Maaf, silakan cari kota lain atau yang setara.'),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int i) {
                        return ListTile(
                          title: Text('${snapshot.data[i].namaSolat}'),
                          subtitle: Text('${snapshot.data[i].waktu}')
                        );
                      }
                    );
                  }
                } else {
                  return Center(
                      child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
