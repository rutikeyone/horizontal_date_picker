import 'package:flutter/material.dart';
import 'package:horizontal_date_picker/date_picker_timeline.dart';
import 'package:horizontal_date_picker/gestures/tap.dart';
import 'package:intl/intl.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final DatePickerController _controller = DatePickerController();
  DateTime _selectedValue = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.replay),
          onPressed: () {
            _controller.animateToSelection();
          },
        ),
        body: Container(
          padding: const EdgeInsets.all(20.0),
          color: Colors.blueGrey[100],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text("You Selected:"),
              const Padding(padding: EdgeInsets.all(10)),
              Text(_selectedValue.toString()),
              const Padding(padding: EdgeInsets.all(20)),
              DatePicker(
                DateTime.now(),
                width: 44,
                height: 72,
                controller: _controller,
                initialSelectedDate: DateTime.now(),
                selectionColor: Colors.black,
                selectedTextColor: Colors.white,
                dateTextStyle: const TextStyle(fontSize: 14),
                dayTextStyle: const TextStyle(fontSize: 14),
                inactiveDates: [
                  DateTime.now().add(const Duration(days: 3)),
                  DateTime.now().add(const Duration(days: 4)),
                  DateTime.now().add(const Duration(days: 7))
                ],
                onDateWidgetBuilder: _onDayWidgetBuilder,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(8),
                ),
                deactivateDecoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(8),
                ),
                selectedDecoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                onDateChange: (date) {
                  setState(() {
                    _selectedValue = date;
                  });
                },
              ),
            ],
          ),
        ));
  }

  Widget _onDayWidgetBuilder(
    double? width,
    DateTime date,
    TextStyle? monthTextStyle,
    TextStyle? dayTextStyle,
    TextStyle? dateTextStyle,
    Color selectionColor,
    DateSelectionCallback? onDateSelected,
    String? locale,
    BoxDecoration? decoration,
  ) {
    return InkWell(
      child: Container(
        constraints: width != null ? BoxConstraints(minWidth: width) : null,
        margin: const EdgeInsets.all(3.0),
        decoration: decoration ??
            BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              color: selectionColor,
            ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                  DateFormat(DateFormat.ABBR_WEEKDAY, locale)
                      .format(date)
                      .toUpperCase(), // WeekDay
                  style: dayTextStyle),
              Text(date.day.toString(), // Date
                  style: dateTextStyle),
            ],
          ),
        ),
      ),
      onTap: () {
        // Check if onDateSelected is not null
        if (onDateSelected != null) {
          // Call the onDateSelected Function
          onDateSelected!(date);
        }
      },
    );
  }
}
