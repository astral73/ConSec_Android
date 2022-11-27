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
class UpdateRoute extends StatelessWidget
{
  // Yapıcı (Constructor) Method
  const UpdateRoute({Key? key}) : super(key: key);

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
      body: const UpdateRouteStateful(),
    );
  }
}

// Sayfanın değişebilen iç kısımlarını oluşturan sınıf.
class UpdateRouteStateful extends StatefulWidget
{
  // Yapıcı (Constructor) Method
  const UpdateRouteStateful({Key? key}) : super(key: key);

  // createState metodu sayfanın içindeki tüm widget dediğimiz (buton, kayar liste vs.) elementleri oluşturur.
  @override
  State<UpdateRouteStateful> createState() => _UpdateRouteStateful();
}

// Sayfa içindeki widgetların özelliklerini sağlayan sınıf.
class _UpdateRouteStateful extends State<UpdateRouteStateful>
{
  // Oluşturulan bir rotayı PUT metoduyla güncelleyen metod. CRUD operasyonlarını yapan fonksiyonlar async olarak çalışmalıdır.
  Future<void> updateRoute(int id, String name, String desc) async
  {
    bool isOK = false;

    // PUT Metodu
    final response = await http.put(
      Uri.parse('http://10.0.2.2:45455/api/rotaapi/Put'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'desc':desc,
        'id': id,
      }),
    );

    // Eğer doğru bir şekilde bağlantı sağlandıysa (200 OK) bool türünde olan OK değişkenini true yapıyoruz.
    if(response.statusCode == HttpStatus.ok)
    {
      isOK = true;
    }

    // Hatalı bir bağlantı olduğunda değişken false oluyor.
    else
    {
      isOK = false;
    }

    // Eğer doğru bir şekilde bağlantı sağlandıysa (200 OK) başarılı alert mesajını kullanıcıya gösteriyoruz.
    if(isOK == true)
    {
      Alert(
        context: context,
        type: AlertType.success,
        title: "BAŞARILI",
        desc: "Rota güncelleme işlemi başarılı!",
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
        desc: "Rota bilgileri güncellenirken bir hata oluştu!",
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
  }

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

  TextEditingController nameController = TextEditingController(); // Yazı yazılabilecek alandaki text metninin tutulması için gerekli değişken
  TextEditingController descController = TextEditingController(); // Yazı yazılabilecek alandaki text metninin tutulması için gerekli değişken
  String valueFirst = "--Lütfen bir rota seçiniz--"; // Kaydırılabilen listelerdeki ilk veriyi tutan değişken

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
            String name = "";
            String desc = "";
            int idInt = 0;

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

                  // Yazı yazılabilen alan
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      cursorColor: Colors.blue,
                      controller: nameController,
                      decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue, width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue, width: 1.5),
                          ),
                          labelText: 'İsim',
                          labelStyle: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                          )
                      ),
                    ),
                  ),

                  // Yazı yazılabilen alan
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      cursorColor: Colors.blue,
                      controller: descController,
                      decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue, width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue, width: 1.5),
                          ),
                          labelText: 'Açıklama',
                          labelStyle: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                          )
                      ),
                    ),
                  ),
                  Container(height: 20,),

                  // Bu butona tıkladığımızda eğer değerler gerekli koşulları sağlıyorsa rota güncelleme işlemi gerçekleşir.
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      child: const Text('Güncelle'),
                      onPressed: (){
                        if(nameController.text != "" && descController.text != "" && valueFirst != "--Lütfen bir rota seçiniz--")
                          {
                            for(int i = 0; i < snapshot.data!.routeIDs.length; i++)
                              {
                                var str = (i + 1).toString() + (")") + (" ") + snapshot.data!.routeNames[i];

                                if(str == valueFirst)
                                  {
                                    idInt = snapshot.data!.routeIDs[i];
                                  }
                              }

                            name = nameController.text;
                            desc = descController.text;

                            // İşleme devam etmek isteyip istemediğimizi soran alert.
                            Alert(
                              context: context,
                              type: AlertType.warning,
                              title: "UYARI",
                              desc: "Rota bilgilerini güncellemek istediğinize emin misiniz?",
                              buttons: [
                                DialogButton(
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true).pop();
                                    updateRoute(idInt, name, desc);
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