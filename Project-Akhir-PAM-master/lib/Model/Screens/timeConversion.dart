import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CoffeeShopHoursConversion extends StatefulWidget {
  const CoffeeShopHoursConversion({Key? key}) : super(key: key);

  @override
  State<CoffeeShopHoursConversion> createState() =>
      _CoffeeShopHoursConversionState();
}

class _CoffeeShopHoursConversionState extends State<CoffeeShopHoursConversion> {
  String selectedTimeZoneFrom = 'WIB'; // Time zone from
  String selectedTimeZoneTo = 'WIB'; // Time zone to
  String outputText = '';
  TimeOfDay selectedTime =
      TimeOfDay(hour: 8, minute: 0); // Default time is 08:00

  // Convert the selected time from the chosen time zone to the target time zone
  void convertTime() {
    // Convert the selected time to a DateTime object
    DateTime selectedDateTime =
        DateTime(2022, 1, 1, selectedTime.hour, selectedTime.minute);

    // Adjust the selected time for the selected source and target time zones
    DateTime finalConvertedTime = adjustToTargetTimeZone(selectedDateTime);

    setState(() {
      outputText =
          '${DateFormat('HH:mm').format(finalConvertedTime)} $selectedTimeZoneTo'; // Display in the target time zone
    });
  }

  // Adjust the time based on selected time zones and convert it to the target time zone
  DateTime adjustToTargetTimeZone(DateTime time) {
    int offsetFrom = getTimeZoneOffset(selectedTimeZoneFrom);
    int offsetTo = getTimeZoneOffset(selectedTimeZoneTo);

    // Adjust the time based on the difference between the source and target time zone
    int difference = offsetTo - offsetFrom;
    return time.add(Duration(hours: difference));
  }

  // Get the time zone offset to WIB (UTC +7)
  int getTimeZoneOffset(String timeZone) {
    switch (timeZone) {
      case 'WIB': // Western Indonesia Time (UTC +7)
        return 0;
      case 'WITA': // Central Indonesia Time (UTC +8)
        return 1; // WITA to WIB is 1 hour ahead
      case 'WIT': // Eastern Indonesia Time (UTC +9)
        return 2; // WIT to WIB is 2 hours ahead
      case 'London': // London Time (UTC +0)
        return -7; // London to WIB is -7 hours
      default:
        return 0; // Default to WIB if something goes wrong
    }
  }

  // Open the Time Picker to select the time
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
      convertTime(); // Update time when user selects a new time
    }
  }

  // Get menu recommendations based on the selected time
  String getMenuRecommendation() {
    // Determine the time of the day
    int hour = selectedTime.hour;

    // Recommend menu based on time
    if (hour < 10) {
      return "Recommended: Fresh Brewed Coffee & Croissants for breakfast!";
    } else if (hour >= 10 && hour < 14) {
      return "Recommended: Iced Latte & Sandwiches for lunch!";
    } else if (hour >= 14 && hour < 18) {
      return "Recommended: Cappuccino & Cake for your afternoon break!";
    } else {
      return "Recommended: Hot Chocolate & Cookies for a cozy evening!";
    }
  }

  @override
  void initState() {
    super.initState();
    convertTime(); // Initialize the output text based on default time zone
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Coffee Time",
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              fontSize: 22),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.brown[400],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "assets/coffee_background.jpg"), // Add a coffee background image
            fit: BoxFit.cover,
            opacity: 0.3, // Slight opacity to make text stand out
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header with a coffee cup icon and text
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.local_cafe, size: 40, color: Colors.brown[700]),
                SizedBox(width: 8),
                Text(
                  "Coffee Time Zone Converter",
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                      color: Colors.brown[700]),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Dropdown to select the source time zone
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.brown),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButton<String>(
                value: selectedTimeZoneFrom,
                onChanged: (value) {
                  setState(() {
                    selectedTimeZoneFrom = value!;
                  });
                  convertTime(); // Update the time when the source time zone changes
                },
                items: ['WIB', 'WITA', 'WIT', 'London'].map((timeZone) {
                  return DropdownMenuItem<String>(
                    value: timeZone,
                    child: Text(
                      timeZone,
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          color: Colors.brown),
                    ),
                  );
                }).toList(),
                underline: Container(),
              ),
            ),
            SizedBox(height: 16),

            // Dropdown to select the target time zone
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.brown),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButton<String>(
                value: selectedTimeZoneTo,
                onChanged: (value) {
                  setState(() {
                    selectedTimeZoneTo = value!;
                  });
                  convertTime(); // Update the time when the target time zone changes
                },
                items: ['WIB', 'WITA', 'WIT', 'London'].map((timeZone) {
                  return DropdownMenuItem<String>(
                    value: timeZone,
                    child: Text(
                      timeZone,
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          color: Colors.brown),
                    ),
                  );
                }).toList(),
                underline: Container(),
              ),
            ),
            SizedBox(height: 16),

            // Display the selected time with a coffee cup icon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Selected Time: ${selectedTime.format(context)}",
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.brown[700]),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.access_time, color: Colors.brown[700]),
                  onPressed: () => _selectTime(context),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Display the converted time
            Center(
              child: Container(
                width: 250, // Set a fixed width for the container
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.brown),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Text(
                  outputText,
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.brown[700]),
                ),
              ),
            ),
            SizedBox(height: 24),

            // Display coffee shop related information with fun copy
            Text(
              'When it’s coffee o’clock somewhere...',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 18,
                  color: Colors.brown[700]),
            ),
            SizedBox(height: 16),

            // Display the menu recommendation based on the selected time
            Text(
              getMenuRecommendation(),
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 18,
                  color: Colors.brown[700]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
