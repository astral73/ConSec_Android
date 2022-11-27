import 'package:consec/assignmentActions.dart';
import 'package:consec/patrolActions.dart';
import 'package:consec/routeActions.dart';
import 'package:consec/securityActions.dart';
import 'package:flutter/material.dart';

class ConSecAdmin extends StatelessWidget
{
  const ConSecAdmin({Key? key}) : super(key: key);

  static const String _title = 'ConSec® - Yönetici';


  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text(_title),
        backgroundColor: Colors.blue,
      ),
      body: const ConSecAdminStateful(),
    );
  }
}

class ConSecAdminStateful extends StatefulWidget
{
  const ConSecAdminStateful({Key? key}) : super(key: key);

  @override
  State<ConSecAdminStateful> createState() => _ConSecAdminStateful();
}

class _ConSecAdminStateful extends State<ConSecAdminStateful>
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SecurityActions()));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent,
                      ),
                      child: const Text('Güvenlik Görevlileri', textAlign: TextAlign.center),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: ()
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const RouteActions()));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent,
                      ),
                      child: const Text('Rotalar', textAlign: TextAlign.center,),
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const PatrolActions()));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent,
                      ),
                      child: const Text('Devriye Tanımları'),
                    ),
                  ),

                  SizedBox(
                    height: 100,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: ()
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const AssignmentActions()));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent,
                      ),
                      child: const Text('Atanmış Devriyeler', textAlign: TextAlign.center),
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
                      child: const Text('Çıkış Yap', textAlign: TextAlign.center),
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