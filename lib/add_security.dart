import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

// Sayfanın değişmeyen kısımlarını oluşturan, sayfanın genel iskeletini çizen sınıf.
class AddSecurity extends StatelessWidget
{
  // Yapıcı (Constructor) Method
  const AddSecurity({Key? key}) : super(key: key);

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
      body: const AddSecurityStateful(),
    );
  }
}

// Sayfanın değişebilen iç kısımlarını oluşturan sınıf.
class AddSecurityStateful extends StatefulWidget
{
  // Yapıcı (Constructor) Method
  const AddSecurityStateful({Key? key}) : super(key: key);

  // createState metodu sayfanın içindeki tüm widget dediğimiz (buton, kayar liste vs.) elementleri oluşturur.
  @override
  State<AddSecurityStateful> createState() => _AddSecurityStateful();
}

// Sayfa içindeki widgetların özelliklerini sağlayan sınıf.
class _AddSecurityStateful extends State<AddSecurityStateful>
{
  // Yeni güvenlik verilerini POST metoduyla gönderen metod. CRUD operasyonlarını yapan fonksiyonlar async olarak çalışmalıdır.
  Future<bool> addSecurity(String mail, String password,String name, String lastName) async
  {
    bool isOK = true;

    try
        {
          // POST Metodu
          http.post(
            Uri.parse('http://10.0.2.2:45455/api/guvenlikapi/Post'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'email': mail,
              'password': password,
              'name': name,
              'lastname': lastName,
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
  TextEditingController lastNameController = TextEditingController(); // Yazı yazılabilecek alandaki text metninin tutulması için gerekli değişken
  TextEditingController mailController = TextEditingController(); // Yazı yazılabilecek alandaki text metninin tutulması için gerekli değişken
  TextEditingController passwordController = TextEditingController(); // Yazı yazılabilecek alandaki text metninin tutulması için gerekli değişken

  String name = "";
  String lastName = "";
  String mail = "";
  String password = "";

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
                  labelText: 'Güvenlik İsmi',
                  labelStyle: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  )
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              // Yazı yazılabilen alan
              cursorColor: Colors.blue,
              controller: lastNameController,
              decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 1.5),
                  ),
                  labelText: 'Güvenlik Soyismi',
                  labelStyle: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  )
              ),
            ),
          ),
          Container(
            // Yazı yazılabilen alan
            padding: const EdgeInsets.all(10),
            child: TextField(
              cursorColor: Colors.blue,
              controller: mailController,
              decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 1.5),
                  ),
                  labelText: 'Güvenlik e - Postası',
                  labelStyle: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  )
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              // Yazı yazılabilen alan
              cursorColor: Colors.blue,
              controller: passwordController,
              obscureText: true, // Girilen metni gizlemek için bu kısmı true yapmalıyız.
              decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 1.5),
                  ),
                  labelText: 'Güvenlik Şifresi',
                  labelStyle: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  )
              ),
            ),
          ),
          Container(height: 30,),
          // Bu butona tıkladığımızda eğer değerler gerekli koşulları sağlıyorsa güvenlik ekleme işlemi gerçekleşir.
          SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () async
                {
                  if(nameController.text != "" && lastNameController.text != "" && mailController.text != "" && passwordController.text != "")
                  {
                    name = nameController.text;
                    lastName = lastNameController.text;
                    mail = mailController.text;
                    password = passwordController.text;
                    bool OK = false;

                    // İşleme devam etmek isteyip istemediğimizi soran alert.
                    Alert(
                      context: context,
                      type: AlertType.warning,
                      title: "UYARI",
                      desc: "Güvenlik bilgilerini eklemek istediğinize emin misiniz?",
                      buttons: [
                        DialogButton(
                          onPressed: () async{
                            OK = await addSecurity(mail, password, name, lastName);
                            Navigator.of(context, rootNavigator: true).pop();

                            if(OK == true)
                            {
                              Alert(
                                context: context,
                                type: AlertType.success,
                                title: "BAŞARILI",
                                desc: "Güvenlik ekleme işlemi başarılı!",
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
                                desc: "Güvenlik bilgisi eklenirken bir sıkıntı oluştu!",
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
                      desc: "Güvenlik bilgileri boş olamaz!",
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
                child: const Text('Ekle'),
              )
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