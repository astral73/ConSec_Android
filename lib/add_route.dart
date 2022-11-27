import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

// Sayfanın değişmeyen kısımlarını oluşturan, sayfanın genel iskeletini çizen sınıf.
class AddRoute extends StatelessWidget
{
  // Yapıcı (Constructor) Method
  const AddRoute({Key? key}) : super(key: key);

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
      body: const AddRouteStateful(),
    );
  }
}

// Sayfanın değişebilen iç kısımlarını oluşturan sınıf.
class AddRouteStateful extends StatefulWidget
{
  // Yapıcı (Constructor) Method
  const AddRouteStateful({Key? key}) : super(key: key);

  // createState metodu sayfanın içindeki tüm widget dediğimiz (buton, kayar liste vs.) elementleri oluşturur.
  @override
  State<AddRouteStateful> createState() => _AddRouteStateful();
}

// Sayfa içindeki widgetların özelliklerini sağlayan sınıf.
class _AddRouteStateful extends State<AddRouteStateful>
{
  // Yeni rota verilerini POST metoduyla gönderen metod. CRUD operasyonlarını yapan fonksiyonlar async olarak çalışmalıdır.
  Future<bool> addRoute(String name, String desc) async
  {
    bool isOK = true;
    
    try
        {
          // POST Metodu
          http.post(
            Uri.parse('http://10.0.2.2:45455/api/rotaapi/Post'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'name': name,
              'desc': desc,
            }),
          );
        }
        catch(x){
          // Hatalı bir bağlantı olduğunda değişken false oluyor.
          isOK = false;
        }

    // Son olarak bool değişkenini geri döndürüyoruz.
    return Future<bool>.value(isOK);
  }

  TextEditingController nameController = TextEditingController(); // Yazı yazılabilecek alandaki text metninin tutulması için gerekli değişken
  TextEditingController descController = TextEditingController(); // Yazı yazılabilecek alandaki text metninin tutulması için gerekli değişken

  String name = "";
  String desc = "";

  //Widgetları oluşturan build methodu
  @override
  Widget build(BuildContext context)
  {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ListView(
        children: <Widget>[
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
                  labelText: 'Rota İsmi',
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
                  labelText: 'Rota Açıklaması',
                  labelStyle: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  )
              ),
            ),
          ),
          Container(height: 20,),
          // Bu butona tıkladığımızda eğer değerler gerekli koşulları sağlıyorsa rota ekleme işlemi gerçekleşir.
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
                      desc: "Rota bilgilerini eklemek istediğinize emin misiniz?",
                      buttons: [
                        DialogButton(
                          onPressed: () async{
                            OK = await addRoute(name, desc);
                            Navigator.of(context, rootNavigator: true).pop();

                            if(OK == true)
                            {
                              Alert(
                                context: context,
                                type: AlertType.success,
                                title: "BAŞARILI",
                                desc: "Rota ekleme işlemi başarılı!",
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

                            else
                            {
                              Alert(
                                context: context,
                                type: AlertType.error,
                                title: "HATA",
                                desc: "Rota bilgisi eklenirken bir sıkıntı oluştu!",
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
                    desc: "Rota bilgileri boş olamaz!",
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
}