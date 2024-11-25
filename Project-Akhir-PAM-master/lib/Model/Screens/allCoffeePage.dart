import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart'; // Untuk format mata uang
import 'package:project_pam/Helper/baseNetwork.dart';
import '../Coffees/CoffeeModel.dart';
import '../Detail/coffeeDetail.dart';

class CoffeeDataSource {
  static CoffeeDataSource instance = CoffeeDataSource();

  // Fungsi untuk mengambil data kopi dari API
  Future<List<dynamic>> LoadCoffees() {
    return BaseNetwork.get('hot'); // Mengambil data kopi dari endpoint 'hot'
  }
}

class AllCoffee extends StatefulWidget {
  const AllCoffee({Key? key}) : super(key: key);

  @override
  State<AllCoffee> createState() => _AllCoffeeState();
}

class _AllCoffeeState extends State<AllCoffee> {
  // Nilai tukar yang sudah disesuaikan sehingga 10,000 IDR = 1 USD
  final Map<String, double> exchangeRates = {
    'USD': 0.0001, // 10,000 IDR = 1 USD
    'IDR': 1.0, // IDR tetap 1:1
    'EUR': 0.000062, // 10,000 IDR = ~0.62 EUR
    'GBP': 0.000052, // 10,000 IDR = ~0.52 GBP
    'JPY': 0.009, // 10,000 IDR = ~9 JPY
    'AUD': 0.0001, // 10,000 IDR = ~0.1 AUD
    'CAD': 0.00009, // 10,000 IDR = ~0.09 CAD
    'CHF': 0.000062, // 10,000 IDR = ~0.062 CHF
    'CNY': 0.00045, // 10,000 IDR = ~0.45 CNY
    'INR': 0.0055, // 10,000 IDR = ~5.5 INR
  };

  final TextEditingController _searchController =
      TextEditingController(); // Controller untuk pencarian
  List<Coffee> _filteredCoffees =
      []; // Untuk menyimpan kopi yang sudah difilter
  bool _isSearching = false; // Menandakan apakah sedang mencari
  late Future<CoffeeDataModel> _coffeeData; // Data kopi dari API

  @override
  void initState() {
    super.initState();
    _coffeeData = CoffeeDataSource.instance.LoadCoffees().then((data) {
      return CoffeeDataModel.fromJson(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[300],
        title: const Text(
          "Our Coffees",
          style:
              TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        actions: [
          // Search Button
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _filteredCoffees.clear();
                }
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            // Promo Section (Buy 1 Get 1 Free)
            _buildPromoSection(),

            // Search Bar
            if (_isSearching)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: "Search Coffee...",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: _searchCoffees,
                ),
              ),

            // Coffee List
            Expanded(
              child: FutureBuilder<CoffeeDataModel>(
                future: _coffeeData,
                builder: (BuildContext context,
                    AsyncSnapshot<CoffeeDataModel> snapshot) {
                  if (snapshot.hasError) {
                    return _buildErrorSection();
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildLoadingSection();
                  }
                  if (snapshot.hasData) {
                    CoffeeDataModel coffeeModel = snapshot.data!;
                    // Menampilkan kopi yang sudah difilter atau semua kopi jika tidak ada pencarian
                    return _buildSuccessSection(coffeeModel);
                  }
                  return const Center(child: Text("No data available"));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Promo Section for Buy One Get One Free
  Widget _buildPromoSection() {
    return Container(
      margin:
          const EdgeInsets.symmetric(vertical: 10), // Margin agar lebih rapi
      padding: const EdgeInsets.all(16), // Padding agar lebih luas
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orangeAccent,
            Colors.deepOrange
          ], // Warna gradasi yang cerah
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(
            15), // Membulatkan sudut untuk tampilan lebih halus
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4), // Posisi bayangan sedikit ke bawah
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          // Ikon Promo dengan Warna Putih
          Icon(
            Icons.local_offer,
            color: Colors.white,
            size: 32, // Ukuran ikon lebih besar agar mencolok
          ),
          SizedBox(width: 12),
          // Teks Promo
          Expanded(
            child: Text(
              "Promo: Buy One Get One Free!",
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing:
                    1.2, // Memberikan jarak antar huruf agar lebih terbaca
              ),
              textAlign: TextAlign.center, // Agar teks lebih terpusat
            ),
          ),
        ],
      ),
    );
  }

  // Search Functionality
  void _searchCoffees(String query) {
    setState(() {
      _filteredCoffees = [];
    });

    _coffeeData.then((coffeeData) {
      final filteredCoffees = coffeeData.coffee?.where((coffee) {
        final coffeeName = coffee.title?.toLowerCase() ?? '';
        final searchQuery = query.toLowerCase();
        return coffeeName.contains(searchQuery);
      }).toList();

      setState(() {
        _filteredCoffees = filteredCoffees ?? [];
      });
    });
  }

  Widget _buildErrorSection() {
    return const Center(child: Text("Error loading coffee data"));
  }

  Widget _buildLoadingSection() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildSuccessSection(CoffeeDataModel data) {
    // Menampilkan kopi yang sudah difilter atau seluruh kopi jika pencarian kosong
    final coffeesToShow = _isSearching && _filteredCoffees.isNotEmpty
        ? _filteredCoffees
        : data.coffee;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
        childAspectRatio: (2.3 / 3.5),
      ),
      itemCount: coffeesToShow?.length ?? 0,
      itemBuilder: (BuildContext context, int index) {
        final Coffee coffee = coffeesToShow![index];
        return CoffeeCard(coffee: coffee, exchangeRates: exchangeRates);
      },
    );
  }
}

class CoffeeCard extends StatefulWidget {
  final Coffee coffee;
  final Map<String, double> exchangeRates;

  const CoffeeCard(
      {Key? key, required this.coffee, required this.exchangeRates})
      : super(key: key);

  @override
  _CoffeeCardState createState() => _CoffeeCardState();
}

class _CoffeeCardState extends State<CoffeeCard> {
  String selectedCurrency = 'IDR'; // Default currency is IDR
  int quantity = 1; // Initial quantity is 1

  // Harga tetap untuk masing-masing kopi berdasarkan title atau ID
  final Map<String, int> fixedPrices = {
    'Espresso': 15000,
    'Cappuccino': 20000,
    'Latte': 18000,
    'Americano': 14000,
    'Mocha': 22000,
    'Macchiato': 17000,
    'Flat White': 19000,
  };

  @override
  Widget build(BuildContext context) {
    final coffeeName = widget.coffee.title ?? 'Unknown Coffee';
    final basePrice =
        fixedPrices[coffeeName] ?? 15000; // Default harga jika tidak ditemukan

    final totalPriceInIDR = basePrice * quantity; // Total harga dalam IDR
    final convertedPrice = totalPriceInIDR *
        (widget.exchangeRates[selectedCurrency] ??
            1.0); // Total harga yang dikonversi

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CoffeeDetail(coffeePass: widget.coffee),
          ),
        );
      },
      child: Container(
        height: 230, // Increased height to accommodate price and quantity
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Coffee Image
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 2.0,
                    ),
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        widget.coffee.image ??
                            "https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png",
                      ),
                    ),
                  ),
                ),
                // Coffee Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    widget.coffee.title ?? "Unknown Coffee",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                // Coffee Price per unit in IDR
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Price: ${NumberFormat.currency(
                      locale: 'en_US',
                      symbol: 'IDR',
                    ).format(basePrice)}",
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                // Currency Dropdown
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: DropdownButton<String>(
                    value: selectedCurrency,
                    items: widget.exchangeRates.keys.map((String currency) {
                      return DropdownMenuItem<String>(
                        value: currency,
                        child: Text(currency),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedCurrency = value ?? 'IDR';
                      });
                    },
                  ),
                ),
                // Quantity selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (quantity > 1) quantity--;
                        });
                      },
                    ),
                    Text(
                      "$quantity",
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          quantity++;
                        });
                      },
                    ),
                  ],
                ),
                // Total Price Display based on quantity and selected currency
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Total: ${NumberFormat.currency(
                      locale: 'en_US',
                      symbol:
                          selectedCurrency, // Menampilkan harga dalam mata uang yang dipilih
                    ).format(convertedPrice)}",
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
