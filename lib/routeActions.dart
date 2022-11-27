import 'package:consec/add_route.dart';
import 'package:consec/delete_route.dart';
import 'package:consec/update_route.dart';
import 'package:flutter/material.dart';

class RouteActions extends StatelessWidget
{
  const RouteActions({Key? key}) : super(key: key);

  static const String _title = 'ConSec® - Yönetici';

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text(_title),
        backgroundColor: Colors.blue,
      ),
      body: const RouteActionsStateful(),
    );
  }
}

class RouteActionsStateful extends StatefulWidget
{
  const RouteActionsStateful({Key? key}) : super(key: key);

  @override
  State<RouteActionsStateful> createState() => _RouteActionsStateful();
}

class _RouteActionsStateful extends State<RouteActionsStateful>
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const AddRoute()));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent,
                      ),
                      child: const Text('Rota Bilgisi Ekle', textAlign: TextAlign.center),
                    ),
                  ),

                  SizedBox(
                    height: 100,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: ()
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdateRoute()));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent,
                      ),
                      child: const Text('Rota Bilgisi Düzenle', textAlign: TextAlign.center),
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const DeleteRoute()));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent,
                      ),
                      child: const Text('Rota Bilgisi Sil', textAlign: TextAlign.center),
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