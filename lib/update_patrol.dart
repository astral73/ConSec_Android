import 'package:flutter/material.dart';
import 'dart:core';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:rflutter_alert/rflutter_alert.dart';

// Get Metoduyla gelen devriye rotaları verileri için model sınıfı.
class PatrolRoute
{
  // Yapıcı (Constructor) Method
  PatrolRoute({
    required this.patrolRouteNames,
  });

  List<String> patrolRouteNames;

  // Bu method Get metoduyla gelen JSON verilerini model sınıfının içindeki değişkenlere dağıtmaktadır.
  factory PatrolRoute.fromJson(Map<String, dynamic> json) => PatrolRoute(
    patrolRouteNames: List<String>.from(json["patrolitems"].map((x) => x)),
  );
}

// Get Metoduyla gelen devriye verileri için model sınıfı.
class Patrol
{
  // Yapıcı (Constructor) Method
  Patrol({
    required this.patrolIDs,
    required this.patrolNums,
    required this.patrolNames,
    required this.patrolDescs,
  });

  List<int> patrolIDs;
  List<String> patrolNums;
  List<String> patrolNames;
  List<String> patrolDescs;

  // Bu method Get metoduyla gelen JSON verilerini model sınıfının içindeki değişkenlere dağıtmaktadır.
  factory Patrol.fromJson(Map<String, dynamic> json) => Patrol(
    patrolIDs: List<int>.from(json["patrolIDs"].map((x) => x)),
    patrolNums: List<String>.from(json["patrolNums"].map((x) => x)),
    patrolNames: List<String>.from(json["patrolNames"].map((x) => x)),
    patrolDescs: List<String>.from(json["patrolDescs"].map((x) => x)),
  );
}

// Get Metoduyla gelen rota verileri için model sınıfı.
class Route
{
  // Yapıcı (Constructor) Method
  Route({
    required this.routeIDs,
    required this.routeDescs,
    required this.routeNames,
  });

  List<int> routeIDs;
  List<String> routeDescs;
  List<String> routeNames;

  // Bu method Get metoduyla gelen JSON verilerini model sınıfının içindeki değişkenlere dağıtmaktadır.
  factory Route.fromJson(Map<String, dynamic> json) => Route(
    routeIDs: List<int>.from(json["routeIDs"].map((x) => x)),
    routeDescs: List<String>.from(json["routeDescs"].map((x) => x)),
    routeNames: List<String>.from(json["routeNames"].map((x) => x)),
  );
}

// Sayfanın değişmeyen kısımlarını oluşturan, sayfanın genel iskeletini çizen sınıf.
class UpdatePatrol extends StatelessWidget
{
  // Yapıcı (Constructor) Method
  const UpdatePatrol({Key? key}) : super(key: key);

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
      body: const UpdatePatrolStateful(),
    );
  }
}

// Sayfanın değişebilen iç kısımlarını oluşturan sınıf.
class UpdatePatrolStateful extends StatefulWidget
{
  // Yapıcı (Constructor) Method
  const UpdatePatrolStateful({Key? key}) : super(key: key);

  // createState metodu sayfanın içindeki tüm widget dediğimiz (buton, kayar liste vs.) elementleri oluşturur.
  @override
  State<UpdatePatrolStateful> createState() => _UpdatePatrolStateful();
}

// Sayfa içindeki widgetların özelliklerini sağlayan sınıf.
class _UpdatePatrolStateful extends State<UpdatePatrolStateful>
{
  int rRow = 1;

  // Seçilen devriyeyi PUT metoduyla güncelleyen metod. CRUD operasyonlarını yapan fonksiyonlar async olarak çalışmalıdır.
  Future<void> updatePatrol(String name, String desc, int id, List<List<int>> allRoutes) async
  {
    bool OK = false;

    // PUT Metodu
    final response = await http.put(
      Uri.parse('http://10.0.2.2:45455/api/devriyeapi/Put'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'desc': desc,
        'id': id,
        'patrolItems': allRoutes,
      }),
    );

    // Eğer hatasız bir şekilde işlem tamamlanırsa değişkeni true yapıyoruz.
    if(response.statusCode == HttpStatus.ok)
      {
        OK = true;
      }

    // Eğer bir hata olursa değişken false oluyor.
    else
      {
        OK = false;
      }

    // Eğer doğru bir şekilde bağlantı sağlandıysa (200 OK) başarılı alert mesajını kullanıcıya gösteriyoruz.
    if(OK == true)
    {
      Alert(
        context: context,
        type: AlertType.success,
        title: "BAŞARILI",
        desc: "Devriye güncelleme işlemi başarılı!",
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
        desc: "Devriye güncellenirken bir hata oluştu!",
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
  }

  List<List<int>> allRoutes = [];
  List<String> justroutes = [];

  // Devriye için seçilen rotaları bir listeye atan metod.
  void addRoutesToList(int routeID, int routeRow)
  {
    bool isDone = false;

    try{
      List<int> newPatrolItem = [];

      newPatrolItem.add(routeID);
      newPatrolItem.add(routeRow);

      justroutes.add(routeID.toString());

      allRoutes.add(newPatrolItem);

      isDone = true;
    }

    catch(x){
      isDone = false;
    }

    // Eğer atma işlemi başarılı olursa başarılı alertini yolluyoruz.
    if(isDone == true)
    {
      Alert(
        context: context,
        type: AlertType.success,
        title: "BAŞARILI",
        desc: "Devriyeye rota ekleme işlemi başarılı!",
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

    // Eğer atma işlemi başarısız olursa hata alertini yolluyoruz.
    else
    {
      Alert(
        context: context,
        type: AlertType.error,
        title: "HATA",
        desc: "Devriyeye rota bilgileri eklenirken bir hata oluştu!\nOlası hata nedenleri:\n- Rota bilgisi boş olabilir.",
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

  // Devriye rotaları listesini Get metoduyla alan metod. CRUD operasyonlarını yapan fonksiyonlar async olarak çalışmalıdır.
  Future<PatrolRoute> getPatrolRouteList() async
  {
    final apiUri = Uri.parse('http://10.0.2.2:45455/api/devriyerotalariapi/Get');

    // GET Metodu
    final response = await http.get(apiUri);

    // Eğer doğru bir şekilde bağlantı sağlandıysa (200 OK) body içindeki JSON verileri decode edip model sınıfının değişkenlerine dağıtıyoruz.
    if(response.statusCode == HttpStatus.ok)
    {
      final parsed = jsonDecode(response.body);
      return PatrolRoute.fromJson(parsed);
    }

    // Hatalı bir bağlantı olduğunda hata mesajı veriyoruz.
    else
    {
      throw Exception("Çalışmıyor!!");
    }
  }

  // Devriye listesini Get metoduyla alan metod. CRUD operasyonlarını yapan fonksiyonlar async olarak çalışmalıdır.
  Future<Patrol> getPatrolList() async
  {
    final apiUri = Uri.parse('http://10.0.2.2:45455/api/devriyeapi/Get');

    // GET Metodu
    final response = await http.get(apiUri);

    // Eğer doğru bir şekilde bağlantı sağlandıysa (200 OK) body içindeki JSON verileri decode edip model sınıfının değişkenlerine dağıtıyoruz.
    if(response.statusCode == HttpStatus.ok)
    {
      final parsed = jsonDecode(response.body);
      return Patrol.fromJson(parsed);
    }

    // Hatalı bir bağlantı olduğunda hata mesajı veriyoruz.
    else
    {
      throw Exception("Çalışmıyor!!");
    }
  }

  // Rota listesini Get metoduyla alan metod. CRUD operasyonlarını yapan fonksiyonlar async olarak çalışmalıdır.
  Future<Route> getRouteList() async
  {
    final apiUri = Uri.parse('http://10.0.2.2:45455/api/rotaapi/Get');

    // GET Metodu
    final response = await http.get(apiUri);

    // Eğer doğru bir şekilde bağlantı sağlandıysa (200 OK) body içindeki JSON verileri decode edip model sınıfının değişkenlerine dağıtıyoruz.
    if(response.statusCode == HttpStatus.ok)
    {
      final parsed = jsonDecode(response.body);
      return Route.fromJson(parsed);
    }

    // Hatalı bir bağlantı olduğunda hata mesajı veriyoruz.
    else
    {
      throw Exception("Çalışmıyor!!");
    }
  }

  bool delOk = false;

  // Oluşturulmuş bir devriyenin içindeki rotaları DELETE metoduyla silen metod. CRUD operasyonlarını yapan fonksiyonlar async olarak çalışmalıdır.
  Future<void> deletePatrolItems(List<String>patrolitems, int patrolID) async
  {
    // DELETE Metodu
    final response = await http.delete(
      Uri.parse('http://10.0.2.2:45455/api/devriyerotalariapi/Delete'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'patrolitems': patrolitems,
        'patrolID': patrolID,
      }),
    );

    // Eğer doğru bir şekilde bağlantı sağlandıysa (200 OK) bool türünde olan OK değişkenini true yapıyoruz.
    if(response.statusCode == HttpStatus.ok)
      {
        delOk = true;
      }

    // Eğer silme işlemi başarılı olursa başarılı alertini yolluyoruz.
    if(delOk == true)
    {
      Alert(
        context: context,
        type: AlertType.success,
        title: "BAŞARILI",
        desc: "Devriyenin rotalarının silinmesi işlemi başarılı!",
        buttons: [
          DialogButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              allRoutes = [];
              rRow = 1;
              setState((){});
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

    // Eğer silme işlemi başarısız olursa hata alertini yolluyoruz.
    else
    {
      Alert(
        context: context,
        type: AlertType.error,
        title: "HATA",
        desc: "Devriyenin rotalarının silinmesi sırasında bir hata oluştu!",
        buttons: [
          DialogButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              setState((){});
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

  TextEditingController nameController = TextEditingController(); // Yazı yazılabilecek alandaki text metninin tutulması için gerekli değişken
  TextEditingController descController = TextEditingController(); // Yazı yazılabilecek alandaki text metninin tutulması için gerekli değişken

  String name = "";
  String desc = "";
  String valueFirst = "--Lütfen bir rota seçiniz--";
  String patrolValueFirst = "--Lütfen bir devriye seçiniz--";
  String justPtName = "";
  int rID = 0;
  int pID = 0;

  //Widgetları oluşturan build methodu
  @override
  Widget build(BuildContext context)
  {
    // FutureBuilder metodu async olarak çalışan metodları birbirini beklemeden aynı anda çalıştırmasını sağlar.
    return FutureBuilder(
      future: Future.wait([getPatrolList(),getPatrolRouteList(),getRouteList()]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot){
        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData)
        {
          List<String> routeLst = [];
          List<String> patrolLst = [];
          List<String> justPRNames = [];
          List<String> tempPRNames = [];
          List<String> prRows = [];
          List<String> prNames = [];

          // Rota ve Devriye Listesi
          routeLst.add("--Lütfen bir rota seçiniz--");
          patrolLst.add("--Lütfen bir devriye seçiniz--");

          for(int i = 0; i < snapshot.data![2].routeIDs.length; i++)
          {
            String routeName = (i + 1).toString() + (")") + (" ") + snapshot.data![2].routeNames[i];
            routeLst.add(routeName);
          }

          for(int i = 0; i < snapshot.data![0].patrolIDs.length; i++)
          {
            String patrolName = (i + 1).toString() + (")") + (" ") + snapshot.data![0].patrolNames[i];
            patrolLst.add(patrolName);

            if(patrolName == patrolValueFirst)
            {
              pID = snapshot.data![0].patrolIDs[i];
              justPtName = snapshot.data![0].patrolNames[i];
            }
          }

          int counter = 0;
          for(int i = 0; i < snapshot.data![1].patrolRouteNames.length; i++)
          {
            List<String> temp = snapshot.data![1].patrolRouteNames[i].split(", ");

            int tmp = int.parse(temp[0]);

            if(pID == tmp)
            {
              tempPRNames.add(temp[1]);
              prRows.add(temp[2]);
              prNames.add(snapshot.data![1].patrolRouteNames[i]);
              counter = counter + 1;
            }
          }

          if(counter == 0)
            {
              rRow = allRoutes.length + 1;
            }

          else
            {
              rRow = counter + 1;
            }

          int ct = 1;
          for(int i = 0; i < tempPRNames.length; i++)
            {
              for(int j = 0; j < prRows.length; j++)
                {
                  if(ct.toString() == prRows[j])
                    {
                      justPRNames.add(tempPRNames[j]);
                    }
                }
              ct++;
            }

          // Widgetlarımızın özelliklerinin olduğu method.
          return Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                // Devriye kayar listesi
                DropdownButton(
                  value: patrolValueFirst, // Seçilen değer

                  // Kalan liste elemanları
                  items: patrolLst.map((String item){
                    return DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),

                  // Seçilen değer değiştiğinde onu bir değişkene atıyoruz.
                  onChanged: (String? newValue){
                    setState((){
                      patrolValueFirst = newValue!;
                    });
                  },
                ),
                Container(height: 20),
                Text("Seçilen Devriye: ${justPtName != "" ? justPtName : "Hiçbir devriye seçilmedi!"}"), // Seçilen devriyeyi gösteren Text yazısı.
                Container(height: 20),

                // Rota kayar listesi
                DropdownButton(
                  value: valueFirst, // Seçilen değer

                  // Kalan liste elemanları
                  items: routeLst.map((String item){
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
                Container(height: 20),
                // Seçilmiş Devriyenin tüm rotalarını gösteren Text yazısı.
                Text(("Seçilmiş Devriyenin Tüm Rotaları: ") + (justPRNames.isNotEmpty ? (justPRNames.reduce((value, element) => value + (' ') + element))  : "") + (justroutes.isNotEmpty ? ((" ") + justroutes.reduce((value, element) => value + (' ') + element))  : "")),
                Container(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    // Bu butona tıkladığımızda eğer değerler gerekli koşulları sağlıyorsa devriyeye rota ekleme işlemi gerçekleşir.
                    SizedBox(
                      child: ElevatedButton(
                        child: const Text("Rota Ekle"),
                        onPressed: (){
                          if(valueFirst != "--Lütfen bir rota seçiniz--")
                          {
                            for(int i = 0; i < snapshot.data![2].routeIDs.length; i++)
                            {
                              var str = (i + 1).toString() + (")") + (" ") + snapshot.data![2].routeNames[i];

                              if(str == valueFirst)
                              {
                                rID = snapshot.data![2].routeIDs[i];
                              }
                            }

                            // İşleme devam etmek isteyip istemediğimizi soran alert.
                            Alert(
                              context: context,
                              type: AlertType.warning,
                              title: "UYARI",
                              desc: "Rota bilgisi eklenecektir. Emin misiniz?",
                              buttons: [
                                DialogButton(
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true).pop();
                                    addRoutesToList(rID, rRow);
                                    rRow++;
                                    setState(() {});
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
                                  },
                                  width: 120,
                                  child: const Text("Hayır", style: TextStyle(color: Colors.white, fontSize: 20)),
                                ),
                              ],
                            ).show();
                          }
                        },
                      ),
                    ),

                    // Bu butona tıkladığımızda eğer değerler gerekli koşulları sağlıyorsa devriyenin içindeki rotaların silinmesi işlemi gerçekleşir.
                    SizedBox(
                      child: ElevatedButton(
                        onPressed: ()
                        {
                          // İşleme devam etmek isteyip istemediğimizi soran alert.
                          Alert(
                              context: context,
                              type: AlertType.warning,
                              title: "UYARI",
                              desc: "Seçilmiş devriyenin tüm rota bilgileri silinecektir. Emin misiniz?",
                              buttons: [
                                DialogButton(
                                  child: const Text(
                                    "Evet",
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                  onPressed: () async{
                                    Navigator.of(context, rootNavigator: true).pop();
                                    for(int i = 0; i < snapshot.data![1].patrolRouteNames.length; i++)
                                    {
                                      List<String> temp = snapshot.data![1].patrolRouteNames[i].split(", ");
                                      int tmp = int.parse(temp[0]);

                                      if(pID == tmp)
                                      {
                                        deletePatrolItems(prNames, pID);
                                        break;
                                      }
                                    }
                                    justroutes = [];
                                    allRoutes = [];
                                  },
                                ),
                                DialogButton(
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true).pop();
                                  },
                                  width: 120,
                                  child: const Text(
                                    "Hayır",
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ],
                          ).show();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blueAccent,
                        ),
                        child: const Text('Rotaları Sil'),
                      ),
                    ),
                  ],
                ),

                // Yazı yazılabilen alan
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
                        labelText: 'Devriye İsmi',
                        labelStyle: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        )
                    ),
                  ),
                ),

                // Yazı yazılabilen alan
                Container(
                  padding: const EdgeInsets.all(10),
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
                        labelText: 'Devriye Açıklaması',
                        labelStyle: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        )
                    ),
                  ),
                ),

                // Bu butona tıkladığımızda eğer değerler gerekli koşulları sağlıyorsa devriye güncelleme işlemi gerçekleşir.
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                      child: const Text('Devriye Güncelle'),
                      onPressed: () async{
                        if(nameController.text != "" && descController.text != "")
                        {
                          name = nameController.text;
                          desc = descController.text;

                          // İşleme devam etmek isteyip istemediğimizi soran alert.
                          Alert(
                            context: context,
                            type: AlertType.warning,
                            title: "UYARI",
                            desc: "Devriye bilgilerini güncellemek istediğinize emin misiniz?",
                            buttons: [
                              DialogButton(
                                onPressed: () async{
                                  Navigator.of(context, rootNavigator: true).pop();
                                  updatePatrol(name, desc, pID, allRoutes);
                                },
                                width: 120,
                                child: const Text("Evet", style: TextStyle(color: Colors.white, fontSize: 20)),
                              ),
                              DialogButton(
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true).pop();
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
                            desc: "Devriye bilgileri boş olamaz!",
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
                Container(height: 20),

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
        else
          {
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