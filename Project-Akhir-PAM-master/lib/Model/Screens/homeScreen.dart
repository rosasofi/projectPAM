import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // Untuk mendapatkan lokasi
import 'package:project_pam/Helper/sharedPreference.dart';
import '../Screens/allCoffeePage.dart';
import '../Screens/homePage.dart';
import '../Screens/timeConversion.dart';
import 'dart:ui'; // For BackdropFilter

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String username = "!"; // Example username
  String currentLocation = "Getting location..."; // Default location text

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Get the current location when screen is loaded
  }

  // Function to get current location using Geolocator
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // If location services are not enabled, show a message
      setState(() {
        currentLocation = "Location services are disabled.";
      });
      return;
    }

    // Check if we have permission to access the location
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Request permission if it was denied
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        setState(() {
          currentLocation = "Location permission denied.";
        });
        return;
      }
    }

    // Get the current position (latitude and longitude)
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Convert coordinates to a human-readable address (optional)
    setState(() {
      currentLocation =
          "Lat: ${position.latitude}, Long: ${position.longitude}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Home Page",
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown[300],
          title: const Text(
            "Home Page",
            style: TextStyle(
                fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                SharedPreference().setLogout();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                    (route) => false);
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: SafeArea(
          child: Stack(
            children: [
              // Background Image with Blur Effect
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    color: Colors.black
                        .withOpacity(0.3), // Semi-transparent overlay
                    child: Image.asset(
                      'assets/images/coffee.jpg', // Your background image
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              // Content on top of the background
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome Section with Username and Notification Icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Welcome",
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 255, 255, 255),
                                fontSize: 20), // Reduced size for Welcome
                          ),
                          IconButton(
                            icon: Icon(Icons.notifications),
                            onPressed: () {
                              // Handle notification action
                            },
                            iconSize: 30,
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Current Location Section
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              color: const Color.fromARGB(255, 255, 255, 255),
                              size: 20), // Smaller location icon
                          const SizedBox(width: 8),
                          Text(
                            currentLocation,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize:
                                  14, // Smaller font size for location text
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Today's Promo Section with Lightning Icon
                      Row(
                        children: [
                          Icon(
                            Icons.flash_on, // Petir icon
                            color: Colors.orange[600], // Icon warna oranye
                            size: 28, // Ukuran icon
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Today's Promo",
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ), // Reduced promo text size
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 200, // Reduced height for promo cards
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildPromoCard(
                                '50% Off',
                                'On all coffee orders',
                                const Color.fromARGB(255, 254, 159, 16),
                                'assets/images/promo1.jpg'),
                            _buildPromoCard(
                                'Buy 1 Get 1 Free',
                                'On all Coffee',
                                const Color.fromARGB(255, 254, 159, 16),
                                'assets/images/promo2.jpg'),
                            _buildPromoCard(
                                'Free Coffee',
                                'On orders above \$20',
                                const Color.fromARGB(255, 254, 159, 16),
                                'assets/images/promo3.jpg'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Button Section for Products and Opening Time
                      _buildButton(
                        icon: Icons.local_cafe,
                        text: "Products",
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return AllCoffee();
                          }));
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildButton(
                        icon: Icons.access_time,
                        text: "Opening Time",
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return CoffeeShopHoursConversion();
                          }));
                        },
                      ),

                      const SizedBox(
                          height: 30), // Add space before reviews section

                      // Move User Reviews to the bottom
                      _buildUserReviews(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to create User Reviews section
  Widget _buildUserReviews() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Center the "User Reviews" text
        Center(
          child: Text(
            "User Reviews",
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Review 1
        _buildReview(
          "John Doe",
          "Great coffee! Love the atmosphere.",
          5,
        ),
        const SizedBox(height: 10),
        // Review 2
        _buildReview(
          "Jane Smith",
          "The Black Coffe are fantastic. Will visit again!",
          4,
        ),
        const SizedBox(height: 10),
        // Review 3
        _buildReview(
          "Alice Johnson",
          "Good service, but the coffee could be hotter.",
          4,
        ),
      ],
    );
  }

  // Function to create individual reviews with name, text, and rating
  Widget _buildReview(String name, String reviewText, int rating) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile image placeholder (could be replaced with actual image)
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.brown[200],
              child: Text(
                name[0], // Show the first letter of the name
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 10),
            // Review details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    reviewText,
                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 14),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: List.generate(
                      rating,
                      (index) => const Icon(
                        Icons.star,
                        color: Colors.orange,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to create buttons for Products and Opening Time
  Widget _buildButton(
      {required IconData icon,
      required String text,
      required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      icon:
          Icon(icon, size: 20, color: Colors.white), // Set icon color to white
      label: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontFamily: 'Montserrat',
          color: Colors.white, // Set text color to white
        ),
      ),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.brown[300], // Keep the background color
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        textStyle: const TextStyle(fontSize: 16, fontFamily: 'Montserrat'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // Function to create Promo Cards
  Widget _buildPromoCard(
      String title, String subtitle, Color color, String image) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 200,
          child: Stack(
            children: [
              Image.asset(image,
                  fit: BoxFit.cover, height: 200, width: double.infinity),
              Positioned(
                bottom: 20,
                left: 10,
                child: Text(
                  title,
                  style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Positioned(
                bottom: 5,
                left: 10,
                child: Text(
                  subtitle,
                  style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.normal),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
