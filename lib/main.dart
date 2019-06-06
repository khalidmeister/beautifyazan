import 'package:beautifyadzan/jadwal.dart';
import 'package:flutter/material.dart';
import 'waktu_solat.dart';
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
  String kota = 'pekanbaru';
  TextEditingController kotaController = TextEditingController();

  Future<List<Jadwal>> newJadwalSolat;

  Future<List<Jadwal>> jadwalSolat(String kota) async{
    Response response = await get('https://muslimsalat.com/$kota/daily.json?key=b542043bed6c46005ed159025beb76b9');
    var res = json.decode(response.body);
    List<Jadwal> solat = [];
    solat.add(Jadwal(namaSolat: 'Subuh', waktu: res['items'][0]['fajr']));
    solat.add(Jadwal(namaSolat: 'Zuhur', waktu: res['items'][0]['dhuhr']));
    solat.add(Jadwal(namaSolat: 'Ashar', waktu: res['items'][0]['asr']));
    solat.add(Jadwal(namaSolat: 'Maghrib', waktu: res['items'][0]['maghrib']));
    solat.add(Jadwal(namaSolat: 'Isya', waktu: res['items'][0]['isha']));
    for(var i in solat){
      print('${i.namaSolat} ${i.waktu}');
    }
    return solat;
  }
  
  @override
  void initState() {
    super.initState();
    newJadwalSolat = jadwalSolat(kota);
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
              ),
              onSubmitted: (text) {
                setState(() {
                 newJadwalSolat = jadwalSolat(text); 
                });
              },
            ),
          ),
          Container(
            height: 500.0,
            child: FutureBuilder(
              future: newJadwalSolat,
              builder:  (context, snapshot) {
                if (snapshot.data == null) {
                  return Center(
                    child: CircularProgressIndicator(),
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
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Jadwal{
  String namaSolat;
  String waktu;
  
  Jadwal({this.namaSolat, this.waktu});
}

