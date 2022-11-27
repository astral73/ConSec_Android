import 'package:shared_preferences/shared_preferences.dart';
import 'admin.dart';
import 'security.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:io';
import 'package:json_annotation/json_annotation.dart';

// Giriş bilgilerini tutan model sınıfı.
@JsonSerializable()
class User {
  User({
    required this.adminEmails,
    required this.adminPasswords,
    required this.employeeEmails,
    required this.employeePasswords,
  });

  List<String> adminEmails;
  List<String> adminPasswords;
  List<String> employeeEmails;
  List<String> employeePasswords;

  // Json bilgilerini listelere atan fonksiyon
  factory User.fromJson(Map<String, dynamic> json) => User(
    adminEmails: List<String>.from(json["adminEmails"].map((x) => x)),
    adminPasswords: List<String>.from(json["adminPasswords"].map((x) => x)),
    employeeEmails: List<String>.from(json["employeeEmails"].map((x) => x)),
    employeePasswords: List<String>.from(json["employeePasswords"].map((x) => x)),
  );
}

// Ekrandaki değişmeyen kısmı tutan sınıf (Örneğin üstteki yazi)
class ConSecLogin extends StatelessWidget
{
  const ConSecLogin({Key? key}) : super(key: key);

  static const String _title = 'ConSec® - Giriş';

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(
            title: const Text(_title),
          backgroundColor: Colors.blue,
        ),
        body: const ConSecLoginStateful(),
      )
    );
  }
}

// Ekrandaki değişebilen kışmı tutan sınıf. (Örneğin butonlar.)
class ConSecLoginStateful extends StatefulWidget
{
  const ConSecLoginStateful({Key? key}) : super(key: key);

  @override
  State<ConSecLoginStateful> createState() => _ConSecLoginStateful();
}

// Giriş bilgilerini JSON olarak çekip model listelerine dağıtan sınıf.
Future<User> fetchInfo() async
{
  final apiUri = Uri.parse('http://10.0.2.2:45455/api/girisapi/Get');

  final response = await http.get(apiUri);

  if(response.statusCode == HttpStatus.ok)
  {
    final parsed = jsonDecode(response.body);
    return User.fromJson(parsed);
  }

  else
  {
    throw Exception("Çalışmıyor");
  }
}

// Kullanıcının etkileşime geçebildiği kısmı oluşturan sınıf (Örneğin: Text Labelları.)
class _ConSecLoginStateful extends State<ConSecLoginStateful>
{
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context)
  {
    // FutureBuilder future fonksiyonllarını async olarak çalıştıran fonksiyondur.
    return FutureBuilder(
      future: fetchInfo(),
      builder: (context, AsyncSnapshot<User> snapshot)
      {
        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData)
          {
            return Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
            children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
              'ConSec®',
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                  fontSize: 30
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                'Giriş Sayfası',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
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
                labelText: 'Kullanıcı e - Postası',
                labelStyle: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                )
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                  cursorColor: Colors.blue,
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 1.5),
                  ),
                  labelText: 'Şifre',
                  labelStyle: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  )
                ),
              ),
            ),
            Container(height: 20,),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: ElevatedButton(
                onPressed: () async
                {
                  bool isEmployee = true;
                  bool isFinished = true;

                  for(int i = 0; i < snapshot.data!.adminEmails.length; i++)
                  {
                    if(nameController.text == snapshot.data!.adminEmails[i] && passwordController.text == snapshot.data!.adminPasswords[i])
                    {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ConSecAdmin()));
                    isEmployee = false;
                    isFinished = false;
                    }
                  }

                  if(isEmployee)
                  {
                    for(int i = 0; i < snapshot.data!.employeeEmails.length; i++)
                    {
                      if(nameController.text == snapshot.data!.employeeEmails[i] && passwordController.text == snapshot.data!.employeePasswords[i])
                      {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setString("employeeMail", snapshot.data!.employeeEmails[i]); // SharedPreferences içine atıldığı veriyi uygulamanın her yerinde kullanabilmemizi sağlar.
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ConSecSecurity()));
                        isFinished = false;
                      }
                    }
                  }

                  if(isFinished)
                  {
                    Alert(
                      context: context,
                      type: AlertType.error,
                      title: "HATA",
                      desc: "Giriş başarısız! Bilgilerinizi kontrol ediniz.",
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
                child: const Text('Giriş'),
              )
            ),
          ],
        ),
    );
  }

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
            ],
          );
        }
  },

);
}
}