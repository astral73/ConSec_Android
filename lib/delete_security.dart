import 'package:flutter/material.dart';
import 'dart:core';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:rflutter_alert/rflutter_alert.dart';

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

// Sayfanın değişmeyen kısımlarını oluşturan, sayfanın genel iskeletini çizen sınıf.
class DeleteSecurity extends StatelessWidget
{
  // Yapıcı (Constructor) Method
  const DeleteSecurity({Key? key}) : super(key: key);

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
      body: const DeleteSecurityStateful(),
    );
  }
}

// Sayfanın değişebilen iç kısımlarını oluşturan sınıf.
class DeleteSecurityStateful extends StatefulWidget
{
  // Yapıcı (Constructor) Method
  const DeleteSecurityStateful({Key? key}) : super(key: key);

  // createState metodu sayfanın içindeki tüm widget dediğimiz (buton, kayar liste vs.) elementleri oluşturur.
  @override
  State<DeleteSecurityStateful> createState() => _DeleteSecurityStateful();
}

// Sayfa içindeki widgetların özelliklerini sağlayan sınıf.
class _DeleteSecurityStateful extends State<DeleteSecurityStateful>
{
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

  // Oluşturulmuş bir güvenliği DELETE metoduyla silen metod. CRUD operasyonlarını yapan fonksiyonlar async olarak çalışmalıdır.
  Future<void> deleteSecurity(int id ,String mail, String password,String name, String lastName) async
  {
    bool isDone = false;

    // DELETE Metodu
    final response = await http.delete(
      Uri.parse('http://10.0.2.2:45455/api/guvenlikapi/Delete'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'email': mail,
        'password': password,
        'name': name,
        'lastname': lastName,
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
        desc: "Güvenlik silme işlemi başarılı!",
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
        desc: "Güvenlik bilgileri silinirken bir hata oluştu!\nOlası hata nedenleri:\n- Güvenlik bilgisi boş olabilir.\n- Güvenliğe bir rota grubu atanmış olabilir.",
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

  String valueFirst = "--Lütfen bir güvenlik seçiniz--"; // Kaydırılabilen listelerdeki ilk veriyi tutan değişken
  int idInt = 0;
  String name = "";
  String surname = "";
  String email = "";
  String password = "";

  //Widgetları oluşturan build methodu
  @override
  Widget build(BuildContext context)
  {
    // FutureBuilder metodu async olarak çalışan metodları birbirini beklemeden aynı anda çalıştırmasını sağlar.
    return FutureBuilder(
      future: getSecurityList(),
      builder: (context, AsyncSnapshot<Security> snapshot) // snapshot async olarak çalışan fonksiyonlardan gelen verileri tutar.
      {
        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData)
          {
            // Güvenlik Listesi
            List<String> lst = [];

            lst.add("--Lütfen bir güvenlik seçiniz--");
            for(int i = 0; i < snapshot.data!.employeeIDs.length; i++)
            {
              String fullName = snapshot.data!.employeeNames[i] + (" ") + snapshot.data!.employeeLastnames[i];
              lst.add(fullName);
            }


            return Padding(
              padding: const EdgeInsets.all(10),
              child: ListView(
                children: <Widget>[
                  Container(height: 140,),

                  // Güvenlik kayar listesi
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

                  Container(height: 20,),

                  // Bu butona tıkladığımızda eğer değerler gerekli koşulları sağlıyorsa güvenlik silme işlemi gerçekleşir.
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      child: const Text("Sil"),
                      onPressed: (){
                        if(valueFirst != "--Lütfen bir güvenlik seçiniz--")
                          {
                            for(int i = 0; i < snapshot.data!.employeeIDs.length; i++)
                            {
                              var str = snapshot.data!.employeeNames[i] + (" ") + snapshot.data!.employeeLastnames[i];

                              if(str == valueFirst)
                              {
                                idInt = snapshot.data!.employeeIDs[i];
                                name = snapshot.data!.employeeNames[i];
                                surname = snapshot.data!.employeeLastnames[i];
                                email = snapshot.data!.employeeMails[i];
                                password = snapshot.data!.employeePasswords[i];
                              }
                            }

                            // İşleme devam etmek isteyip istemediğimizi soran alert.
                            Alert(
                              context: context,
                              type: AlertType.warning,
                              title: "UYARI",
                              desc: "Güvenlik bilgileri silinecektir. Emin misiniz?",
                              buttons: [
                                DialogButton(
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true).pop();
                                    deleteSecurity(idInt, email, password, name, surname);
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