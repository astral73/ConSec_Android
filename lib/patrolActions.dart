import 'package:consec/add_patrol.dart';
import 'package:consec/delete_patrol.dart';
import 'package:consec/update_patrol.dart';
import 'package:flutter/material.dart';

class PatrolActions extends StatelessWidget
{
  const PatrolActions({Key? key}) : super(key: key);

  static const String _title = 'ConSec® - Yönetici';

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text(_title),
        backgroundColor: Colors.blue,
      ),
      body: const PatrolActionsStateful(),
    );
  }
}

class PatrolActionsStateful extends StatefulWidget
{
  const PatrolActionsStateful({Key? key}) : super(key: key);

  @override
  State<PatrolActionsStateful> createState() => _PatrolActionsStateful();
}

class _PatrolActionsStateful extends State<PatrolActionsStateful>
{
  @override
  Widget build(BuildContext context)
  {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ListView(
        children: <Widget>[
          Container(height: 60,),
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const AddPatrol()));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent,
                      ),
                      child: const Text('Devriye Bilgisi Ekle', textAlign: TextAlign.center),
                    ),
                  ),

                  SizedBox(
                    height: 100,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: ()
                      {
                         Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdatePatrol()));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent,
                      ),
                      child: const Text('Devriye Bilgisi Düzenle', textAlign: TextAlign.center),
                    ),
                  ),
                ],
              ),

              Container(height: 160),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  SizedBox(
                    height: 100,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: ()
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const DeletePatrol()));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent,
                      ),
                      child: const Text('Devriye Bilgisi Sil', textAlign: TextAlign.center),
                    ),
                  ),
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
          ),
        ],
      ),
    );
  }
}