import 'package:flutter/material.dart';
import 'dart:core';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:rflutter_alert/rflutter_alert.dart';

// Get Metoduyla gelen devriye verileri için model sınıfı.
class Patrol
{
  // Yapıcı (Constructor) Method
  Patrol({
    required this.patrolIDs,
    required this.patrolNums,
    required this.patrolNames,
    required this.patrolDescs,
  });

  List<int> patrolIDs;
  List<String> patrolNums;
  List<String> patrolNames;
  List<String> patrolDescs;

  // Bu method Get metoduyla gelen JSON verilerini model sınıfının içindeki değişkenlere dağıtmaktadır.
  factory Patrol.fromJson(Map<String, dynamic> json) => Patrol(
    patrolIDs: List<int>.from(json["patrolIDs"].map((x) => x)),
    patrolNums: List<String>.from(json["patrolNums"].map((x) => x)),
    patrolDescs: List<String>.from(json["patrolDescs"].map((x) => x)),
    patrolNames: List<String>.from(json["patrolNames"].map((x) => x)),
  );
}

// Sayfanın değişmeyen kısımlarını oluşturan, sayfanın genel iskeletini çizen sınıf.
class DeletePatrol extends StatelessWidget
{
  // Yapıcı (Constructor) Method
  const DeletePatrol({Key? key}) : super(key: key);

  // Sayfanın üstünde yer alan isim değişkeni
  static const String _title = 'ConSec® - Yönetici';

  // Build metodu sayfanın widgetlarını ekrana koyar.
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text(_title),
        backgroundColor: Colors.blue,
      ),
      body: const DeletePatrolStateful(),
    );
  }
}

// Sayfanın değişebilen iç kısımlarını oluşturan sınıf.
class DeletePatrolStateful extends StatefulWidget
{
  // Yapıcı (Constructor) Method
  const DeletePatrolStateful({Key? key}) : super(key: key);

  // createState metodu sayfanın içindeki tüm widget dediğimiz (buton, kayar liste vs.) elementleri oluşturur.
  @override
  State<DeletePatrolStateful> createState() => _DeletePatrolStateful();
}

// Sayfa içindeki widgetların özelliklerini sağlayan sınıf.
class _DeletePatrolStateful extends State<DeletePatrolStateful>
{
  // Devriye listesini Get metoduyla alan metod. CRUD operasyonlarını yapan fonksiyonlar async olarak çalışmalıdır.
  Future<Patrol> getPatrolList() async
  {
    final apiUri = Uri.parse('http://10.0.2.2:45455/api/devriyeapi/Get');

    // GET Metodu
    final response = await http.get(apiUri);

    // Eğer doğru bir şekilde bağlantı sağlandıysa (200 OK) body içindeki JSON verileri decode edip model sınıfının değişkenlerine dağıtıyoruz.
    if(response.statusCode == HttpStatus.ok)
    {
      final parsed = jsonDecode(response.body);
      return Patrol.fromJson(parsed);
    }

    // Hatalı bir bağlantı olduğunda hata mesajı veriyoruz.
    else
    {
      throw Exception("Çalışmıyor!!");
    }
  }

  // Oluşturulmuş bir devriyeyi DELETE metoduyla silen metod. CRUD operasyonlarını yapan fonksiyonlar async olarak çalışmalıdır.
  Future<void> deletePatrol(String name, String desc, int id, List<List<int>> patrolItems) async
  {
    bool isDone = false;

    // DELETE Metodu
    final response = await http.delete(
      Uri.parse('http://10.0.2.2:45455/api/devriyeapi/Delete'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'desc': desc,
        'id': id,
        'patrolItems': patrolItems,
      }),
    );

    // Eğer doğru bir şekilde bağlantı sağlandıysa (200 OK) bool türünde olan OK değişkenini true yapıyoruz.
    if(response.statusCode == HttpStatus.ok)
    {
      isDone = true;
    }

    // Hatalı bir bağlantı olduğunda değişken false oluyor.
    else
    {
      isDone = false;
    }

    // Eğer doğru bir şekilde bağlantı sağlandıysa (200 OK) başarılı alert mesajını kullanıcıya gösteriyoruz.
    if(isDone == true)
    {
      Alert(
        context: context,
        type: AlertType.success,
        title: "BAŞARILI",
        desc: "Devriye silme işlemi başarılı!",
        buttons: [
          DialogButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              Navigator.pop(context);
            },
            width: 120,
            child: const Text(
              "TAMAM",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ],
      ).show();
    }

    // Hatalı bir bağlantı olduğunda hata alert mesajını kullanıcıya gösteriyoruz.
    else
    {
      Alert(
        context: context,
        type: AlertType.error,
        title: "HATA",
        desc: "Devriye bilgileri silinirken bir hata oluştu!\nOlası hata nedenleri:\n- Devriye bilgisi boş olabilir.\n- Devriye bir güvenliğe atanmış olabilir.",
        buttons: [
          DialogButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
            width: 120,
            child: const Text(
              "TAMAM",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ],
      ).show();
    }
  }

  String valueFirst = "--Lütfen bir devriye seçiniz--"; // Kaydırılabilen listelerdeki ilk veriyi tutan değişken
  int idInt = 0;
  String name = "";
  String desc = "";
  List<List<int>> temp = [];

  //Widgetları oluşturan build methodu
  @override
  Widget build(BuildContext context)
  {
    // FutureBuilder metodu async olarak çalışan metodları birbirini beklemeden aynı anda çalıştırmasını sağlar.
    return FutureBuilder(
      future: getPatrolList(),
      builder: (context, AsyncSnapshot<Patrol> snapshot){ // snapshot async olarak çalışan fonksiyonlardan gelen verileri tutar.
        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData)
          {
            // Devriye Listesi
            List<String> lst = [];

            lst.add("--Lütfen bir devriye seçiniz--");
            for(int i = 0; i < snapshot.data!.patrolIDs.length; i++)
            {
              String patrolName = (i + 1).toString() + (")") + (" ") + snapshot.data!.patrolNames[i];
              lst.add(patrolName);
            }

            // Widgetlarımızın özelliklerinin olduğu method.
            return Padding(
              padding: const EdgeInsets.all(10),
              child: ListView(
                children: <Widget>[
                  Container(height: 150,),
                  // Devriye kayar listesi
                  DropdownButton(
                    value: valueFirst, // Seçilen değer

                    // Kalan liste elemanları
                    items: lst.map((String item){
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),

                    // Seçilen değer değiştiğinde onu bir değişkene atıyoruz.
                    onChanged: (String? newValue){
                      setState((){
                        valueFirst = newValue!;
                      });
                    },
                  ),
                  Container(height: 30,),

                  // Bu butona tıkladığımızda eğer değerler gerekli koşulları sağlıyorsa devriye silme işlemi gerçekleşir.
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      child: const Text("Sil"),
                      onPressed: (){
                        if(valueFirst != "--Lütfen bir devriye seçiniz--")
                        {
                          for(int i = 0; i < snapshot.data!.patrolIDs.length; i++)
                          {
                            var str = (i + 1).toString() + (")") + (" ") + snapshot.data!.patrolNames[i];

                            if(str == valueFirst)
                            {
                              idInt = snapshot.data!.patrolIDs[i];
                              name = snapshot.data!.patrolNames[i];
                              desc = snapshot.data!.patrolDescs[i];
                              temp = [];
                            }
                          }

                          // İşleme devam etmek isteyip istemediğimizi soran alert.
                          Alert(
                            context: context,
                            type: AlertType.warning,
                            title: "UYARI",
                            desc: "Devriye bilgileri silinecektir. Emin misiniz?",
                            buttons: [
                              DialogButton(
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true).pop();
                                  deletePatrol(name, desc, idInt, temp);
                                },
                                width: 120,
                                child: const Text(
                                  "Evet",
                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                ),
                              ),
                              DialogButton(
                                onPressed: (){
                                  Navigator.of(context, rootNavigator: true).pop();
                                  Navigator.pop(context);
                                },
                                width: 120,
                                child: const Text("Hayır", style: TextStyle(color: Colors.white, fontSize: 20)),
                              ),
                            ],
                          ).show();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent,
                      ),
                    ),
                  ),
                  Container(height: 40),

                  // Geri dön butonu bizi bir önceki sayfaya geri döndürür.
                  SizedBox(
                    height: 50,
                    width: 100,
                    child: ElevatedButton(
                      onPressed: ()
                      {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent,
                      ),
                      child: const Text('Geri Dön'),
                    ),
                  ),
                ],
              ),
            );
          }

        // Eğer FutureBuilder kısmı geç gelirse (yavaş internet gibi) ya da çalışmazsa bu kısımdaki widgetlar oluşturulur
        else {
          return ListView(
            children: <Widget>[
              Container(height: 200,),
              const Text("Lütfen bekleyiniz ya da daha sonra tekrar deneyiniz...", textAlign: TextAlign.center,),
              Container(height: 30,),
              const Center(
                child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator()),
              ),
              Container(height: 30,),
              SizedBox(
                height: 50,
                width: 100,
                child: ElevatedButton(
                  onPressed: ()
                  {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blueAccent,
                  ),
                  child: const Text('Geri Dön'),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}