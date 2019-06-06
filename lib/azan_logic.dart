import 'dart:async';
import 'dart:convert';
import 'location.dart';
import 'jadwal.dart';
import 'package:http/http.dart';

class AzanLogic{
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

  Future<Location> getLocation(String kota) async{
    Response response = await get('https://muslimsalat.com/$kota/daily.json?key=b542043bed6c46005ed159025beb76b9');
    var res = json.decode(response.body);
    
    Location negara;
    negara = Location(kota: res['city'], negara: res['country']);
    return negara;
  }
}