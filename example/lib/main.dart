import 'package:flutter/material.dart';
import 'package:horizontal_date_picker/date_picker_timeline.dart';
import 'package:horizontal_date_picker/gestures/tap.dart';
import 'package:intl/intl.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DatePicker(
              DateTime(2023, 2, 13),
              width: 44,
              height: 72,
              monthBuilder: _monthBuilder,
              controller: _controller,
              selectionColor: Colors.black,
              selectedTextColor: Colors.white,
              maxDateTime: DateTime(2023, 8, 1),
              isMonthManager: true,
              dateTextStyle: const TextStyle(fontSize: 14),
              dayTextStyle: const TextStyle(fontSize: 14),
              inactiveDates: [
                DateTime(2023, 2, 15).add(const Duration(days: 3)),
                DateTime(2023, 2, 15).add(const Duration(days: 4)),
                DateTime(2023, 2, 15).add(const Duration(days: 7))
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
              itemSpacing: 1.5,
              onDateChange: (date) {
                setState(() {
                  _selectedValue = date;
                });
              },
            ),
          ],
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
    bool isDeactivated,
  ) {
    return InkWell(
      onTap: isDeactivated
          ? null
          : () {
              if (onDateSelected != null) {
                onDateSelected!(date);
              }
            },
      child: Container(
        width: width,
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
                      .toUpperCase(),
                  maxLines: 1, // WeekDay
                  style: dayTextStyle),
              Text(date.day.toString(), // Date
                  style: dateTextStyle),
            ],
          ),
        ),
      ),
    );
  }

  Widget _monthBuilder(
      DateTime date, String monthValue, DateTime? initialSelectedDate) {
    return Text(
      _selectedValue.toString(),
      style: const TextStyle(color: Colors.red, fontSize: 18),
    );
  }
}
