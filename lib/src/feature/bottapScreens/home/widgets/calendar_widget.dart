import 'package:flutter/material.dart';
import 'package:hocflutter/src/config/constants/color/colors.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime, DateTime) onDaySelected;

  const CalendarWidget({
    Key? key,
    required this.startDate,
    required this.endDate,
    required this.onDaySelected,
  }) : super(key: key);

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _focusedDay;
  
  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now(); 
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: TableCalendar(
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          headerMargin: EdgeInsets.only(bottom: 16),
          titleTextStyle: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        availableGestures: AvailableGestures.all,
        rowHeight: 60,
        selectedDayPredicate: (day) {
          return isSameDay(day, widget.startDate) ||
              isSameDay(day, widget.endDate);
        },
        focusedDay: _focusedDay,
        firstDay: DateTime.utc(2010, 08, 08),
        lastDay: DateTime.utc(2025, 12, 12),
        onDaySelected: (selectedDay, focusedDay) {
          widget.onDaySelected(selectedDay, focusedDay);
          setState(() {
            _focusedDay = focusedDay;
          });
        },
        onPageChanged: (focusedDay) {
          setState(() {
            _focusedDay = focusedDay;
          });
        },
        calendarStyle: CalendarStyle(
          cellMargin: const EdgeInsets.all(6.0),
          outsideDaysVisible: false,
          defaultDecoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.grey.shade300, width: 1.0),
          ),
          weekendDecoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.grey.shade300, width: 1.0),
          ),
          todayDecoration: BoxDecoration(
            color: Colors.indigo.shade200,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color:dark_blue, width: 1.0),
          ),
          selectedDecoration: BoxDecoration(
            color: dark_blue,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: dark_blue, width: 1.0),
          ),
          rangeHighlightColor: Colors.blue.shade100.withOpacity(0.5),
        ),
      ),
    );
  }
}
