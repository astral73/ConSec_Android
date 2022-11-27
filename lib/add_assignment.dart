import 'package:flutter/material.dart';
import 'dart:core';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/services.dart';

// Get Metoduyla gelen güvenlik verileri için model sınıfı.
class Security
{
  // Yapıcı (Constructor) Method
  Security({
    required this.employeeIDs,
    required this.employeeMails,
    required this.employeePasswords,
    required this.employeeNames,
    required this.employeeLastnames,
  });

  List<int> employeeIDs;
  List<String> employeeMails;
  List<String> employeePasswords;
  List<String> employeeNames;
  List<String> employeeLastnames;

  // Bu method Get metoduyla gelen JSON verilerini model sınıfının içindeki değişkenlere dağıtmaktadır.
  factory Security.fromJson(Map<String, dynamic> json) => Security(
      employeeIDs: List<int>.from(json["employeeIDs"].map((x) => x)),
      employeeMails: List<String>.from(json["employeeMails"].map((x) => x)),
      employeePasswords: List<String>.from(json["employeePasswords"].map((x) => x)),
      employeeNames: List<String>.from(json["employeeNames"].map((x) => x)),
      employeeLastnames: List<String>.from(json["employeeLastnames"].map((x) => x))
  );
}

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
    patrolNames: List<String>.from(json["patrolNames"].map((x) => x)),
    patrolDescs: List<String>.from(json["patrolDescs"].map((x) => x)),
  );
}

// Sayfanın değişmeyen kısımlarını oluşturan, sayfanın genel iskeletini çizen sınıf.
class AddAssignment extends StatelessWidget
{
  // Yapıcı (Constructor) Method
  const AddAssignment({Key? key}) : super(key: key);

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
      body: const AddAssignmentStateful(),
    );
  }
}

// Sayfanın değişebilen iç kısımlarını oluşturan sınıf.
class AddAssignmentStateful extends StatefulWidget
{
  // Yapıcı (Constructor) Method
  const AddAssignmentStateful({Key? key}) : super(key: key);

  // createState metodu sayfanın içindeki tüm widget dediğimiz (buton, kayar liste vs.) elementleri oluşturur.
  @override
  State<AddAssignmentStateful> createState() => _AddAssignmentStateful();
}

// Sayfa içindeki widgetların özelliklerini sağlayan sınıf.
class _AddAssignmentStateful extends State<AddAssignmentStateful>
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

  // Güvenlik listesini Get metoduyla alan metod. CRUD operasyonlarını yapan fonksiyonlar async olarak çalışmalıdır.
  Future<Security> getSecurityList() async
  {
    final apiUri = Uri.parse('http://10.0.2.2:45455/api/guvenlikapi/Get');

    // GET Metodu
    final response = await http.get(apiUri);

    // Eğer doğru bir şekilde bağlantı sağlandıysa (200 OK) body içindeki JSON verileri decode edip model sınıfının değişkenlerine dağıtıyoruz.
    if(response.statusCode == HttpStatus.ok)
    {
      final parsed = jsonDecode(response.body);
      return Security.fromJson(parsed);
    }

    // Hatalı bir bağlantı olduğunda hata mesajı veriyoruz.
    else
    {
      throw Exception("Çalışmıyor!!");
    }
  }

  // Güvenliğe yapılan bir atamayı POST metoduyla gönderen metod. CRUD operasyonlarını yapan fonksiyonlar async olarak çalışmalıdır.
  Future<void> addAssignment(int patrolID, int empID, String resumptionTime, String timeType) async
  {
    bool OK = false;

    // POST Metodu
    final response = await http.post(
      Uri.parse('http://10.0.2.2:45455/api/atamaapi/Post'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'patrolID': patrolID,
        'empID': empID,
        'resumptionTime': resumptionTime,
        'timeType': timeType,
      }),
    );

    // Eğer doğru bir şekilde bağlantı sağlandıysa (200 OK) bool türünde olan OK değişkenini true yapıyoruz.
    if(response.statusCode == HttpStatus.ok)
    {
      OK = true;
    }

    // Hatalı bir bağlantı olduğunda değişken false oluyor.
    else
    {
      OK = false;
    }

    // Eğer doğru bir şekilde bağlantı sağlandıysa (200 OK) başarılı alert mesajını kullanıcıya gösteriyoruz.
    if(OK == true)
    {
      Alert(
        context: context,
        type: AlertType.success,
        title: "BAŞARILI",
        desc: "Atama işlemi başarılı!",
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
        desc: "Atama yapılırken bir sıkıntı oluştu!\n- Olası hata nedenleri: Atama bilgileri boş olabilir!\n- Güvenliğe önceden bir atama yapılmış olabilir!",
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

  TextEditingController timeController = TextEditingController(); // Yazı yazılabilecek alandaki text metninin tutulması için gerekli değişken
  String secValueFirst = "--Lütfen bir güvenlik seçiniz--"; // Kaydırılabilen listelerdeki ilk veriyi tutan değişken
  String patrolValueFirst = "--Lütfen bir devriye seçiniz--"; // Kaydırılabilen listelerdeki ilk veriyi tutan değişken
  String timeValueFirst = "--Lütfen bir zaman türü seçiniz--"; // Kaydırılabilen listelerdeki ilk veriyi tutan değişken

  int secID = 0;
  int patrolID = 0;
  String timeTemp = "";

  //Widgetları oluşturan build methodu
  @override
  Widget build(BuildContext context)
  {
    // FutureBuilder metodu async olarak çalışan metodları birbirini beklemeden aynı anda çalıştırmasını sağlar.
    return FutureBuilder(
      future: Future.wait([getSecurityList(), getPatrolList()]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot){ // snapshot async olarak çalışan fonksiyonlardan gelen verileri tutar.
        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData)
          {
            List<String> patrolLst = [];
            List<String> securityLst = [];
            List<String> timeType = ["--Lütfen bir zaman türü seçiniz--", "Dakika", "Saat", "Gün"];

            // Güvenlik Listesi
            securityLst.add("--Lütfen bir güvenlik seçiniz--");
            for(int i = 0; i < snapshot.data![0].employeeIDs.length; i++)
            {
              String fullName = snapshot.data![0].employeeNames[i] + (" ") + snapshot.data![0].employeeLastnames[i];
              securityLst.add(fullName);
            }

            // Devriye Listesi
            patrolLst.add("--Lütfen bir devriye seçiniz--");
            for(int i = 0; i < snapshot.data![1].patrolIDs.length; i++)
            {
              String fullName = (i + 1).toString() + (")") + (" ") + snapshot.data![1]!.patrolNames[i];
              patrolLst.add(fullName);
            }

            // Widgetlarımızın özelliklerinin olduğu method.
            return Padding(
              padding: const EdgeInsets.all(10),
              child: ListView(
                children: <Widget>[
                  // Devriye kayar listesi
                  DropdownButton(
                    value: patrolValueFirst, // Seçilen değer

                    // Kalan liste elemanları
                    items: patrolLst.map((String item){
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),

                    // Seçilen değer değiştiğinde onu bir değişkene atıyoruz.
                    onChanged: (String? newValue){
                      setState((){
                        patrolValueFirst = newValue!;
                      });
                    },
                  ),
                  Container(height: 20,),

                  // Güvenlik kayar listesi
                  DropdownButton(
                    value: secValueFirst, // Seçilen değer

                    // Kalan liste elemanları
                    items: securityLst.map((String item){
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),

                    // Seçilen değer değiştiğinde onu bir değişkene atıyoruz.
                    onChanged: (String? newValue){
                      setState((){
                        secValueFirst = newValue!;
                      });
                    },
                  ),
                  Container(height: 20,),

                  // Yazı yazılabilen alan
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      cursorColor: Colors.blue,
                      controller: timeController,
                      keyboardType: TextInputType.number, // Bu alana sadece sayıyla yazabiliyoruz.
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        FilteringTextInputFormatter.digitsOnly

                      ],
                      decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue, width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue, width: 1.5),
                          ),
                          labelText: 'Süre',
                          labelStyle: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                          )
                      ),
                    ),
                  ),
                  Container(height: 20,),

                  // Zaman tiplerinin olduğu kayar liste
                  DropdownButton(
                    value: timeValueFirst, // Seçilen değer

                    // Kalan liste elemanları
                    items: timeType.map((String item){
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),

                    // Seçilen değer değiştiğinde onu bir değişkene atıyoruz.
                    onChanged: (String? newValue){
                      setState((){
                        timeValueFirst = newValue!;
                      });
                    },
                  ),
                  Container(height: 20,),

                  // Bu butona tıkladığımızda eğer değerler gerekli koşulları sağlıyorsa atama işlemi gerçekleşir.
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      child: const Text("Ekle"),
                      onPressed: (){
                        if(timeController.text != "" && secValueFirst != "--Lütfen bir güvenlik seçiniz--" && patrolValueFirst != "--Lütfen bir devriye seçiniz--" && timeValueFirst != "--Lütfen bir zaman türü seçiniz--")
                          {
                            for(int i = 0; i < snapshot.data![0].employeeIDs.length; i++)
                              {
                                var str = snapshot.data![0].employeeNames[i] + (" ") + snapshot.data![0].employeeLastnames[i];

                                if(str == secValueFirst)
                                  {
                                    secID = snapshot.data![0].employeeIDs[i];
                                  }
                              }

                            for(int i = 0; i < snapshot.data![1].patrolIDs.length; i++)
                            {
                              var str = (i + 1).toString() + (")") + (" ") + snapshot.data![1]!.patrolNames[i];

                              if(str == patrolValueFirst)
                              {
                                patrolID = snapshot.data![1].patrolIDs[i];
                              }
                            }

                            timeTemp = timeController.text;

                            // İşleme devam etmek isteyip istemediğimizi soran alert.
                            Alert(
                              context: context,
                              type: AlertType.warning,
                              title: "UYARI",
                              desc: "Atama yapmak istediğinize emin misiniz!",
                              buttons: [
                                DialogButton(
                                  child: const Text("Evet", style: TextStyle(color: Colors.white, fontSize: 20)),
                                  onPressed: () async{
                                    Navigator.of(context, rootNavigator: true).pop();
                                    addAssignment(patrolID, secID, timeTemp, timeValueFirst);
                                  },
                                ),
                                DialogButton(
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true).pop();
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
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent,
                      ),
                    ),
                  ),
                  Container(height: 30),

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
        else{
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