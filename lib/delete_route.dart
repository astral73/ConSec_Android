import 'package:flutter/material.dart';
import 'dart:core';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:rflutter_alert/rflutter_alert.dart';

// Get Metoduyla gelen rota verileri için model sınıfı.
class Route
{
  // Yapıcı (Constructor) Method
  Route({
    required this.routeIDs,
    required this.routeDescs,
    required this.routeNames,
  });

  List<int> routeIDs;
  List<String> routeDescs;
  List<String> routeNames;

  // Bu method Get metoduyla gelen JSON verilerini model sınıfının içindeki değişkenlere dağıtmaktadır.
  factory Route.fromJson(Map<String, dynamic> json) => Route(
    routeIDs: List<int>.from(json["routeIDs"].map((x) => x)),
    routeDescs: List<String>.from(json["routeDescs"].map((x) => x)),
    routeNames: List<String>.from(json["routeNames"].map((x) => x)),
  );
}

// Sayfanın değişmeyen kısımlarını oluşturan, sayfanın genel iskeletini çizen sınıf.
class DeleteRoute extends StatelessWidget
{
  // Yapıcı (Constructor) Method
  const DeleteRoute({Key? key}) : super(key: key);

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
      body: const DeleteRouteStateful(),
    );
  }
}

// Sayfanın değişebilen iç kısımlarını oluşturan sınıf.
class DeleteRouteStateful extends StatefulWidget
{
  // Yapıcı (Constructor) Method
  const DeleteRouteStateful({Key? key}) : super(key: key);

  // createState metodu sayfanın içindeki tüm widget dediğimiz (buton, kayar liste vs.) elementleri oluşturur.
  @override
  State<DeleteRouteStateful> createState() => _DeleteRouteStateful();
}

// Sayfa içindeki widgetların özelliklerini sağlayan sınıf.
class _DeleteRouteStateful extends State<DeleteRouteStateful>
{
  // Rota listesini Get metoduyla alan metod. CRUD operasyonlarını yapan fonksiyonlar async olarak çalışmalıdır.
  Future<Route> getRouteList() async
  {
    final apiUri = Uri.parse('http://10.0.2.2:45455/api/rotaapi/Get');

    // GET Metodu
    final response = await http.get(apiUri);

    // Eğer doğru bir şekilde bağlantı sağlandıysa (200 OK) body içindeki JSON verileri decode edip model sınıfının değişkenlerine dağıtıyoruz.
    if(response.statusCode == HttpStatus.ok)
    {
      final parsed = jsonDecode(response.body);
      return Route.fromJson(parsed);
    }

    // Hatalı bir bağlantı olduğunda hata mesajı veriyoruz.
    else
    {
      throw Exception("Çalışmıyor!!");
    }
  }

  // Oluşturulan bir rotayı DELETE metoduyla silen metod. CRUD operasyonlarını yapan fonksiyonlar async olarak çalışmalıdır.
  Future<void> deleteRoute(int id, String name, String desc) async
  {
    bool isDone = false;

    // DELETE Metodu
    final response = await http.delete(
      Uri.parse('http://10.0.2.2:45455/api/rotaapi/Delete'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'desc': desc,
        'id': id,
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
        desc: "Rota silme işlemi başarılı!",
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

    // Eğer bağlantı hatalıysa, hata alert mesajını kullanıcıya gösteriyoruz.
    else
    {
      Alert(
        context: context,
        type: AlertType.error,
        title: "HATA",
        desc: "Rota bilgileri silinirken bir hata oluştu!\nOlası hata nedenleri:\n- Rota bilgisi boş olabilir.\n- Rota bir rota grubunun içinde olabilir.",
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

  String valueFirst = "--Lütfen bir rota seçiniz--"; // Kaydırılabilen listelerdeki ilk veriyi tutan değişken
  int idInt = 0;
  String name = "";
  String desc = "";

  //Widgetları oluşturan build methodu
  @override
  Widget build(BuildContext context)
  {
    // FutureBuilder metodu async olarak çalışan metodları birbirini beklemeden aynı anda çalıştırmasını sağlar.
    return FutureBuilder(
      future: getRouteList(),
      builder: (context, AsyncSnapshot<Route> snapshot){ // snapshot async olarak çalışan fonksiyonlardan gelen verileri tutar.
        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData)
          {
            // Rota Listesi
            List<String> lst = [];

            lst.add("--Lütfen bir rota seçiniz--");
            for(int i = 0; i < snapshot.data!.routeIDs.length; i++)
            {
              String routeName = (i + 1).toString() + (")") + (" ") + snapshot.data!.routeNames[i];
              lst.add(routeName);
            }

            // Widgetlarımızın özelliklerinin olduğu method.
            return Padding(
              padding: const EdgeInsets.all(10),
              child: ListView(
                children: <Widget>[
                  Container(height: 150,),

                  // Rota kayar listesi
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

                  // Bu butona tıkladığımızda eğer değerler gerekli koşulları sağlıyorsa rota silme işlemi gerçekleşir.
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      child: const Text("Sil"),
                      onPressed: (){
                        if(valueFirst != "--Lütfen bir rota seçiniz--")
                          {
                            for(int i = 0; i < snapshot.data!.routeIDs.length; i++)
                              {
                                var str = (i + 1).toString() + (")") + (" ") + snapshot.data!.routeNames[i];

                                if(str == valueFirst)
                                  {
                                    idInt = snapshot.data!.routeIDs[i];
                                    name = snapshot.data!.routeNames[i];
                                    desc = snapshot.data!.routeDescs[i];
                                  }
                              }

                            // İşleme devam etmek isteyip istemediğimizi soran alert.
                            Alert(
                              context: context,
                              type: AlertType.warning,
                              title: "UYARI",
                              desc: "Rota bilgileri silinecektir. Emin misiniz?",
                              buttons: [
                                DialogButton(
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true).pop();
                                    deleteRoute(idInt, name, desc);
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