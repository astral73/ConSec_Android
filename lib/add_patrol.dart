import 'package:flutter/material.dart';
import 'dart:core';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:rflutter_alert/rflutter_alert.dart';

// // Get Metoduyla gelen rota verileri için model sınıfı.
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
class AddPatrol extends StatelessWidget
{
  // Yapıcı (Constructor) Method
  const AddPatrol({Key? key}) : super(key: key);

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
      body: const AddPatrolStateful(),
    );
  }
}

// Sayfanın değişebilen iç kısımlarını oluşturan sınıf.
class AddPatrolStateful extends StatefulWidget
{
  // Yapıcı (Constructor) Method
  const AddPatrolStateful({Key? key}) : super(key: key);

  // createState metodu sayfanın içindeki tüm widget dediğimiz (buton, kayar liste vs.) elementleri oluşturur.
  @override
  State<AddPatrolStateful> createState() => _AddPatrolStateful();
}

// Global değişkenler
int rRow = 0;
List<List<int>> allRoutes = [];
List<String> justroutes = [];

// Sayfa içindeki widgetların özelliklerini sağlayan sınıf.
class _AddPatrolStateful extends State<AddPatrolStateful>
{
  // Devriye için seçilen rotaları bir listeye atan metod.
  void addRoutesToList(int routeID, int routeRow)
  {
    bool isDone = false;

    try{
  List<int> newPatrolItem = [];

  newPatrolItem.add(routeID);
  newPatrolItem.add(routeRow);

  justroutes.add(routeID.toString());

  allRoutes.add(newPatrolItem);

  isDone = true;
  }

  catch(x){
      isDone = false;
  }

    if(isDone == true)
    {
      // Eğer atma işlemi başarılı olursa başarılı alertini yolluyoruz.
      Alert(
        context: context,
        type: AlertType.success,
        title: "BAŞARILI",
        desc: "Devriyeye rota ekleme işlemi başarılı!",
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

    // Eğer atma işlemi başarısız olursa hata alertini yolluyoruz.
    else
    {
      Alert(
        context: context,
        type: AlertType.error,
        title: "HATA",
        desc: "Devriyeye rota bilgileri silinirken bir hata oluştu!\nOlası hata nedenleri:\n- Rota bilgisi boş olabilir.",
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

  // Oluşturulan devriyeyi POST metoduyla gönderen metod. CRUD operasyonlarını yapan fonksiyonlar async olarak çalışmalıdır.
  Future<bool> addPatrol(String name, String desc, List<List<int>> allRoutes) async
  {
    bool isOK = false;

    try
        {
          // POST Metodu
          http.post(
            Uri.parse('http://10.0.2.2:45455/api/devriyeapi/Post'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              'name': name,
              'desc': desc,
              'patrolItems': allRoutes,
            }),
          );

          // Eğer hatasız bir şekilde işlem tamamlanırsa değişkeni true yapıyoruz.
          isOK = true;
        }

    catch(x){
      // Eğer bir hata olursa değişken false oluyor.
      isOK = false;
    }

    // Son olarak bool değişkenini geri döndürüyoruz.
    return Future<bool>.value(isOK);
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

  String name = "";
  String desc = "";
  String valueFirst = "--Lütfen bir rota seçiniz--";
  int rID = 0;

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
            List<String> lst = [];

            // Rota Listesi
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

                  Container(height: 20),
                  // Eklenen rotaları gösteren Text widgetı
                  Text(("Eklenmiş Rotalar: ") + (justroutes.isNotEmpty ? (justroutes.reduce((value, element) => value + (',') + element)) : "Hiçbir rota eklenmedi!"), textAlign: TextAlign.center,),
                  Container(height: 20),

                  // Bu butona tıkladığımızda eğer değerler gerekli koşulları sağlıyorsa devriyeye rota ekleme işlemi gerçekleşir.
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      child: const Text("Rota Ekle"),
                      onPressed: (){
                        if(valueFirst != "--Lütfen bir rota seçiniz--")
                        {
                          for(int i = 0; i < snapshot.data!.routeIDs.length; i++)
                          {
                            var str = (i + 1).toString() + (")") + (" ") + snapshot.data!.routeNames[i];

                            if(str == valueFirst)
                            {
                              rID = snapshot.data!.routeIDs[i];
                            }
                          }

                          // İşleme devam etmek isteyip istemediğimizi soran alert.
                          Alert(
                            context: context,
                            type: AlertType.warning,
                            title: "UYARI",
                            desc: "Rota bilgisi eklenecektir. Emin misiniz?",
                            buttons: [
                              DialogButton(
                                onPressed: () {
                                  rRow += 1;
                                  Navigator.of(context, rootNavigator: true).pop();
                                  addRoutesToList(rID, rRow);
                                  setState(() {});
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
                                },
                                width: 120,
                                child: const Text("Hayır", style: TextStyle(color: Colors.white, fontSize: 20)),
                              ),
                            ],
                          ).show();
                        }
                      },
                    ),
                  ),
                  Container(height: 40,),
                  Container(
                    padding: const EdgeInsets.all(10),

                    // Yazı yazılabilen alan
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
                          labelText: 'Devriye İsmi',
                          labelStyle: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                          )
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),

                    // Yazı yazılabilen alan
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
                          labelText: 'Devriye Açıklaması',
                          labelStyle: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                          )
                      ),
                    ),
                  ),

                  // Bu butona tıkladığımızda eğer değerler gerekli koşulları sağlıyorsa devriye ekleme işlemi gerçekleşir.
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      child: const Text('Ekle'),
                      onPressed: () async{
                        if(nameController.text != "" && descController.text != "")
                        {
                          name = nameController.text;
                          desc = descController.text;

                          bool OK = false;

                          // İşleme devam etmek isteyip istemediğimizi soran alert.
                          Alert(
                            context: context,
                            type: AlertType.warning,
                            title: "UYARI",
                            desc: "Devriye bilgilerini eklemek istediğinize emin misiniz?",
                            buttons: [
                              DialogButton(
                                onPressed: () async{
                                  OK = await addPatrol(name, desc, allRoutes);
                                  Navigator.of(context, rootNavigator: true).pop();

                                  if(OK == true)
                                  {
                                    Alert(
                                      context: context,
                                      type: AlertType.success,
                                      title: "BAŞARILI",
                                      desc: "Devriye ekleme işlemi başarılı!",
                                      buttons: [
                                        DialogButton(
                                          onPressed: () {
                                            Navigator.of(context, rootNavigator: true).pop();
                                            rRow = 0;
                                            allRoutes = [];
                                            justroutes = [];
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

                                  else
                                  {
                                    Alert(
                                      context: context,
                                      type: AlertType.error,
                                      title: "HATA",
                                      desc: "Devriye bilgisi eklenirken bir sıkıntı oluştu!",
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
                                },
                                width: 120,
                                child: const Text("Evet", style: TextStyle(color: Colors.white, fontSize: 20)),
                              ),
                              DialogButton(
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true).pop();
                                  Navigator.pop(context);
                                },
                                width: 120,
                                child: const Text(
                                  "Hayır",
                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                ),
                              ),
                            ],
                          ).show();
                        }

                        else
                        {
                          Alert(
                            context: context,
                            type: AlertType.error,
                            title: "HATA",
                            desc: "Devriye bilgileri boş olamaz!",
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
                        rRow = 0;
                        allRoutes = [];
                        justroutes = [];
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