import 'package:flutter/material.dart';
import 'package:horizontal_date_picker/date_widget.dart';
import 'package:horizontal_date_picker/gestures/tap.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'extra/color.dart';
import 'extra/style.dart';

class DatePicker extends StatefulWidget {
  final double height;

  final double width;

  final DateTime startDate;

  final DatePickerController controller;

  final Color selectedTextColor;

  final Color selectionColor;

  final Color deactivatedColor;

  final TextStyle monthTextStyle;

  final TextStyle dayTextStyle;

  final TextStyle dateTextStyle;

  final List<DateTime>? inactiveDates;

  final List<DateTime>? activeDates;

  final DateChangeListener? onDateChange;

  final String locale;

  final BoxDecoration? selectedDecoration;

  final BoxDecoration? decoration;

  final BoxDecoration? deactivateDecoration;

  final DateWidget? dateWidget;

  final bool isMonthManager;

  final TextStyle? monthHeaderTextStyle;

  final DateTime maxDateTime;

  final num itemSpacing;

  final Function(bool)? previousIconBuilder;

  final Function(bool)? nextIconBuilder;

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

  const DatePicker(
    this.startDate, {
    super.key,
    required this.controller,
    required this.maxDateTime,
    required this.itemSpacing,
    this.width = 60,
    this.height = 80,
    this.monthTextStyle = defaultMonthTextStyle,
    this.dayTextStyle = defaultDayTextStyle,
    this.dateTextStyle = defaultDateTextStyle,
    this.selectedTextColor = Colors.white,
    this.selectionColor = AppColors.defaultSelectionColor,
    this.deactivatedColor = AppColors.defaultDeactivatedColor,
    this.activeDates,
    this.inactiveDates,
    this.onDateChange,
    this.locale = "en_US",
    this.decoration,
    this.deactivateDecoration,
    this.selectedDecoration,
    this.dateWidget,
    this.onDateWidgetBuilder,
    this.isMonthManager = false,
    this.monthHeaderTextStyle,
    this.nextIconBuilder,
    this.previousIconBuilder,
  }) : assert(
            activeDates == null || inactiveDates == null,
            "Can't "
            "provide both activated and deactivated dates List at the same time.");

  @override
  State<StatefulWidget> createState() => DatePickerState();
}

class DatePickerState extends State<DatePicker> {
  late DateTime _currentDate;

  final ScrollController _controller = ScrollController();

  late final _monthDateFormat = DateFormat("MMMM", widget.locale);

  late DateTime _currentMonth = widget.startDate;

  late final TextStyle selectedDateStyle;
  late final TextStyle selectedMonthStyle;
  late final TextStyle selectedDayStyle;

  late final TextStyle deactivatedDateStyle;
  late final TextStyle deactivatedMonthStyle;
  late final TextStyle deactivatedDayStyle;

  bool isListenChangeMonth = true;

  String get _currentMonthValue => _monthDateFormat.format(_currentMonth);

  int get daysCount => widget.maxDateTime.difference(widget.startDate).inDays;

  bool get isCanNextMonth =>
      widget.maxDateTime
              .difference(
                  DateTime(_currentDate.year, _currentMonth.month + 1, 1))
              .inDays >=
          0 &&
      isListenChangeMonth;

  bool get isCanPreviousMonth =>
      DateTime(_currentDate.year, _currentMonth.month, 1)
              .difference(widget.startDate)
              .inDays >=
          1 &&
      isListenChangeMonth;

  List<DateTime> get dates {
    final generatedDates = List.generate(
        daysCount, (index) => widget.startDate.add(Duration(days: index)));
    final nextDay = generatedDates.last.add(const Duration(days: 1));
    return generatedDates..add(nextDay);
  }

  @override
  void initState() {
    initializeDateFormatting(widget.locale);
    _currentDate = widget.startDate;
    widget.controller.setDatePickerState(this);
    selectedDateStyle =
        widget.dateTextStyle.copyWith(color: widget.selectedTextColor);
    selectedMonthStyle =
        widget.monthTextStyle.copyWith(color: widget.selectedTextColor);
    selectedDayStyle =
        widget.dayTextStyle.copyWith(color: widget.selectedTextColor);

    deactivatedDateStyle =
        widget.dateTextStyle.copyWith(color: widget.deactivatedColor);
    deactivatedMonthStyle =
        widget.monthTextStyle.copyWith(color: widget.deactivatedColor);
    deactivatedDayStyle =
        widget.dayTextStyle.copyWith(color: widget.deactivatedColor);
    _controller.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    super.dispose();
  }

  void _setNextMonth() {
    final nextMonthDateTime =
        DateTime(_currentDate.year, _currentMonth.month + 1, 1);
    setState(() {
      if (nextMonthDateTime.compareTo(widget.maxDateTime) >= -1) {
        isListenChangeMonth = false;
        _currentMonth = nextMonthDateTime;
        widget.controller.animateToDate(
          nextMonthDateTime,
          onFinishCallback: () => setState(() {
            isListenChangeMonth = true;
          }),
        );
      }
    });
  }

  void _setPreviousMonth() {
    final previousMonthDateTime =
        DateTime(_currentDate.year, _currentMonth.month - 1, 1);
    setState(() {
      if (previousMonthDateTime.compareTo(widget.maxDateTime) < 1) {
        isListenChangeMonth = false;
        _currentMonth = previousMonthDateTime;
        widget.controller.animateToDate(
          previousMonthDateTime,
          onFinishCallback: () => setState(() {
            isListenChangeMonth = true;
          }),
        );
      }
    });
  }

  void _updateMonth(DateTime date) {
    if (_currentMonth.month != date.month) {
      setState(() {
        _currentMonth = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.isMonthManager
            ? Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed:
                            isCanPreviousMonth ? _setPreviousMonth : null,
                        icon: widget.previousIconBuilder != null
                            ? widget.previousIconBuilder!(isCanNextMonth)
                            : const Icon(Icons.arrow_back_ios)),
                    Text(_currentMonthValue,
                        style: widget.monthHeaderTextStyle ??
                            const TextStyle(color: Colors.black, fontSize: 18)),
                    IconButton(
                        onPressed: isCanNextMonth ? _setNextMonth : null,
                        icon: widget.nextIconBuilder != null
                            ? widget.nextIconBuilder!(isCanNextMonth)
                            : const Icon(Icons.arrow_forward_ios)),
                  ],
                ),
              )
            : const SizedBox.shrink(),
        SizedBox(
          height: widget.height,
          child: ListView.builder(
            itemCount: dates.length,
            scrollDirection: Axis.horizontal,
            controller: _controller,
            itemBuilder: (context, index) {
              DateTime date;
              date = DateTime(
                  dates[index].year, dates[index].month, dates[index].day);
              bool isDeactivated = false;

              if (widget.inactiveDates != null) {
                for (DateTime inactiveDate in widget.inactiveDates!) {
                  if (_compareDate(date, inactiveDate)) {
                    isDeactivated = true;
                    break;
                  }
                }
              }

              if (widget.activeDates != null) {
                isDeactivated = true;
                for (DateTime activateDate in widget.activeDates!) {
                  if (_compareDate(date, activateDate)) {
                    isDeactivated = false;
                    break;
                  }
                }
              }

              bool isSelected = _compareDate(date, _currentDate);

              return DateWidget(
                decoration: isDeactivated
                    ? widget.deactivateDecoration
                    : isSelected
                        ? widget.selectedDecoration
                        : widget.decoration,
                onDateWidgetBuilder: widget.onDateWidgetBuilder,
                date: date,
                monthTextStyle: isDeactivated
                    ? deactivatedMonthStyle
                    : isSelected
                        ? selectedMonthStyle
                        : widget.monthTextStyle,
                dateTextStyle: isDeactivated
                    ? deactivatedDateStyle
                    : isSelected
                        ? selectedDateStyle
                        : widget.dateTextStyle,
                dayTextStyle: isDeactivated
                    ? deactivatedDayStyle
                    : isSelected
                        ? selectedDayStyle
                        : widget.dayTextStyle,
                width: widget.width,
                locale: widget.locale,
                selectionColor:
                    isSelected ? widget.selectionColor : Colors.transparent,
                onDateSelected: (selectedDate) {
                  if (isDeactivated) return;
                  if (widget.onDateChange != null) {
                    widget.onDateChange!(selectedDate);
                  }
                  setState(() {
                    _currentDate = selectedDate;
                    _currentMonth = selectedDate;
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  bool _compareDate(DateTime date1, DateTime date2) {
    return date1.day == date2.day &&
        date1.month == date2.month &&
        date1.year == date2.year;
  }

  void _scrollListener() {
    double currentPosition = _controller.position.pixels;
    int currentIndex = _controller.position.maxScrollExtent == currentPosition
        ? daysCount - 1
        : (_controller.offset /
                _controller.position.maxScrollExtent *
                daysCount)
            .floor();
    if (isListenChangeMonth) _updateMonth(dates[currentIndex]);
  }
}

class DatePickerController {
  DatePickerState? _datePickerState;

  void setDatePickerState(DatePickerState state) {
    _datePickerState = state;
  }

  void jumpToSelection() {
    assert(_datePickerState != null,
        'DatePickerController is not attached to any DatePicker View.');

    _datePickerState!._controller
        .jumpTo(_calculateDateOffset(_datePickerState!._currentDate!));
  }

  void animateToSelection(
      {duration = const Duration(milliseconds: 500), curve = Curves.linear}) {
    assert(_datePickerState != null,
        'DatePickerController is not attached to any DatePicker View.');

    // animate to the current date
    _datePickerState!._controller.animateTo(
        _calculateDateOffset(_datePickerState!._currentDate!),
        duration: duration,
        curve: curve);
  }

  void animateToDate(
    DateTime date, {
    duration = const Duration(milliseconds: 500),
    curve = Curves.linear,
    VoidCallback? onFinishCallback,
  }) {
    assert(_datePickerState != null,
        'DatePickerController is not attached to any DatePicker View.');

    _datePickerState!._controller
        .animateTo(_calculateDateOffset(date), duration: duration, curve: curve)
        .whenComplete(
      () {
        if (onFinishCallback != null) {
          onFinishCallback();
        }
      },
    );
  }

  void setDateAndAnimate(DateTime date,
      {duration = const Duration(milliseconds: 500), curve = Curves.linear}) {
    assert(_datePickerState != null,
        'DatePickerController is not attached to any DatePicker View.');

    _datePickerState!._controller.animateTo(_calculateDateOffset(date),
        duration: duration, curve: curve);

    if (date.compareTo(_datePickerState!.widget.startDate) >= 0 &&
        date.compareTo(_datePickerState!.widget.startDate
                .add(Duration(days: _datePickerState!.daysCount))) <=
            0) {
      _datePickerState!._currentDate = date;
    }
  }

  double _calculateDateOffset(DateTime date) {
    final startDate = DateTime(
        _datePickerState!.widget.startDate.year,
        _datePickerState!.widget.startDate.month,
        _datePickerState!.widget.startDate.day);

    int offset = date.difference(startDate).inDays;
    return (offset * _datePickerState!.widget.width) +
        (offset * 6) +
        _datePickerState!.widget.itemSpacing;
  }
}
