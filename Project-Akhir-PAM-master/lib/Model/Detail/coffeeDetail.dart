import 'package:flutter/material.dart';
import '../Coffees/CoffeeModel.dart'; // Pastikan model ini berisi data coffee

class CoffeeDetail extends StatefulWidget {
  final Coffee? coffeePass;
  const CoffeeDetail({Key? key, required this.coffeePass}) : super(key: key);

  @override
  State<CoffeeDetail> createState() => _CoffeeDetailState();
}

class _CoffeeDetailState extends State<CoffeeDetail> {
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
  }

  // Fungsi untuk menampilkan Overlay notifikasi yang bertahan lama
  void showOrderOverlay(BuildContext context) {
    final overlay = Overlay.of(context);

    if (overlay == null) {
      print("Overlay is null, cannot insert overlay.");
      return;
    }

    // Membuat OverlayEntry hanya sekali
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top +
            10, // Letakkan sedikit di bawah status bar
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: () {
              print("Tapped outside, removing overlay.");
              removeOverlay(); // Menghapus overlay dengan metode yang aman
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10), // Padding lebih kecil
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 91, 155, 27), // Warna WhatsApp hijau
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(12)), // Sudut atas dibulatkan
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5.0,
                    spreadRadius: 1.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: Colors.white,
                        size: 22, // Ukuran ikon lebih kecil
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Pemesanan berhasil, silakan lanjut ke pembayaran.",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15), // Ukuran teks lebih kecil
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white, size: 20),
                    onPressed: () {
                      print("Close button pressed, removing overlay.");
                      removeOverlay(); // Menghapus overlay dengan metode yang aman
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    print("Inserting overlay...");
    overlay.insert(_overlayEntry!);

    // Menunggu beberapa detik kemudian menghapus overlay otomatis
    Future.delayed(Duration(seconds: 5), () {
      print("Removing overlay after delay.");
      removeOverlay();
    });
  }

  // Fungsi untuk menghapus overlay dengan aman
  void removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null; // Set overlayEntry ke null setelah dihapus
      print("Overlay removed.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.coffeePass?.title}",
            style: TextStyle(
                fontFamily: 'Montserrat', fontWeight: FontWeight.w600)),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.brown[100],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.brown[300],
      ),
      body: Container(
        color: Colors.brown[100],
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              // Coffee Image Section
              Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Coffee Image
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 2.0,
                          ),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage("${widget.coffeePass?.image}"),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      // Deskripsi dan Ingredients
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "${widget.coffeePass?.description}",
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 23,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Ingredients : ",
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                              SizedBox(height: 5),
                              Container(
                                height: 100,
                                width: 550,
                                child: ListView.builder(
                                  itemCount:
                                      widget.coffeePass?.ingredients?.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Text(
                                      (widget.coffeePass?.ingredients?[index] !=
                                              "None")
                                          ? "\u2022 ${widget.coffeePass?.ingredients?[index]}"
                                          : "None",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.brown[300],
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Cart Icon
            GestureDetector(
              onTap: () {
                // Handle cart action
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Item added to cart")),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.shopping_cart,
                  size: 30,
                  color: Colors.brown[300],
                ),
              ),
            ),
            // Buy Now Button
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ElevatedButton(
                  onPressed: () {
                    // Tampilkan overlay notifikasi
                    showOrderOverlay(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        255, 243, 198, 129), // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30), // Rounded corners
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text(
                    "Buy Now",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
