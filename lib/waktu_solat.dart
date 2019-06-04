import 'jadwal.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WaktuSolat{
  List<Jadwal> daftar = [];
  List<String> nama = ['Subuh', 'Dzuhur', 'Ashar', 'Maghrib', 'Isya'];
  List<String> namaInggris = ['fajr', 'shurooq', 'dhuhr', 'asr', 'maghrib', 'isha'];
  String getNamaSolat(int idx){
    return daftar[idx].namaSolat;
  }

  void getWaktuAdzan() async{
    var response = await http.get('https://muslimsalat.com/jakarta/daily.json?key=b542043bed6c46005ed159025beb76b9');
    if(response.statusCode == 200){
      print(response.body);
    } else {
      print(response.statusCode);
    }
    var res = json.decode(response.body);
    for(int i = 0; i < 5; i++){
      daftar.add(Jadwal(namaSolat: nama[i], waktu: res['items'][0][namaInggris]));
    }
  }

  String getWaktu(int idx){
    return daftar[idx].waktu;
  }
}