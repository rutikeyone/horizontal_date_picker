import 'package:flutter/material.dart';
import 'package:horizontal_date_picker/gestures/tap.dart';
import 'package:intl/intl.dart';

class DateWidget extends StatelessWidget {
  final double? width;
  final DateTime date;
  final TextStyle? monthTextStyle, dayTextStyle, dateTextStyle;
  final Color selectionColor;
  final DateSelectionCallback? onDateSelected;
  final String? locale;
  final Widget Function(
    double? width,
    DateTime date,
    TextStyle? monthTextStyle,
    TextStyle? dayTextStyle,
    TextStyle? dateTextStyle,
    Color selectionColor,
    DateSelectionCallback? onDateSelected,
    String? locale,
    BoxDecoration? decoration,
  )? onDateWidgetBuilder;
  final BoxDecoration? decoration;

  const DateWidget({
    super.key,
    required this.date,
    required this.monthTextStyle,
    required this.dayTextStyle,
    required this.dateTextStyle,
    required this.selectionColor,
    this.width,
    this.onDateSelected,
    this.locale,
    this.onDateWidgetBuilder,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return onDateWidgetBuilder != null
        ? onDateWidgetBuilder!(width, date, monthTextStyle, dayTextStyle,
            dateTextStyle, selectionColor, onDateSelected, locale, decoration)
        : InkWell(
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
                        DateFormat("MMM", locale)
                            .format(date)
                            .toUpperCase(), // Month
                        style: monthTextStyle),
                    Text(date.day.toString(), // Date
                        style: dateTextStyle),
                    Text(
                        DateFormat("E", locale)
                            .format(date)
                            .toUpperCase(), // WeekDay
                        style: dayTextStyle)
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
