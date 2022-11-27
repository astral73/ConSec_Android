import 'package:consec/get_employee_assignment.dart';
import 'package:flutter/material.dart';

class ConSecSecurity extends StatelessWidget
{
  const ConSecSecurity({Key? key}) : super(key: key);

  static const String _title = 'ConSec® - Güvenlik';

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text(_title),
        backgroundColor: Colors.blue,
      ),
      body: const ConSecSecurityStateful(),
    );
  }
}

class ConSecSecurityStateful extends StatefulWidget
{
  const ConSecSecurityStateful({Key? key}) : super(key: key);

  @override
  State<ConSecSecurityStateful> createState() => _ConSecSecurityStateful();
}

class _ConSecSecurityStateful extends State<ConSecSecurityStateful>
{
  @override
  Widget build(BuildContext context)
  {
    return Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: <Widget>[
            Container(height: 200,),
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
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const getEmployeeAssignment()));
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blueAccent,
                          ),
                          child: const Text('Atanmış Rotayı Al', textAlign: TextAlign.center),
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
                          child: const Text('Çıkış Yap', textAlign: TextAlign.center),
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