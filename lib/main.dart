import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BookingCalendarPage(),
    );
  }
}

class BookingCalendarPage extends StatefulWidget {
  const BookingCalendarPage({super.key});

  @override
  _BookingCalendarPageState createState() => _BookingCalendarPageState();
}

class _BookingCalendarPageState extends State<BookingCalendarPage> {
  int year = 2024;
  int month = 10;
  int day = 1;

  final TextEditingController eventController = TextEditingController();
  final TextEditingController yearController = TextEditingController();

  final Map<String, List<String>> bookings = {};

  int bookedDays = 0;
  int availableDays = 0;

  String? selectedDateKey;

  void incrementMonth() {
    setState(() {
      if (month == 12) {
        month = 1;
        year += 1;
      } else {
        month += 1;
      }
    });
  }

  void decrementMonth() {
    setState(() {
      if (month == 1) {
        month = 12;
        year -= 1;
      } else {
        month -= 1;
      }
    });
  }

  void showBookings(BuildContext context, int day) {
    final dateKey = "$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";
    final dayBookings = bookings[dateKey] ?? ["No bookings available"];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Bookings for $dateKey"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...dayBookings.map(
                    (booking) => Text(booking, style: const TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  addBooking(context, dateKey);
                },
                child: const Text("Add Booking"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void addBooking(BuildContext context, String dateKey) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Booking for $dateKey"),
          content: TextField(
            controller: eventController,
            decoration: const InputDecoration(hintText: "Enter booking details"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  bookings.putIfAbsent(dateKey, () => []);
                  bookings[dateKey]!.add(eventController.text);
                  eventController.clear();
                });
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int daysInMonth = DateTime(year, month + 1, 0).day;
    int firstDayIndex = DateTime(year, month, 1).weekday % 7;

    bookedDays = bookings.values.fold(0, (sum, dayBookings) {
      return sum + dayBookings.length;
    });
    availableDays = daysInMonth - bookedDays;

    final constructedSelectedDateKey =
        "$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: day,
                      decoration: const InputDecoration(labelText: "Day"),
                      dropdownColor: Colors.white,
                      items: List.generate(
                        DateTime(year, month + 1, 0).day,
                            (index) => DropdownMenuItem(
                          value: index + 1,
                          child: Text(
                            (index + 1).toString(),
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          if (value != null) day = value;
                        });
                      },
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: month,
                      decoration: const InputDecoration(labelText: "Month"),
                      dropdownColor: Colors.white,
                      items: List.generate(
                        12,
                            (index) => DropdownMenuItem(
                          value: index + 1,
                          child: Text(
                            monthNames[index],
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          if (value != null) month = value;
                        });
                      },
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: yearController,
                      decoration: const InputDecoration(labelText: "Year"),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          year = int.tryParse(value) ?? year;
                        });
                      },
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.purple, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Homestay Astana Ria D\'Raja',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '$year',
                          style: TextStyle(fontSize: 28, color: Colors.purple[900], fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      monthNames[month - 1].toUpperCase(),
                      style: TextStyle(fontSize: 28, color: Colors.purple[900], fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      color: Colors.purple,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(child: Center(child: Text('SUN', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)))),
                          Expanded(child: Center(child: Text('MON', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)))),
                          Expanded(child: Center(child: Text('TUE', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)))),
                          Expanded(child: Center(child: Text('WED', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)))),
                          Expanded(child: Center(child: Text('THU', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)))),
                          Expanded(child: Center(child: Text('FRI', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)))),
                          Expanded(child: Center(child: Text('SAT', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: daysInMonth + firstDayIndex,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        childAspectRatio: 1.2,
                      ),
                      itemBuilder: (context, index) {
                        final day = (index >= firstDayIndex) ? (index - firstDayIndex + 1) : null;

                        final dateKey = day != null
                            ? "$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}"
                            : null;
                        final hasBooking = dateKey != null && bookings.containsKey(dateKey);

                        final isSelectedDay = dateKey == constructedSelectedDateKey;

                        return GestureDetector(
                          onTap: day != null ? () => showBookings(context, day) : null,
                          child: Container(
                            margin: const EdgeInsets.all(2),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: hasBooking
                                  ? Colors.red[300]
                                  : (isSelectedDay ? Colors.green : Colors.white),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.purple),
                            ),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    day != null ? '$day' : '',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: hasBooking ? Colors.black : Colors.black,
                                    ),
                                  ),
                                ),
                                if (hasBooking)
                                  const Align(
                                    alignment: Alignment.bottomRight,
                                    child: Icon(
                                      Icons.calendar_today,
                                      size: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_left, size: 32),
                    onPressed: decrementMonth,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.search),
                    label: const Text('CARIAN'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_right, size: 32),
                    onPressed: incrementMonth,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'BOOKED',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '$bookedDays',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'DAYS',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(width: 40),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'AVAILABLE',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '$availableDays',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'DAYS',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  final List<String> monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
}