import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

// Get Metoduyla gelen atama verileri için model sınıfı.
class Assignment
{
  // Yapıcı (Constructor) Method
  Assignment({
    required this.employeeIDs,
    required this.patrolIDs,
    required this.resumptionTimes
  });

  List<int> employeeIDs;
  List<int> patrolIDs;
  List<double> resumptionTimes;

  // Bu method Get metoduyla gelen JSON verilerini model sınıfının içindeki değişkenlere dağıtmaktadır.
  factory Assignment.fromJson(Map<String, dynamic> json) => Assignment(
    employeeIDs: List<int>.from(json["employeeIDs"].map((x) => x)),
    patrolIDs: List<int>.from(json["patrolIDs"].map((x) => x)),
    resumptionTimes: List<double>.from(json["resumptionTimes"].map((x) => x)),
  );
}

// Get Metoduyla gelen hareket verileri için model sınıfı.
class Movement
{
  // Yapıcı (Constructor) Method
  Movement({
    required this.empIDs,
    required this.routeIDs,
    required this.transDates,
    required this.patrolIDs
  });

  List<int> empIDs;
  List<int> routeIDs;
  List<int> patrolIDs;
  List<String> transDates;

  // Bu method Get metoduyla gelen JSON verilerini model sınıfının içindeki değişkenlere dağıtmaktadır.
  factory Movement.fromJson(Map<String, dynamic> json) => Movement(
    empIDs: List<int>.from(json["empIDs"].map((x) => x)),
    routeIDs: List<int>.from(json["routeIDs"].map((x) => x)),
    patrolIDs: List<int>.from(json["patrolIDs"].map((x) => x)),
    transDates: List<String>.from(json["transDates"].map((x) => x)),
  );
}

// Get Metoduyla gelen güvenlik verileri için model sınıfı.
class Security
{
  // Yapıcı (Constructor) Method
  Security({
    required this.employeeIDs,
    required this.employeeMails,
    required this.employeePasswords,
    required this.employeeNames,
    required this.employeeLastnames,
  });

  List<int> employeeIDs;
  List<String> employeeMails;
  List<String> employeePasswords;
  List<String> employeeNames;
  List<String> employeeLastnames;

  // Bu method Get metoduyla gelen JSON verilerini model sınıfının içindeki değişkenlere dağıtmaktadır.
  factory Security.fromJson(Map<String, dynamic> json) => Security(
      employeeIDs: List<int>.from(json["employeeIDs"].map((x) => x)),
      employeeMails: List<String>.from(json["employeeMails"].map((x) => x)),
      employeePasswords: List<String>.from(json["employeePasswords"].map((x) => x)),
      employeeNames: List<String>.from(json["employeeNames"].map((x) => x)),
      employeeLastnames: List<String>.from(json["employeeLastnames"].map((x) => x))
  );
}

// Get Metoduyla gelen devriye bilgileri için model sınıfı.
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

// Get Metoduyla gelen devriye rotaları bilgileri için model sınıfı.
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

// Get Metoduyla gelen rota bilgileri için model sınıfı.
class Route
{
  // Yapıcı (Constructor) Method
  Route({
    required this.routeIDs,
    required this.routeDescs,
    required this.routeNames,
    required this.routeCodes,
  });

  List<int> routeIDs;
  List<String> routeDescs;
  List<String> routeNames;
  List<String> routeCodes;

  // Bu method Get metoduyla gelen JSON verilerini model sınıfının içindeki değişkenlere dağıtmaktadır.
  factory Route.fromJson(Map<String, dynamic> json) => Route(
    routeIDs: List<int>.from(json["routeIDs"].map((x) => x)),
    routeDescs: List<String>.from(json["routeDescs"].map((x) => x)),
    routeNames: List<String>.from(json["routeNames"].map((x) => x)),
    routeCodes: List<String>.from(json["routeCodes"].map((x) => x)),
  );
}

// Sayfanın değişmeyen kısımlarını oluşturan, sayfanın genel iskeletini çizen sınıf.
class getEmployeeAssignment extends StatelessWidget
{
  // Yapıcı (Constructor) Method
  const getEmployeeAssignment({Key? key}) : super(key: key);

  // Sayfanın üstünde yer alan isim değişkeni
  static const String _title = 'ConSec® - Güvenlik';

  // Build metodu sayfanın widgetlarını ekrana koyar.
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text(_title),
        backgroundColor: Colors.blue,
      ),
      body: const getEmployeeAssignmentStateful(),
    );
  }
}

// Sayfanın değişebilen iç kısımlarını oluşturan sınıf.
class getEmployeeAssignmentStateful extends StatefulWidget
{
  // Yapıcı (Constructor) Method
  const getEmployeeAssignmentStateful({Key? key}) : super(key: key);

  // createState metodu sayfanın içindeki tüm widget dediğimiz (buton, kayar liste vs.) elementleri oluşturur.
  @override
  State<getEmployeeAssignmentStateful> createState() => _getEmployeeAssignmentStateful();
}

// Sayfa içindeki widgetların özelliklerini sağlayan sınıf.
class _getEmployeeAssignmentStateful extends State<getEmployeeAssignmentStateful>
{
  // Giriş yapmış e - postayı SharedPreferences sınıfının içindeki getInstance metodu alan metod. Login kısmında biz bu e - postayı SharedPreferences sınıfının setString metodu ile uygulama içinde her yerde kullanabiliyoruz..
  Future<String?> getMail() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? mail = prefs.getString("employeeMail");

    return mail;
  }

  bool control1 = true;
  bool control2 = true;
  bool control3 = true;
  bool control4 = true;
  bool control5 = true;
  bool control6 = true;
  bool control7 = true;

  // Atama listesini Get metoduyla alan metod. CRUD operasyonlarını yapan fonksiyonlar async olarak çalışmalıdır.
  Future<Assignment> getAssignmentList() async
  {
      final apiUri = Uri.parse('http://10.0.2.2:45455/api/atamaapi/Get');

      // GET Metodu
      final response = await http.get(apiUri);

      // Eğer doğru bir şekilde bağlantı sağlandıysa (200 OK) body içindeki JSON verileri decode edip model sınıfının değişkenlerine dağıtıyoruz.
      if(response.statusCode == HttpStatus.ok)
      {
        final parsed = jsonDecode(response.body);
        return Assignment.fromJson(parsed);
      }

      // Hatalı bir bağlantı olduğunda hata mesajı veriyoruz.
      else
      {
        control1 = false;
        throw const SocketException("Error");
      }
  }

  // Hareket listesini Get metoduyla alan metod. CRUD operasyonlarını yapan fonksiyonlar async olarak çalışmalıdır.
  Future<Movement> getMovements() async
  {
      final apiUri = Uri.parse('http://10.0.2.2:45455/api/hareketapi/Get');

      // GET Metodu
      final response = await http.get(apiUri);

      // Eğer doğru bir şekilde bağlantı sağlandıysa (200 OK) body içindeki JSON verileri decode edip model sınıfının değişkenlerine dağıtıyoruz.
      if(response.statusCode == HttpStatus.ok)
      {
        final parsed = jsonDecode(response.body);
        return Movement.fromJson(parsed);
      }

      // Hatalı bir bağlantı olduğunda hata mesajı veriyoruz.
      else
      {
        control2 = false;
        throw const SocketException("Error");
      }
  }

  // Güvenlik listesini Get metoduyla alan metod. CRUD operasyonlarını yapan fonksiyonlar async olarak çalışmalıdır.
  Future<Security> getSecurityList() async
  {
      final apiUri = Uri.parse('http://10.0.2.2:45455/api/guvenlikapi/Get');

      // GET Metodu
      final response = await http.get(apiUri);

      // Eğer doğru bir şekilde bağlantı sağlandıysa (200 OK) body içindeki JSON verileri decode edip model sınıfının değişkenlerine dağıtıyoruz.
      if(response.statusCode == HttpStatus.ok)
      {
        final parsed = jsonDecode(response.body);
        return Security.fromJson(parsed);
      }

      // Hatalı bir bağlantı olduğunda hata mesajı veriyoruz.
      else
      {
        control3 = false;
        throw const SocketException("Error");
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
        control4 = false;
        throw const SocketException("Error");
      }
  }

  // Devriyelerin içindeki rotaların listesini Get metoduyla alan metod. CRUD operasyonlarını yapan fonksiyonlar async olarak çalışmalıdır.
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
        control5 = false;
        throw const SocketException("Error");
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
        control6 = false;
        throw const SocketException("Error");
      }
  }

  // Güvenliğin okuttuğu QR kodlardan doğan verileri hareket olarak POST metoduyla kaydeden metod. CRUD operasyonlarını yapan fonksiyonlar async olarak çalışmalıdır.
  Future<String> addMovements(int empID, int routeID, int patrolID) async
  {
    // POST Metodu
      final response = await http.post(
        Uri.parse('http://10.0.2.2:45455/api/hareketapi/Post'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'empID': empID,
          'routeID': routeID,
          'patrolID': patrolID
        }),
      );

      // Eğer doğru bir şekilde bağlantı sağlandıysa (200 OK) "OK" mesajını dönüyoruz.
      if(response.statusCode == HttpStatus.ok)
      {
        return "OK";
      }

      // Eğer bağlantı sonucu Bad Request (400 BAD REQUEST) ise aşağıdakı mesajı dönüyoruz.
      else if(response.statusCode == HttpStatus.badRequest)
      {
        control7 = false;
        return "30 dakika dolmadan yeni QR okutamazsınız! Lütfen daha sonra tekrar deneyiniz!";
      }

      // Hatalı bir bağlantı olduğunda "Bağlantı sorunu!" mesajını dönüyoruz.
      else
      {
        control7 = false;
        return "Bağlantı sorunu!";
      }
  }

  // QR Kodu kamera vasıtasıyla okutmamızı sağlayan fonksiyon.
  Future<String> scanQR() async {
    String _scanBarcode = 'Unknown'; // QR'ın içindeki string değeri
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return "Unknown";

    _scanBarcode = barcodeScanRes;

    return _scanBarcode;
  }

  int counter = 1;
  String f = "";

  //Widgetları oluşturan build methodu
  @override
  Widget build(BuildContext context)
  {
    // FutureBuilder metodu async olarak çalışan metodları birbirini beklemeden aynı anda çalıştırmasını sağlar.
    return FutureBuilder(
      future: Future.wait([getMail() ,getAssignmentList(), getSecurityList(), getPatrolList(), getPatrolRouteList(), getRouteList()]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) { // snapshot async olarak çalışan fonksiyonlardan gelen verileri tutar.
        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData)
          {
            String email = snapshot.data![0];
            int loggedEmpID = 0;
            int assignedPatrolID = 0;
            List<String> prNames = [];
            List<String> rRows = [];
            List<String> prOrderedList = [];
            List<String> prOrderedCodes = [];


            for(int i = 0; i < snapshot.data![2].employeeMails.length; i++)
            {
              if(email == snapshot.data![2].employeeMails[i])
              {
                loggedEmpID = snapshot.data![2].employeeIDs[i];
                break;
              }
            }


            for(int i = 0; i < snapshot.data![1].employeeIDs.length; i++)
            {
              if(loggedEmpID == snapshot.data![1].employeeIDs[i])
              {
                assignedPatrolID = snapshot.data![1].patrolIDs[i];
                break;
              }
            }

            for(int i = 0; i < snapshot.data![4].patrolRouteNames.length; i++)
            {
              List<String> temp = snapshot.data![4].patrolRouteNames[i].split(", ");

              int tmp = int.parse(temp[0]);

              if(assignedPatrolID == tmp)
              {
                prNames.add(temp[1]);
                rRows.add(temp[2]);
              }
            }

            int c = 1;
            for(int i = 0; i < prNames.length; i++)
            {
              for(int j = 0; j < rRows.length; j++)
              {
                if(rRows[j] == c.toString())
                {
                  prOrderedList.add(prNames[j]);
                  c++;
                }
              }
            }

            for(int i = 0; i < prOrderedList.length; i++)
            {
              for(int j = 0; j < snapshot.data![5].routeIDs.length; j++)
              {
                if(prOrderedList[i] == snapshot.data![5].routeIDs[j].toString())
                {
                  prOrderedCodes.add(snapshot.data![5].routeCodes[j]);
                }
              }
            }

            // Widgetlarımızın özelliklerinin olduğu method.
            return Padding(
              padding: const EdgeInsets.all(10),
              child: ListView(
                children: <Widget>[
                  Container(height: 150,),
                  Text(("Lütfen ") + prOrderedList[counter - 1] + (" numaralı rotaya gidip QR kodu taratınız."), textAlign: TextAlign.center), // Güvenliğin gitmesi gereken rotanın QR kodunu söyleyen Text yazısı.
                  Container(height: 50,),

                  // QR kodun taranması için kamerayı açan ve okuduğu QR koda göre sonuç üreten buton.
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                        child: const Text("QR Kodu Tara"),
                        onPressed: () async{
                          String _scanBarcode = await scanQR();

                          String code = prOrderedList[counter - 1] + ("\n") + prOrderedCodes[counter - 1];

                          if(_scanBarcode == code)
                          {
                            String last = "";

                            try
                            {
                              last = await addMovements(loggedEmpID, int.parse(prOrderedList[counter - 1]), assignedPatrolID);
                            }
                            catch(x){
                              last = x.toString();
                            }

                            // Güvenlik iki rotayı ard arda okutamaz. İki rota arasında 30 dakikalık bir zaman farkı belirlenmiştir. (İsteğe göre API içinden değiştirilebilir.)
                            if(last == "30 dakika dolmadan yeni QR okutamazsınız! Lütfen daha sonra tekrar deneyiniz!")
                            {
                              Alert(
                                context: context,
                                type: AlertType.error,
                                title: "HATA",
                                desc: last,
                                buttons: [
                                  DialogButton(
                                    onPressed: () async{
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

                            // Eğer bir sıkıntı yoksa 2 durum oluşur.
                            if(last == "OK")
                            {
                              counter = counter + 1;

                              // Eğer devriye tamamlanırsa başarılı alert mesajı döndürülür.
                              if(counter > prOrderedList.length)
                              {
                                Alert(
                                  context: context,
                                  type: AlertType.success,
                                  title: "BAŞARILI",
                                  desc: "Devriye tamamlandı!",
                                  buttons: [
                                    DialogButton(
                                      onPressed: () async{
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

                              // Tamamlanmazsa sıralama için kullanılan counter değişkeni 1 arttırılıp sayfa yenilenir.

                              setState((){});
                            }
                          }

                          // Eğer QR kod okunamazsa ya da yanlış QR kod okunursa hata alerti gösterilir.
                          else
                          {
                            Alert(
                              context: context,
                              type: AlertType.error,
                              title: "HATA",
                              desc: "QR Kod okunamadı ya da yanlış QR kod okundu! Lütfen tekrar deneyiniz!",
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
                    ),
                  ),

                  Container(height: 30),

                  // Devriyeyi bitir butonu eğer istenirse devriyeden erken çıkılmak istenirse kullanılabilir.
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                        child: const Text("Devriyeyi Bitir"),
                        onPressed: (){
                          Navigator.pop(context);
                        }
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