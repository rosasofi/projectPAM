import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class moneyConvert extends StatefulWidget {
  const moneyConvert({Key? key}) : super(key: key);

  @override
  State<moneyConvert> createState() => _moneyConvertState();
}

class _moneyConvertState extends State<moneyConvert> {
  var apiKey = 'fca_live_xtFj0eIq32x9YL7pTsdsScDLNsWTfHOE0ppapTmE';
  dynamic data;
  bool isLoading = false;
  var hasilKonversi;

  TextEditingController totalController = TextEditingController();
  List<String> currencies = ['SGD', 'EUR', 'MYR', 'USD'];
  String fromCurrency = 'SGD';
  String toCurrency = 'SGD';

  Future<void> convert(baseCurrency, currencies) async {
    var response = await http.get(
      Uri.parse(
        'https://api.freecurrencyapi.com/v1/latest?apikey=${apiKey}'
            '&base_currency=${baseCurrency}&currencies=${currencies},${baseCurrency}',
      ),
    );

    setState(() {
      data = json.decode(response.body);

      hasilKonversi = int.parse(totalController.text) *
          data['data']['$currencies'] /
          data['data']['$baseCurrency'];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  new AppBar(
        backgroundColor: Colors.brown[300],
        title: Text("Money Conversion",style: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.bold),),
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  height: 50,
                  child: DropdownButton<String>(
                    value: fromCurrency,
                    onChanged: (String? newValue) {
                      setState(() {
                        fromCurrency = newValue!;
                      });
                    },
                    items: currencies.map<DropdownMenuItem<String>>(
                          (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      },
                    ).toList(),
                    style: TextStyle(color: Colors.brown,fontFamily: 'Montserrat'),
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Icon(Icons.repeat),
              SizedBox(
                width: 20,
              ),
              Expanded(
                flex: 1,
                child: Container(
                  height: 50,
                  child: DropdownButton<String>(
                    value: toCurrency,
                    onChanged: (String? newValue) {
                      setState(() {
                        toCurrency = newValue!;
                      });
                    },
                    items: currencies.map<DropdownMenuItem<String>>(
                          (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      },
                    ).toList(),
                    style: TextStyle(color: Colors.brown,fontFamily: 'Montserrat'),
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 70,
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: totalController,
              decoration: InputDecoration(
                labelText: 'Jumlah Uang',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.brown),
                ),
                labelStyle: TextStyle(color: Colors.brown),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown[400],
              padding: EdgeInsets.all(10.0),
              fixedSize: Size(180, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // <-- Radius
              ),
            ),
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              convert(fromCurrency, toCurrency);
            },
            child: isLoading
                ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.pinkAccent,
              ),
            )
                :  Text('Convert', style: TextStyle(fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                fontSize: 12),),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                'Hasil Konversi',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.brown,
                ),
              ),
            ],
          ),

          data != null
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                    '${totalController.text} $fromCurrency = $hasilKonversi $toCurrency \n',
                style: TextStyle(fontSize: 20,fontFamily: 'Montserrat', color: Colors.brown),
              ),
            ],
          )
              : Center(
            child: Text(
              'Belum Ada Data',
              style: TextStyle(fontFamily: 'Montserrat', color: Colors.brown),
            ),
          ),
        ],
      ),
    );
  }
}
