import 'package:consec/add_security.dart';
import 'package:consec/create_report.dart';
import 'package:consec/delete_security.dart';
import 'package:consec/update_security.dart';
import 'package:flutter/material.dart';

class SecurityActions extends StatelessWidget
{
  const SecurityActions({Key? key}) : super(key: key);

  static const String _title = 'ConSec® - Yönetici';

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text(_title),
        backgroundColor: Colors.blue,
      ),
      body: const SecurityActionsStateful(),
    );
  }
}

class SecurityActionsStateful extends StatefulWidget
{
  const SecurityActionsStateful({Key? key}) : super(key: key);

  @override
  State<SecurityActionsStateful> createState() => _SecurityActionsStateful();
}

class _SecurityActionsStateful extends State<SecurityActionsStateful>
{
  @override
  Widget build(BuildContext context)
  {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ListView(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  SizedBox(
                    height: 100,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: ()
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const AddSecurity()));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent,
                      ),
                      child: const Text('Güvenlik Görevlisi Bilgisi Ekle', textAlign: TextAlign.center),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: ()
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdateSecurity()));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent,
                      ),
                      child: const Text('Güvenlik Görevlisi Bilgisi Düzenle', textAlign: TextAlign.center),
                    ),
                  ),
                ],
              ),

              Container(height: 100),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,

                children: <Widget>[
                  SizedBox(
                    height: 100,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: ()
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const DeleteSecurity()));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent,
                      ),
                      child: const Text('Güvenlik Görevlisi Bilgisi Sil', textAlign: TextAlign.center),
                    ),
                  ),

                  SizedBox(
                    height: 100,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: ()
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateReport()));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent,
                      ),
                      child: const Text('Güvenlik Görevlisi Raporu Oluştur', textAlign: TextAlign.center),
                    ),
                  ),
                ],
              ),

              Container(height: 100),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,

                children: <Widget>[
                  SizedBox(
                    height: 100,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: ()
                      {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent,
                      ),
                      child: const Text('Geri Dön', textAlign: TextAlign.center),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}