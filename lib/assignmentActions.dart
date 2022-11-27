import 'package:consec/add_assignment.dart';
import 'package:consec/delete_assignment.dart';
import 'package:consec/update_assignment.dart';
import 'package:flutter/material.dart';

class AssignmentActions extends StatelessWidget
{
  const AssignmentActions({Key? key}) : super(key: key);

  static const String _title = 'ConSec® - Yönetici';

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text(_title),
        backgroundColor: Colors.blue,
      ),
      body: const AssignmentActionsStateful(),
    );
  }
}

class AssignmentActionsStateful extends StatefulWidget
{
  const AssignmentActionsStateful({Key? key}) : super(key: key);

  @override
  State<AssignmentActionsStateful> createState() => _AssignmentActionsStateful();
}

class _AssignmentActionsStateful extends State<AssignmentActionsStateful>
{
  @override
  Widget build(BuildContext context)
  {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ListView(
        children: <Widget>[
          Container(height: 90,),
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const AddAssignment()));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent,
                      ),
                      child: const Text('Güvenliğe Devriye Ataması Yap', textAlign: TextAlign.center),
                    ),
                  ),

                  SizedBox(
                    height: 100,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: ()
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdateAssignment()));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent,
                      ),
                      child: const Text('Devriye Atamasını Düzenle', textAlign: TextAlign.center),
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const DeleteAssignment()));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent,
                      ),
                      child: const Text('Atama Bilgisi Sil', textAlign: TextAlign.center),
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