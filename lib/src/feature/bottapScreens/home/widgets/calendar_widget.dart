// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';

// import 'package:hocflutter/config/constants/colors.dart';

// class CalendarWidget extends StatefulWidget {
//   final DateTime focusedDay;
//   final DateTime? startDate;
//   final DateTime? endDate;
//   final ValueChanged<DateTime> onDaySelected;
  
//   const CalendarWidget({
//     Key? key,
//     required this.focusedDay,
//     this.startDate,
//     this.endDate,
//     required this.onDaySelected,
//   }) : super(key: key);

//   @override
//   State<CalendarWidget> createState() => _CalendarWidgetState();
// }

// class _CalendarWidgetState extends State<CalendarWidget> {
//   late DateTime _focusedDay;

  
//   @override
//   void innitState() {
//     super.initState();
//     _focusedDay = widget.focusedDay;
//   }

//     void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
//     setState(() {
//       _focusedDay = focusedDay;
//       if (widget.startDate == null) {
//         widget.startDate = selectedDay;
//         selectedDays.clear();
//         selectedDays.add(selectedDay);
//       } else if (selectedDays.contains(selectedDay)) {
//         selectedDays.remove(selectedDay);
//       } else {
//         if (selectedDays.length >= 2) {
//           selectedDays.clear();
//         }
//         selectedDays.add(selectedDay);
//       }
//       selectedDays.sort((a, b) => a.compareTo(b));

//       if (selectedDays.isNotEmpty) {
//         widget.startDate = DateTime(selectedDays.first.year, selectedDays.first.month,
//             selectedDays.first.day, 0, 0, 0);
//         _endDate = DateTime(selectedDays.last.year, selectedDays.last.month,
//             selectedDays.last.day, 23, 59, 59);
//       } else {
//         widget.startDate = null;
//         _endDate = null;
//       }
//     });

//     _checkAndFetchTasks();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       child: TableCalendar(
//         headerStyle: const HeaderStyle(
//           formatButtonVisible: false,
//           titleCentered: true,
//           headerMargin: EdgeInsets.only(bottom: 16),
//           titleTextStyle: TextStyle(
//             fontSize: 20.0,
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//           ),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
//           ),
//         ),
//         availableGestures: AvailableGestures.all,
//         rowHeight: 60,
//         selectedDayPredicate: (day) {
//           return isSameDay(day, widget.startDate) || isSameDay(day, widget.endDate);
//         },
//         focusedDay: _focusedDay,
//         firstDay: DateTime.utc(2010, 08, 08),
//         lastDay: DateTime.utc(2025, 12, 12),
//         onDaySelected: _onDaySelected,
//         onPageChanged: (focusedDay) {
//           setState(() {
//             _focusedDay = focusedDay;
//           });
//         },
//         calendarStyle: CalendarStyle(
//           cellMargin: const EdgeInsets.all(6.0),
//           outsideDaysVisible: false,
//           defaultDecoration: BoxDecoration(
//             color: Colors.white,
//             shape: BoxShape.rectangle,
//             borderRadius: BorderRadius.circular(8.0),
//             border: Border.all(color: Colors.grey.shade300, width: 1.0),
//           ),
//           weekendDecoration: BoxDecoration(
//             color: Colors.white,
//             shape: BoxShape.rectangle,
//             borderRadius: BorderRadius.circular(8.0),
//             border: Border.all(color: Colors.grey.shade300, width: 1.0),
//           ),
//           outsideDecoration: BoxDecoration(
//             color: Colors.white,
//             shape: BoxShape.rectangle,
//             borderRadius: BorderRadius.circular(8.0),
//             border: Border.all(color: Colors.grey.shade300, width: 1.0),
//           ),
//           todayDecoration: BoxDecoration(
//             color: Colors.indigo.shade200,
//             shape: BoxShape.rectangle,
//             borderRadius: BorderRadius.circular(8.0),
//             border: Border.all(color: dark_blue, width: 1.0),
//           ),
//           selectedDecoration: BoxDecoration(
//             color: dark_blue,
//             shape: BoxShape.rectangle,
//             borderRadius: BorderRadius.circular(8.0),
//             border: Border.all(color: Colors.blue.shade300, width: 1.0),
//           ),
//           rangeHighlightColor: Colors.blue.shade100.withOpacity(0.5),
//         ),
//       ),
//     );
//   }
// }
