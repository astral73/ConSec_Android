import 'package:flutter/material.dart';
import 'dart:core';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';

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

// Sayfanın değişmeyen kısımlarını oluşturan, sayfanın genel iskeletini çizen sınıf.
class CreateReport extends StatelessWidget
{
  // Yapıcı (Constructor) Method
  const CreateReport({Key? key}) : super(key: key);

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
    body: const CreateReportStateful(),
    );
  }
}

// Sayfanın değişebilen iç kısımlarını oluşturan sınıf.
class CreateReportStateful extends StatefulWidget
{
  // Yapıcı (Constructor) Method
  const CreateReportStateful({Key? key}) : super(key: key);

  // createState metodu sayfanın içindeki tüm widget dediğimiz (buton, kayar liste vs.) elementleri oluşturur.
  @override
  State<CreateReportStateful> createState() => _CreateReportStateful();
}

// Sayfa içindeki widgetların özelliklerini sağlayan sınıf.
class _CreateReportStateful extends State<CreateReportStateful>
{
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
      throw Exception("Çalışmıyor!!");
    }
  }

  // Hareket listesini Get metoduyla alan metod. CRUD operasyonlarını yapan fonksiyonlar async olarak çalışmalıdır.
  Future<Movement> getMovement() async
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
      throw Exception("Çalışmıyor!!");
    }
  }

  // Telefonun içindeki Downloads klasörünü bulan fonksiyon
  Future<String?> getDownloadPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');

        if (!await directory.exists()) directory = await getExternalStorageDirectory();
      }
    } catch (err) {
      debugPrint("Cannot get download folder path");
    }
    return directory?.path;
  }

  String secValueFirst = "--Lütfen bir güvenlik seçiniz--";
  int secID = 0;

  //Widgetları oluşturan build methodu
  @override
  Widget build(BuildContext context)
  {
    // FutureBuilder metodu async olarak çalışan metodları birbirini beklemeden aynı anda çalıştırmasını sağlar.
    return FutureBuilder(
      future: Future.wait([getSecurityList(), getMovement()]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot){ // snapshot async olarak çalışan fonksiyonlardan gelen verileri tutar.
        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData)
          {
            List<String> securityLst = [];
            List<String> transDatesLst = [];
            List<int> routeLst = [];
            List<int> patrolLst = [];

            // Güvenlik Listesi
            securityLst.add("--Lütfen bir güvenlik seçiniz--");
            for(int i = 0; i < snapshot.data![0].employeeIDs.length; i++)
            {
              String fullName = snapshot.data![0].employeeNames[i] + (" ") + snapshot.data![0].employeeLastnames[i];
              securityLst.add(fullName);
            }

            // Widgetlarımızın özelliklerinin olduğu method.
            return Padding(
              padding: const EdgeInsets.all(10),
              child: ListView(
                children: <Widget>[
                  Container(height: 150,),
                  // Güvenlik kayar listesi
                  DropdownButton(
                    value: secValueFirst, // Seçilen değer

                    // Kalan liste elemanları
                    items: securityLst.map((String item){
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),

                    // Seçilen değer değiştiğinde onu bir değişkene atıyoruz.
                    onChanged: (String? newValue){
                      setState((){
                        secValueFirst = newValue!;
                      });
                    },
                  ),

                  Container(height: 20),

                  // Bu butona tıkladığımızda eğer değerler gerekli koşulları sağlıyorsa pdf halinde rapor oluşturma işlemi gerçekleşir.
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      child: const Text("Raporu Oluştur!"),
                      onPressed: (){
                        if(secValueFirst != "--Lütfen bir güvenlik seçiniz--")
                          {
                            // İşleme devam etmek isteyip istemediğimizi soran alert.
                            Alert(
                              context: context,
                              type: AlertType.warning,
                              title: "UYARI",
                              desc: "Bu güvenlik için rapor oluşturmak istediğinize emin misiniz?",
                              buttons: [
                                DialogButton(
                                  child: const Text("Evet", style: TextStyle(color: Colors.white, fontSize: 20)),
                                  onPressed:() async{
                                    for(int i = 0; i < snapshot.data![0].employeeIDs.length; i++)
                                    {
                                      var str = snapshot.data![0].employeeNames[i] + (" ") + snapshot.data![0].employeeLastnames[i];

                                      if(str == secValueFirst)
                                      {
                                        secID = snapshot.data![0].employeeIDs[i];
                                        break;
                                      }
                                    }

                                    for(int i = 0; i < snapshot.data![1].empIDs.length; i++)
                                    {
                                      if(snapshot.data![1].empIDs[i] == secID)
                                        {
                                          routeLst.add(snapshot.data![1].routeIDs[i]);
                                          patrolLst.add(snapshot.data![1].patrolIDs[i]);
                                          transDatesLst.add(snapshot.data![1].transDates[i]);
                                        }
                                    }

                                    var strLast = secValueFirst.toUpperCase().split("");

                                    for(int i = 0; i < strLast.length; i++)
                                      {
                                        if(strLast[i] == 'Ü')
                                          {
                                            strLast[i] = 'U';
                                          }

                                        if(strLast[i] == 'Ş')
                                          {
                                            strLast[i] = 'S';
                                          }

                                        if(strLast[i] == 'İ')
                                          {
                                            strLast[i] = 'I';
                                          }

                                        if(strLast[i] == 'Ö')
                                          {
                                            strLast[i] = 'O';
                                          }

                                        if(strLast[i] == 'Ç')
                                          {
                                            strLast[i] = 'C';
                                          }
                                      }

                                    String name = strLast.join("");

                                    String temp = name + (" - RAPOR KAYITLARI:\n----------------------------------------\n");

                                    for(int i = 0; i < routeLst.length; i++)
                                      {
                                        temp += ('- IDsi ') + (secID.toString()) + (' olan ') + (name) + (' isimli guvenlik gorevlisi, ') + (transDatesLst[i]) + (' tarih ve saatinde, ') + (patrolLst[i].toString()) + (' ID numarali devriyenin, ') + (routeLst[i].toString()) + (' ID numarali rotasinin QR kodunu okutmustur.\n\n');
                                      }

                                    String? path = await getDownloadPath();

                                    if(temp != name + (" - RAPOR KAYITLARI:\n----------------------------------------\n") && path != null)
                                      {
                                        // BEGIN: PDF dosyasını oluşturan kodlar
                                        final PdfDocument document = PdfDocument();
                                        final PdfPage page = document.pages.add();
                                        final PdfLayoutResult? layoutResult = PdfTextElement(
                                          text: temp,
                                            font: PdfStandardFont(PdfFontFamily.helvetica, 12),
                                            brush: PdfSolidBrush(PdfColor(0, 0, 0))
                                        ).draw(page: page,
                                            bounds: Rect.fromLTWH(
                                                0, 0, page.getClientSize().width, page.getClientSize().height),
                                            format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate));

                                        page.graphics.drawLine(
                                            PdfPen(PdfColor(255, 0, 0)),
                                            Offset(0, layoutResult!.bounds.bottom + 10),
                                            Offset(page.getClientSize().width, layoutResult.bounds.bottom + 10));
                                        File((path) + ("/") + (secID.toString()) + ('.pdf')).writeAsBytes(await document.save());
                                        // END: PDF dosyasını oluşturan kodlar

                                        Alert(
                                          context: context,
                                          type: AlertType.success,
                                          title: "BAŞARILI",
                                          desc: "Rapor oluşturma işlemi başarılı!",
                                          buttons: [
                                            DialogButton(
                                              onPressed: () {
                                                Navigator.of(context, rootNavigator: true).pop();
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
                                          desc: "Seçtiğiniz güvenliğe ait bir rapor kaydı bulunamamıştır!",
                                          buttons: [
                                            DialogButton(
                                              onPressed: () {
                                                Navigator.of(context, rootNavigator: true).pop();
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
                              ]
                            ).show();
                          }

                        else
                          {
                            Alert(
                              context: context,
                              type: AlertType.error,
                              title: "HATA",
                              desc: "Lütfen bir güvenlik seçiniz!",
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